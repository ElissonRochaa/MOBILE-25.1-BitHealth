import 'package:bithealth_front_end/view/pages/doctor_page.dart';
import 'package:bithealth_front_end/provider/theme_provider.dart';
import 'package:bithealth_front_end/view/pages/forgot_password.dart';
import 'package:bithealth_front_end/theme/app_themes.dart';
import 'package:bithealth_front_end/view/pages/medical_shifts.dart';
import 'package:bithealth_front_end/view/pages/register_page.dart';
import 'package:bithealth_front_end/view/pages/login_page.dart';
import 'package:bithealth_front_end/view/pages/medicamento_page.dart';
import 'package:bithealth_front_end/view/pages/news_page.dart';
import 'package:bithealth_front_end/view/pages/reset_password.dart';
import 'package:bithealth_front_end/view/pages/services_page.dart';
import 'package:bithealth_front_end/view/pages/shift_schedule.dart';
import 'package:bithealth_front_end/view/pages/vaccination_page.dart';
import 'package:bithealth_front_end/view/pages/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/pages/home_page.dart';
import 'view/pages/maps_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const SaudeCorrentesApp(),
    ),
  );
}

class SaudeCorrentesApp extends StatelessWidget {
  const SaudeCorrentesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Saúde Correntes',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.isDarkMode 
              ? ThemeMode.dark 
              : ThemeMode.light,
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
            '/plantoes': (context) => const SelecaoPlantaoScreen(),
            "/escala_plantao": (context) => const EscalaPlantaoScreen(),
            "/forgot-password": (context) => const ForgotPasswordScreen(),
            "/resetar-senha": (context) => const ResetPasswordScreen(),
          },
        );
      },
    );
  }
}