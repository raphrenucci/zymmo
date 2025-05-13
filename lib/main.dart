import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:zymmo/firebase_options.dart'; // Importe suas opções do Firebase
import 'package:zymmo/services/auth_service.dart';
import 'package:zymmo/theme/app_theme.dart';
import 'package:zymmo/routes/app_routes.dart';
import 'package:zymmo/screens/auth_gate.dart';

// Para inicializar o Firebase, você precisa gerar o arquivo firebase_options.dart
// usando o FlutterFire CLI: `flutterfire configure`

void main() async {
  // Garante que os bindings do Flutter sejam inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase
  // Este é um passo crucial. Certifique-se de ter configurado o Firebase
  // para seu projeto e que o arquivo 'firebase_options.dart' existe e está correto.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // ignore: avoid_print
    print('Erro ao inicializar o Firebase: $e');
    // Considere mostrar uma mensagem de erro para o usuário ou tentar novamente.
  }


  runApp(const ZymmoApp());
}

class ZymmoApp extends StatelessWidget {
  const ZymmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider é usado para prover os serviços e view models para a árvore de widgets
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider para o serviço de autenticação
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        // Adicione outros providers globais aqui conforme necessário
        // Ex: Provider para o FirestoreService se ele precisar notificar listeners
        // Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: MaterialApp(
        title: 'Zymmo',
        theme: AppTheme.lightTheme, // Define o tema customizado do aplicativo
        // darkTheme: AppTheme.darkTheme, // Você pode definir um tema escuro também
        // themeMode: ThemeMode.system, // Ou deixar o sistema decidir
        debugShowCheckedModeBanner: false, // Remove o banner de debug
        initialRoute: AppRoutes.authGate, // Rota inicial que verifica o estado de autenticação
        onGenerateRoute: AppRoutes.generateRoute, // Função para gerar as rotas nomeadas
        home: const AuthGate(), // Como fallback, mas onGenerateRoute deve cobrir authGate
      ),
    );
  }
}
