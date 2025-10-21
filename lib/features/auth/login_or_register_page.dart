import 'package:flutter/material.dart';
import 'package:controle_financeiro/features/auth/login_page.dart';
import 'package:controle_financeiro/features/auth/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // Inicialmente, mostramos a página de login
  bool _showLoginPage = true;

  // Método para alternar entre as páginas
  void togglePages() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginPage) {
      // Passamos a função 'togglePages' para a LoginPage
      return LoginPage(onTap: togglePages);
    } else {
      // Passamos a função 'togglePages' para a RegisterPage
      return RegisterPage(onTap: togglePages);
    }
  }
}