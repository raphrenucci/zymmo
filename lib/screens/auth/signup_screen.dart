// screens/auth/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zymmo/services/auth_service.dart';
import 'package:zymmo/routes/app_routes.dart';
import 'package:zymmo/theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        await Provider.of<AuthService>(context, listen: false)
            .signUpWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nomeController.text.trim(),
        );
        // A navegação é tratada pelo AuthGate
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? "Ocorreu um erro no cadastro.";
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Conta', style: textTheme.titleLarge?.copyWith(color: AppTheme.primaryColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Junte-se ao Zymmo!',
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Crie sua conta para começar a explorar e compartilhar.',
                  style: textTheme.bodyLarge?.copyWith(color: AppTheme.neutralDarkColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(labelText: 'Nome Completo'),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Por favor, insira um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha.';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                 if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: colorScheme.error, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _signup,
                        child: const Text('REGISTRAR'),
                      ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Já tem uma conta?", style: textTheme.bodyMedium),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Volta para a tela de login
                      },
                      child: const Text('ENTRAR'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}