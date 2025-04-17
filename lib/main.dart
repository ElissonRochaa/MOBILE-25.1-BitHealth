import 'package:flutter/material.dart';
import './pages/home_page.dart';

void main() {
  runApp(const SaudeCorrentesApp());
}

class SaudeCorrentesApp extends StatelessWidget {
  const SaudeCorrentesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saúde Correntes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFEFF6FF),
      ),
      home: const HomePage(),
    );
  }
}
