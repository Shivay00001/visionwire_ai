import 'package:flutter/material.dart';

void main() { runApp(const MyApp()); }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'visionwire ai',
      theme: ThemeData(brightness: Brightness.dark, primaryColor: const Color(0xFF6366F1), scaffoldBackgroundColor: const Color(0xFF0F172A)),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('visionwire ai', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            const Text('Next-generation enterprise software platform.', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
              onPressed: () {},
              child: const Text('Launch Application'),
            ),
          ],
        ),
      ),
    );
  }
}
