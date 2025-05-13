// screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zymmo/services/auth_service.dart';
import 'package:zymmo/routes/app_routes.dart';
import 'package:zymmo/theme/app_theme.dart'; // Para usar as cores do tema

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        await Provider.of<AuthService>(context, listen: false)
            .signInWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        // A navegação é tratada pelo AuthGate
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? "Ocorreu um erro no login.";
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Placeholder para o Logo Zymmo
                SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'Zymmo',
                       style: textTheme.displayMedium?.copyWith(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Bem-vindo de volta!',
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Faça login para continuar.',
                  style: textTheme.bodyLarge?.copyWith(color: AppTheme.neutralDarkColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
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
                        onPressed: _login,
                        child: const Text('ENTRAR'),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Implementar "Esqueceu a senha?"
                  },
                  child: const Text('Esqueceu a senha?'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Não tem uma conta?", style: textTheme.bodyMedium),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.signup);
                      },
                      child: const Text('REGISTRE-SE'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Botões de login social (placeholders)
                // _buildSocialLoginButton(
                //   icon: Icons.g_mobiledata, // Substituir pelo ícone do Google
                //   label: 'Continuar com Google',
                //   onPressed: () { /* TODO: Implementar login com Google */ },
                //   backgroundColor: Colors.redAccent,
                // ),
                // const SizedBox(height: 12),
                // _buildSocialLoginButton(
                //   icon: Icons.facebook,
                //   label: 'Continuar com Facebook',
                //   onPressed: () { /* TODO: Implementar login com Facebook */ },
                //   backgroundColor: Colors.blueAccent,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildSocialLoginButton({
  //   required IconData icon,
  //   required String label,
  //   required VoidCallback onPressed,
  //   required Color backgroundColor,
  // }) {
  //   return ElevatedButton.icon(
  //     icon: Icon(icon, color: Colors.white),
  //     label: Text(label, style: const TextStyle(color: Colors.white)),
  //     onPressed: onPressed,
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: backgroundColor,
  //       minimumSize: const Size(double.infinity, 50),
  //     ),
  //   );
  // }
}