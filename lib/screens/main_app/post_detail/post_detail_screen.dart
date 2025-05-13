// screens/main_app/post_detail/post_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zymmo/models/post_model.dart';
import 'package:zymmo/models/comment_model.dart';
import 'package:zymmo/services/auth_service.dart';
import 'package:zymmo/services/firestore_service.dart';
import 'package:zymmo/widgets/post_card.dart'; // Reutilizar PostCard para exibir o post principal
import 'package:zymmo/widgets/comment_widget.dart'; // Criaremos este widget
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Timestamp

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _commentController = TextEditingController();
  bool _isPostingComment = false;

  Future<void> _addComment(String currentUserId, String currentUserName, String? currentUserAvatarUrl) async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isPostingComment = true);

    final comment = CommentModel(
      id: '', // Será gerado pelo Firestore
      postId: widget.postId,
      autorId: currentUserId,
      autorNome: currentUserName,
      autorAvatarUrl: currentUserAvatarUrl,
      conteudo: _commentController.text.trim(),
      data: Timestamp.now(),
    );

    try {
      await _firestoreService.addComment(comment);
      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar comentário: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isPostingComment = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUserModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: FutureBuilder<PostModel?>(
        future: _firestoreService.getPostById(widget.postId),
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (postSnapshot.hasError || !postSnapshot.hasData || postSnapshot.data == null) {
            return Center(child: Text('Erro ao carregar o post: ${postSnapshot.error}'));
          }

          final post = postSnapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exibir o Post Principal
                      // Poderíamos usar o PostCard aqui, mas ele tem interações de feed.
                      // Vamos criar uma visualização mais simples ou adaptar o PostCard.
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cabeçalho do autor (semelhante ao PostCard)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: post.autorAvatarUrl != null
                                    ? NetworkImage(post.autorAvatarUrl!)
                                    : null,
                                child: post.autorAvatarUrl == null ? const Icon(Icons.person) : null,
                              ),
                              title: Text(post.autorNome, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(_formatTimestamp(post.data), style: Theme.of(context).textTheme.bodySmall),
                            ),
                            if (post.imagemUrl != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(post.imagemUrl!, fit: BoxFit.cover, width: double.infinity,
                                   errorBuilder: (context, error, stackTrace) => Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 50)),
                                    ),
                                  ),
                                ),
                              ),
                            if (post.tipo == PostType.receita && post.nomeReceita != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                child: Text(post.nomeReceita!, style: Theme.of(context).textTheme.headlineSmall),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Text(post.conteudo, style: Theme.of(context).textTheme.bodyLarge),
                            ),
                             // TODO: Exibir ingredientes, modo de preparo se for receita
                            if (post.tipo == PostType.receita) ...[
                              if (post.ingredientes != null && post.ingredientes!.isNotEmpty)
                                _buildSectionTitle('Ingredientes:'),
                              ...post.ingredientes!.map((ing) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                                child: Text('• $ing'),
                              )),
                              const SizedBox(height: 10),
                              // O modo de preparo já está no 'conteudo' para receitas neste modelo.
                              // Se fosse separado:
                              // if (post.modoPreparo != null)
                              //   _buildSectionTitle('Modo de Preparo:'),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                              //   child: Text(post.modoPreparo!),
                              // ),
                            ],
                            const Divider(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text("Comentários", style: Theme.of(context).textTheme.titleMedium),
                            ),
                          ],
                        )
                      ),
                      
                      // Lista de Comentários
                      StreamBuilder<List<CommentModel>>(
                        stream: _firestoreService.getCommentsStream(widget.postId),
                        builder: (context, commentSnapshot) {
                          if (commentSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                          }
                          if (commentSnapshot.hasError) {
                            return Center(child: Text('Erro ao carregar comentários: ${commentSnapshot.error}'));
                          }
                          if (!commentSnapshot.hasData || commentSnapshot.data!.isEmpty) {
                            return const Center(child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('Nenhum comentário ainda. Seja o primeiro!'),
                            ));
                          }
                          final comments = commentSnapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              return CommentWidget(comment: comments[index]);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 70), // Espaço para o campo de comentário fixo
                    ],
                  ),
                ),
              ),
              // Campo para adicionar comentário
              if (currentUser != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Adicionar um comentário...',
                            border: InputBorder.none, // Remover borda padrão do TextField
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) {
                             if (currentUser != null) {
                                _addComment(currentUser.id, currentUser.nome, currentUser.avatarUrl);
                             }
                          },
                          minLines: 1,
                          maxLines: 3,
                        ),
                      ),
                      _isPostingComment
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                            )
                          : IconButton(
                              icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                if (currentUser != null) {
                                   _addComment(currentUser.id, currentUser.nome, currentUser.avatarUrl);
                                }
                              },
                            ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
   Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    // Lógica simples para formatação de data, pode ser melhorada com 'intl' package
    DateTime date = timestamp.toDate();
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return '${diff.inDays}d atrás';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h atrás';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m atrás';
    } else {
      return 'Agora';
    }
  }
}