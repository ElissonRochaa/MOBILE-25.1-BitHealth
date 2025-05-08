import 'package:bithealth_front_end/pages/doctor_page.dart';
import 'package:bithealth_front_end/pages/register_page.dart';
import 'package:bithealth_front_end/pages/login_page.dart';
import 'package:bithealth_front_end/pages/medicamento_page.dart';
import 'package:bithealth_front_end/pages/news_page.dart';
import 'package:bithealth_front_end/pages/services_page.dart';
import 'package:bithealth_front_end/pages/vaccination_page.dart';
import 'package:bithealth_front_end/pages/notifications_page.dart';
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
      routes: {
        '/home': (context) => const HomePage(),
        '/medicamentos': (context) => const MedicamentosPage(),
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/noticias': (context) => const NewsPage(),
        '/servicos': (context) => const ServicesPage(),
        '/vacinacao': (context) => const VaccinationPage(),
        '/medicos': (context) => const  DoctorsPage(),
        '/notificacoes': (context) => const  NotificationsPage()
      },
    );
  }
}
