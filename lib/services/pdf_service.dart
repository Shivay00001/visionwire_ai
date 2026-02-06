import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/study_pack.dart';

class PdfService {
  static final PdfService _instance = PdfService._internal();
  factory PdfService() => _instance;
  PdfService._internal();

  Future<Uint8List> generatePdf(StudyPack studyPack) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.nunitoRegular();
    final fontBold = await PdfGoogleFonts.nunitoBold();
    final fontItalic = await PdfGoogleFonts.nunitoItalic();

    // Title Page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'VisionWire AI',
                style: pw.TextStyle(font: fontBold, fontSize: 32, color: PdfColors.indigo),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Study Pack',
                style: pw.TextStyle(font: fontBold, fontSize: 28),
              ),
              pw.SizedBox(height: 40),
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.indigo, width: 2),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    pw.Text('${studyPack.className}', style: pw.TextStyle(font: fontBold, fontSize: 20)),
                    pw.SizedBox(height: 10),
                    pw.Text('${studyPack.subject}', style: pw.TextStyle(font: font, fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text('${studyPack.chapter}', style: pw.TextStyle(font: fontBold, fontSize: 22, color: PdfColors.indigo)),
                  ],
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Text('Language: ${studyPack.language}', style: pw.TextStyle(font: font, fontSize: 14)),
              pw.Text('Generated: ${studyPack.generatedOn}', style: pw.TextStyle(font: fontItalic, fontSize: 12)),
              pw.SizedBox(height: 20),
              pw.Text('Estimated Reading Time: ${studyPack.estimatedReadingTime} minutes', style: pw.TextStyle(font: font, fontSize: 14)),
            ],
          ),
        ),
      ),
    );

    // Summary Page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader('Summary', fontBold),
        build: (context) => [
          pw.Paragraph(
            text: studyPack.summary,
            style: pw.TextStyle(font: font, fontSize: 12, lineSpacing: 1.5),
          ),
        ],
      ),
    );

    // Important Points
    if (studyPack.importantPoints.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader('Important Points', fontBold),
          build: (context) => studyPack.importantPoints
              .map((point) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('• ', style: pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.indigo)),
                        pw.Expanded(child: pw.Text(point, style: pw.TextStyle(font: font, fontSize: 11))),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
    }

    // Formulas
    if (studyPack.formulas.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader('Formulas', fontBold),
          build: (context) => studyPack.formulas
              .map((formula) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 15),
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8),
                      color: PdfColors.grey100,
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(formula.formula, style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.indigo)),
                        pw.SizedBox(height: 5),
                        pw.Text('Meaning: ${formula.meaning}', style: pw.TextStyle(font: font, fontSize: 10)),
                        if (formula.notes.isNotEmpty) ...[
                          pw.SizedBox(height: 3),
                          pw.Text('Note: ${formula.notes}', style: pw.TextStyle(font: fontItalic, fontSize: 9)),
                        ],
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
    }

    // MCQs
    _addMcqPages(pdf, 'MCQs - Easy', studyPack.mcqEasy, font, fontBold, PdfColors.green);
    _addMcqPages(pdf, 'MCQs - Medium', studyPack.mcqMedium, font, fontBold, PdfColors.orange);
    _addMcqPages(pdf, 'MCQs - Hard', studyPack.mcqHard, font, fontBold, PdfColors.red);

    // Short Answer Questions
    if (studyPack.shortAnswers.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader('Short Answer Questions', fontBold),
          build: (context) => studyPack.shortAnswers
              .asMap()
              .entries
              .map((entry) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 15),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Q${entry.key + 1}. ${entry.value.question}', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                        pw.SizedBox(height: 5),
                        pw.Text('Ans: ${entry.value.answer}', style: pw.TextStyle(font: font, fontSize: 10)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
    }

    // Long Answer Questions
    if (studyPack.longAnswers.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader('Long Answer Questions', fontBold),
          build: (context) => studyPack.longAnswers
              .asMap()
              .entries
              .map((entry) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Q${entry.key + 1}. ${entry.value.question}', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                        pw.SizedBox(height: 8),
                        pw.Text('Ans: ${entry.value.answer}', style: pw.TextStyle(font: font, fontSize: 10, lineSpacing: 1.3)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
    }

    // Numericals
    if (studyPack.numericals.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildHeader('Numerical Problems', fontBold),
          build: (context) => studyPack.numericals
              .asMap()
              .entries
              .map((entry) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 20),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Problem ${entry.key + 1}:', style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.indigo)),
                        pw.SizedBox(height: 5),
                        pw.Text(entry.value.question, style: pw.TextStyle(font: font, fontSize: 10)),
                        pw.SizedBox(height: 8),
                        pw.Text('Solution:', style: pw.TextStyle(font: fontBold, fontSize: 10)),
                        pw.Text(entry.value.steps, style: pw.TextStyle(font: font, fontSize: 10)),
                        pw.SizedBox(height: 5),
                        pw.Text('Answer: ${entry.value.answer}', style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.green)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      );
    }

    // Revision Summary
    if (studyPack.revisionSummary.isNotEmpty) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Quick Revision', fontBold),
              pw.SizedBox(height: 20),
              ...studyPack.revisionSummary
                  .map((point) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 10),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 20,
                              height: 20,
                              decoration: const pw.BoxDecoration(
                                color: PdfColors.indigo,
                                shape: pw.BoxShape.circle,
                              ),
                              child: pw.Center(
                                child: pw.Text('✓', style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.white)),
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(child: pw.Text(point, style: pw.TextStyle(font: font, fontSize: 11))),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      );
    }

    // Footer Page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Generated by VisionWire AI', style: pw.TextStyle(font: fontBold, fontSize: 16, color: PdfColors.indigo)),
              pw.SizedBox(height: 20),
              pw.Text('Verify critical facts with official NCERT/exam sources.', style: pw.TextStyle(font: fontItalic, fontSize: 12)),
              pw.SizedBox(height: 10),
              pw.Text('UNVERIFIED_PYQ marks unverified items.', style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey)),
            ],
          ),
        ),
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(String title, pw.Font fontBold) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.indigo, width: 2)),
      ),
      child: pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 18, color: PdfColors.indigo)),
    );
  }

  void _addMcqPages(pw.Document pdf, String title, List<MCQ> mcqs, pw.Font font, pw.Font fontBold, PdfColor color) {
    if (mcqs.isEmpty) return;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 10),
          decoration: pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: color, width: 2)),
          ),
          child: pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 18, color: color)),
        ),
        build: (context) => mcqs
            .asMap()
            .entries
            .map((entry) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 15),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${entry.key + 1}. ${entry.value.question}', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                      pw.SizedBox(height: 5),
                      ...entry.value.options.asMap().entries.map((opt) {
                        final optionLabel = String.fromCharCode(65 + opt.key);
                        final isCorrect = entry.value.answer == optionLabel;
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 15, bottom: 2),
                          child: pw.Text(
                            '$optionLabel. ${opt.value}',
                            style: pw.TextStyle(
                              font: isCorrect ? fontBold : font,
                              fontSize: 10,
                              color: isCorrect ? PdfColors.green : PdfColors.black,
                            ),
                          ),
                        );
                      }),
                      pw.SizedBox(height: 5),
                      pw.Text('Answer: ${entry.value.answer}', style: pw.TextStyle(font: fontBold, fontSize: 9, color: PdfColors.green)),
                      pw.Text('Explanation: ${entry.value.explanation}', style: pw.TextStyle(font: font, fontSize: 9, color: PdfColors.grey700)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Future<void> printPdf(Uint8List pdfBytes) async {
    await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
  }

  Future<void> sharePdf(Uint8List pdfBytes, String fileName) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
  }
}
