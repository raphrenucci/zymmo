// models/comment_model.dart
// import 'package:cloud_firestore/cloud_firestore.dart'; // Já importado

class CommentModel {
  final String id; // ID do comentário
  final String postId; // ID do post ao qual o comentário pertence
  final String autorId;
  final String autorNome;
  final String? autorAvatarUrl;
  final String conteudo;
  final Timestamp data;

  CommentModel({
    required this.id,
    required this.postId,
    required this.autorId,
    required this.autorNome,
    this.autorAvatarUrl,
    required this.conteudo,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'post_id': postId,
      'autor_id': autorId,
      'autor_nome': autorNome,
      'autor_avatar_url': autorAvatarUrl,
      'conteudo': conteudo,
      'data': data,
    };
  }

  factory CommentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CommentModel(
      id: doc.id,
      postId: data['post_id'] ?? '',
      autorId: data['autor_id'] ?? '',
      autorNome: data['autor_nome'] ?? 'Usuário Zymmo',
      autorAvatarUrl: data['autor_avatar_url'],
      conteudo: data['conteudo'] ?? '',
      data: data['data'] ?? Timestamp.now(),
    );
  }
}