import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:controle_financeiro/features/auth/login_or_register_page.dart';
import 'package:controle_financeiro/features/dashboard/home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta em tempo real as mudanças no estado de autenticação
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        
        // 1. Se estiver carregando (verificando o token)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 2. Se o usuário ESTÁ logado (snapshot.hasData é true)
        if (snapshot.hasData) {
          return const HomePage(); // Mostra a tela principal
        }

        // 3. Se o usuário NÃO está logado
        return const LoginOrRegisterPage(); // Mostra o fluxo de login/cadastro
      },
    );
  }
}