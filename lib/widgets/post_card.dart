// widgets/post_card.dart
import 'package:flutter/material.dart';
import 'package:zymmo/models/post_model.dart';
import 'package:zymmo/theme/app_theme.dart'; // Para cores e fontes
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Timestamp

class PostCard extends StatelessWidget {
  final PostModel post;
  final String? currentUserId; // Para saber se o usuário atual curtiu o post
  final VoidCallback onLikeToggle;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final Function(String userId) onProfileTap; // Para navegar para o perfil do autor

  const PostCard({
    super.key,
    required this.post,
    this.currentUserId,
    required this.onLikeToggle,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onProfileTap,
  });

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

  @override
  Widget build(BuildContext context) {
    final bool isLikedByCurrentUser = currentUserId != null && post.curtidas.contains(currentUserId);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String title = post.conteudo;
    String subtitle = '';

    if (post.tipo == PostType.receita) {
      title = post.nomeReceita ?? 'Receita Sem Nome';
      subtitle = post.conteudo; // Descrição da receita ou modo de preparo resumido
    } else if (post.tipo == PostType.dica) {
      title = 'Dica Culinária';
      subtitle = post.conteudo;
    } else if (post.tipo == PostType.artigo) {
      // Para artigos, o conteúdo pode ser longo. Podemos mostrar um trecho.
      title = post.conteudo.length > 100 ? '${post.conteudo.substring(0, 97)}...' : post.conteudo;
      // Ou ter um campo 'titulo_artigo' no PostModel
    }


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do Post (Autor)
          ListTile(
            leading: GestureDetector(
              onTap: () => onProfileTap(post.autorId),
              child: CircleAvatar(
                backgroundImage: post.autorAvatarUrl != null
                    ? NetworkImage(post.autorAvatarUrl!)
                    : null, // Usar AssetImage para placeholder
                child: post.autorAvatarUrl == null ? const Icon(Icons.person) : null,
                backgroundColor: Colors.grey[200],
              ),
            ),
            title: GestureDetector(
              onTap: () => onProfileTap(post.autorId),
              child: Text(post.autorNome, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            subtitle: Text(_formatTimestamp(post.data), style: textTheme.bodySmall),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                // TODO: Mostrar opções do post (denunciar, editar/excluir se for o autor)
              },
            ),
          ),

          // Conteúdo do Post
          if (post.imagemUrl != null)
            GestureDetector(
              onTap: onCommentTap, // Tocar na imagem também abre detalhes/comentários
              child: AspectRatio(
                aspectRatio: 16 / 9, // Proporção comum para imagens
                child: Image.network(
                  post.imagemUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2,));
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 50)),
                  ),
                ),
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.tipo == PostType.receita && post.nomeReceita != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(post.nomeReceita!, style: textTheme.headlineSmall),
                  ),
                Text(
                  post.tipo == PostType.receita ? post.conteudo : title, // Para receita, 'conteudo' é a descrição
                  style: textTheme.bodyLarge,
                  maxLines: post.tipo == PostType.artigo ? 3 : (post.tipo == PostType.receita ? 4 : 2), // Mais linhas para receita/artigo
                  overflow: TextOverflow.ellipsis,
                ),
                if (post.tipo == PostType.receita && post.tempoPreparo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 16, color: AppTheme.neutralDarkColor),
                        const SizedBox(width: 4),
                        Text(post.tempoPreparo!, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
              ],
            ),
          ),


          // Ações do Post (Curtir, Comentar, Compartilhar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLikedByCurrentUser ? Icons.favorite : Icons.favorite_border,
                        color: isLikedByCurrentUser ? colorScheme.error : AppTheme.neutralDarkColor,
                      ),
                      onPressed: onLikeToggle,
                    ),
                    if (post.curtidas.isNotEmpty) Text(post.curtidas.length.toString(), style: textTheme.bodyMedium),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.neutralDarkColor),
                      onPressed: onCommentTap,
                    ),
                    // TODO: Adicionar contador de comentários se disponível no PostModel
                    // Text("10", style: textTheme.bodyMedium),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: AppTheme.neutralDarkColor),
                  onPressed: onShareTap,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}