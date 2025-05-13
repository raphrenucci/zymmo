// screens/main_app/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zymmo/services/auth_service.dart';
import 'package:zymmo/models/user_model.dart';
import 'package:zymmo/theme/app_theme.dart'; // Para usar cores do tema
import 'package:zymmo/routes/app_routes.dart'; // Para navegação

class ProfileScreen extends StatelessWidget {
  final String? userId; // Para visualizar perfil de outros usuários

  const ProfileScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final bool isCurrentUserProfile = userId == null || userId == authService.currentUser?.uid;
    final UserModel? userToDisplay = isCurrentUserProfile ? authService.currentUserModel : null; // TODO: Fetch other user's profile

    if (userToDisplay == null && isCurrentUserProfile) {
      // Se for o perfil do usuário logado e os dados não carregaram ainda
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (userToDisplay == null && !isCurrentUserProfile) {
      // TODO: Implementar busca do perfil de outro usuário
      return Scaffold(
        appBar: AppBar(title: const Text("Perfil")),
        body: const Center(child: Text("Carregando perfil...")),
      );
    }


    // Mock data para estatísticas, substituir por dados reais
    const int postCount = 16;
    const int followersCount = 150;
    const int followingCount = 75;

    return Scaffold(
      // AppBar é gerenciado pelo HomeContainerScreen, a menos que seja um perfil de outro usuário
      // appBar: isCurrentUserProfile ? null : AppBar(title: Text(userToDisplay?.nome ?? "Perfil")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Cabeçalho do Perfil
            Container(
              padding: const EdgeInsets.all(20.0),
              color: AppTheme.primaryColor.withOpacity(0.1), // Um fundo suave
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: userToDisplay?.avatarUrl != null
                            ? NetworkImage(userToDisplay!.avatarUrl!)
                            : null, // Usar AssetImage para placeholder
                        child: userToDisplay?.avatarUrl == null
                            ? const Icon(Icons.person, size: 50, color: AppTheme.primaryColor)
                            : null,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              userToDisplay?.nome ?? 'Nome do Usuário',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (userToDisplay?.email != null)
                              Text(
                                userToDisplay!.email, // Ou @username se tiver
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.neutralDarkColor),
                              ),
                            if (isCurrentUserProfile)
                              TextButton(
                                onPressed: () {
                                  // TODO: Navegar para tela de Editar Perfil
                                },
                                child: const Text('Editar Perfil'),
                              ),
                          ],
                        ),
                      ),
                      if (isCurrentUserProfile)
                        IconButton(
                          icon: const Icon(Icons.logout, color: AppTheme.secondaryColor),
                          onPressed: () async {
                            await authService.signOut();
                            // AuthGate cuidará da navegação
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (userToDisplay?.bio != null && userToDisplay!.bio!.isNotEmpty)
                    Text(
                      userToDisplay.bio!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 20),
                  // Estatísticas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildStatColumn('Postagens', userToDisplay?.posts.length ?? postCount, context),
                      _buildStatColumn('Seguidores', userToDisplay?.seguidores.length ?? followersCount, context),
                      _buildStatColumn('Seguindo', userToDisplay?.seguindo.length ?? followingCount, context),
                    ],
                  ),
                ],
              ),
            ),
            
            // Abas (Conteúdo, Visto Recente - Mock)
            DefaultTabController(
              length: 2, // Número de abas
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const TabBar(
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: AppTheme.neutralDarkColor,
                    indicatorColor: AppTheme.primaryColor,
                    tabs: [
                      Tab(text: 'MINHAS POSTAGENS'),
                      Tab(text: 'HISTÓRICO'), // Ou "Salvos", "Atividade"
                    ],
                  ),
                  SizedBox(
                    // Altura da TabBarView - ajuste conforme necessário
                    // Idealmente, seria dinâmico ou usaria NestedScrollView
                    height: MediaQuery.of(context).size.height * 0.5, // Exemplo de altura
                    child: TabBarView(
                      children: [
                        // Conteúdo da Aba "Minhas Postagens"
                        _buildUserPostsGrid(context, userToDisplay?.id ?? ''), // TODO: Passar posts do usuário
                        // Conteúdo da Aba "Histórico"
                        const Center(child: Text('Histórico de atividades ou posts vistos recentemente (mock).')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int count, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildUserPostsGrid(BuildContext context, String userId) {
    // TODO: Implementar a busca e exibição dos posts do usuário (userId)
    // Por enquanto, um placeholder
    final List<String> mockUserPostsImages = [ // Simula URLs de imagens ou assets
      // "assets/images/user_post1.png",
      // "assets/images/user_post2.png",
      // "assets/images/user_post3.png",
      // "assets/images/user_post4.png",
    ];

    if (mockUserPostsImages.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("Nenhuma postagem ainda.", style: TextStyle(fontSize: 16, color: Colors.grey)),
      ));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 colunas de posts
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: mockUserPostsImages.length,
      itemBuilder: (context, index) {
        // return Image.asset(mockUserPostsImages[index], fit: BoxFit.cover);
        return Container(
          color: Colors.grey[300],
          child: Center(child: Text("Post ${index+1}")), // Placeholder
        );
      },
      // shrinkWrap: true, // Use com cautela dentro de SingleChildScrollView
      // physics: const NeverScrollableScrollPhysics(), // Se dentro de SingleChildScrollView
    );
  }
}