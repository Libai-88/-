import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/app_theme.dart';
import 'main_navigation.dart';
import 'widgets/custom_splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const OurStoryApp());
}

class OurStoryApp extends StatefulWidget {
  const OurStoryApp({super.key});

  @override
  State<OurStoryApp> createState() => _OurStoryAppState();
}

class _OurStoryAppState extends State<OurStoryApp> {
  bool _showSplash = true;

  void _onSplashComplete() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Our Story',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _showSplash
          ? CustomSplashScreen(onComplete: _onSplashComplete)
          : const MainNavigation(),
    );
  }
}
