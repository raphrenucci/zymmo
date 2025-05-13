import 'package:flutter/material.dart';
import 'package:zymmo/screens/auth_gate.dart';
import 'package:zymmo/screens/auth/login_screen.dart';
import 'package:zymmo/screens/auth/signup_screen.dart';
import 'package:zymmo/screens/main_app/home_container_screen.dart'; // Tela que contém o BottomNav
import 'package:zymmo/screens/main_app/feed/feed_screen.dart';
import 'package:zymmo/screens/main_app/recipe_search/recipe_search_screen.dart';
import 'package:zymmo/screens/main_app/create_post/create_post_screen.dart';
import 'package:zymmo/screens/main_app/favorites/favorites_screen.dart';
import 'package:zymmo/screens/main_app/profile/profile_screen.dart';
import 'package:zymmo/screens/main_app/post_detail/post_detail_screen.dart'; // Para ver detalhes e comentários de um post

// Definição dos nomes das rotas para evitar erros de digitação
class AppRoutes {
  static const String authGate = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homeContainer = '/home'; // Tela principal com BottomNav
  static const String feed = '/feed'; // Rota individual se acessada diretamente, mas geralmente é uma aba
  static const String recipeSearch = '/recipe-search'; // Rota para busca de receitas
  static const String createPost = '/create-post';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String postDetail = '/post-detail'; // Rota para detalhes do post

  // Função para gerar as rotas com base no nome
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authGate:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case homeContainer:
        return MaterialPageRoute(builder: (_) => const HomeContainerScreen());
      case feed: // Geralmente parte do HomeContainer, mas pode ser uma rota separada se necessário
        return MaterialPageRoute(builder: (_) => const FeedScreen());
      case recipeSearch:
        return MaterialPageRoute(builder: (_) => const RecipeSearchScreen());
      case createPost:
         // Passando um argumento de exemplo, pode ser o tipo de post
        final String? postType = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => CreatePostScreen(initialPostType: postType));
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case profile:
        // Pode-se passar o ID do usuário se for o perfil de outra pessoa
        final String? userId = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => ProfileScreen(userId: userId));
      case postDetail:
        final String postId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: postId));
      default:
        // Rota para caso uma rota nomeada não seja encontrada
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
