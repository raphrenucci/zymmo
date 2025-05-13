// screens/main_app/feed/feed_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zymmo/models/post_model.dart';
import 'package:zymmo/services/auth_service.dart';
import 'package:zymmo/services/firestore_service.dart';
import 'package:zymmo/widgets/post_card.dart'; // Criaremos este widget
import 'package:zymmo/routes/app_routes.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService(); // Idealmente injetado via Provider
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser;

    return Scaffold(
      body: StreamBuilder<List<PostModel>>(
        stream: firestoreService.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // ignore: avoid_print
            print("Erro no feed: ${snapshot.error}");
            return Center(child: Text('Erro ao carregar o feed: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum post encontrado. Seja o primeiro a postar!'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                post: post,
                currentUserId: currentUser?.uid,
                onLikeToggle: () async {
                  if (currentUser != null) {
                    bool isCurrentlyLiked = post.curtidas.contains(currentUser.uid);
                    await firestoreService.toggleLikePost(post.id, currentUser.uid, isCurrentlyLiked);
                  }
                },
                onCommentTap: () {
                  Navigator.pushNamed(context, AppRoutes.postDetail, arguments: post.id);
                },
                onShareTap: () {
                  // Implementar compartilhamento
                },
                 onProfileTap: (userId) {
                  Navigator.pushNamed(context, AppRoutes.profile, arguments: userId);
                }
              );
            },
          );
        },
      ),
    );
  }
}