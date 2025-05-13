// screens/main_app/home_container_screen.dart
import 'package:flutter/material.dart';
import 'package:zymmo/screens/main_app/feed/feed_screen.dart';
import 'package:zymmo/screens/main_app/recipe_search/recipe_search_screen.dart';
import 'package:zymmo/screens/main_app/create_post/create_post_screen.dart';
import 'package:zymmo/screens/main_app/favorites/favorites_screen.dart';
import 'package:zymmo/screens/main_app/profile/profile_screen.dart';
import 'package:zymmo/theme/app_theme.dart'; // Para usar cores do tema

class HomeContainerScreen extends StatefulWidget {
  const HomeContainerScreen({super.key});

  @override
  State<HomeContainerScreen> createState() => _HomeContainerScreenState();
}

class _HomeContainerScreenState extends State<HomeContainerScreen> {
  int _selectedIndex = 0; // Índice da aba selecionada

  // Lista das telas principais que serão exibidas no corpo do Scaffold
  static const List<Widget> _widgetOptions = <Widget>[
    FeedScreen(),
    RecipeSearchScreen(), // Tela de Busca de Receitas
    CreatePostScreen(),   // Tela de Criar Post (será acessada pelo FAB central)
    FavoritesScreen(),
    ProfileScreen(),
  ];

  // Títulos para a AppBar correspondentes a cada aba
  static const List<String> _appBarTitles = <String>[
    'Zymmo Feed',
    'Buscar Receitas',
    'Criar Novo Post', // Título para a tela de criar post, se acessada pela tab
    'Meus Favoritos',
    'Meu Perfil',
  ];

  void _onItemTapped(int index) {
    // O item do meio (índice 2) é o FAB, não uma aba regular
    if (index == 2) {
      // Não muda o índice, o FAB tem sua própria ação
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToCreatePost() {
    // Navegar para a tela de criação de post de forma modal ou como tela cheia
    // Poderia ser Navigator.pushNamed(context, AppRoutes.createPost);
    // Ou, se CreatePostScreen for uma das _widgetOptions, mudar o índice:
    // setState(() { _selectedIndex = 2; });
    // Por enquanto, vamos simular a navegação para a tela de criar post
    // que está na lista _widgetOptions.
    // Idealmente, o FAB abriria uma tela modal ou uma nova rota.
    // Para este exemplo, vamos assumir que o FAB navega para uma tela separada
    // e não apenas muda o índice da BottomNavigationBar.
     Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePostScreen()),
      );
  }


  @override
  Widget build(BuildContext context) {
    // Ajuste para o FAB: se o índice 2 for selecionado (o que não deveria acontecer pela tab),
    // redirecionamos para o feed (índice 0) para evitar um estado inválido,
    // já que o FAB tem sua própria navegação.
    final int effectiveIndex = _selectedIndex == 2 ? 0 : _selectedIndex;


    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[effectiveIndex]),
        // actions: [
        //   if (effectiveIndex == 4) // Ex: Botão de configurações no perfil
        //     IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        // ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(effectiveIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem( // Item placeholder para o FAB
            icon: Icon(Icons.add_circle_outline, color: Colors.transparent), // Ícone transparente
            label: '', // Sem label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: effectiveIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Garante que todos os labels apareçam
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreatePost,
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: AppTheme.textOnSecondary,
        elevation: 2.0,
        shape: const CircleBorder(), // Ou StadiumBorder() se preferir mais alongado
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}