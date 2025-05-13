// widgets/comment_widget.dart
import 'package:flutter/material.dart';
import 'package:zymmo/models/comment_model.dart';
// import 'package:zymmo/theme/app_theme.dart'; // Se precisar de cores específicas
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Timestamp

class CommentWidget extends StatelessWidget {
  final CommentModel comment;

  const CommentWidget({super.key, required this.comment});

  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    } else {
      return 'Agora';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: comment.autorAvatarUrl != null
                ? NetworkImage(comment.autorAvatarUrl!)
                : null,
            child: comment.autorAvatarUrl == null ? const Icon(Icons.person, size: 18) : null,
            backgroundColor: Colors.grey[200],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: textTheme.bodyMedium, // Estilo padrão
                    children: [
                      TextSpan(
                        text: '${comment.autorNome} ',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      TextSpan(
                        text: comment.conteudo,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(comment.data),
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
