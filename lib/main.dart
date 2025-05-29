import 'package:bithealth_front_end/view/pages/doctor_page.dart';
import 'package:bithealth_front_end/view/pages/forgot_password.dart';
import 'package:bithealth_front_end/view/pages/medical_shifts.dart';
import 'package:bithealth_front_end/view/pages/register_page.dart';
import 'package:bithealth_front_end/view/pages/login_page.dart';
import 'package:bithealth_front_end/view/pages/medicamento_page.dart';
import 'package:bithealth_front_end/view/pages/news_page.dart';
import 'package:bithealth_front_end/view/pages/services_page.dart';
import 'package:bithealth_front_end/view/pages/shift_schedule.dart';
import 'package:bithealth_front_end/view/pages/vaccination_page.dart';
import 'package:bithealth_front_end/view/pages/notifications_page.dart';
import 'package:flutter/material.dart';
import 'view/pages/home_page.dart';
import 'view/pages/maps_page.dart';

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
        '/medicos': (context) => const DoctorsPage(),
        '/notificacoes': (context) => const NotificationsPage(),
        '/mapa': (context) => const MapaPage(),
        '/plantoes':(context) => const SelecaoPlantaoScreen(),
        "/escala_plantao":(context) => const EscalaPlantaoScreen(),
        "/forgot-password": (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
