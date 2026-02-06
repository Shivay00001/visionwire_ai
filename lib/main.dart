import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/themes.dart';
import 'providers/study_pack_provider.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  final storageService = StorageService();
  await storageService.init();
  
  runApp(const VisionWireApp());
}

class VisionWireApp extends StatelessWidget {
  const VisionWireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudyPackProvider(),
      child: MaterialApp(
        title: 'VisionWire AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
