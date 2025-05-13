// screens/auth_gate.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:zymmo/screens/auth/login_screen.dart';
import 'package:zymmo/screens/main_app/home_container_screen.dart';
import 'package:zymmo/services/auth_service.dart'; // Importar AuthService

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar o Stream do AuthService para reagir a mudanças no estado de autenticação
    return StreamBuilder<User?>(
      stream: Provider.of<AuthService>(context, listen: false).authStateChanges,
      builder: (context, snapshot) {
        // Usuário está logado
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeContainerScreen(); // Tela principal do app
          }
          // Usuário não está logado
          return const LoginScreen(); // Tela de login
        }

        // Enquanto verifica o estado de autenticação, mostra um loader
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}