import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'main_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OurStoryApp());
}

class OurStoryApp extends StatelessWidget {
  const OurStoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Story',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}
