// models/post_model.dart
// import 'package:cloud_firestore/cloud_firestore.dart'; // Já importado acima, mas bom para clareza

enum PostType { receita, dica, artigo }

String postTypeToString(PostType type) {
  return type.toString().split('.').last;
}

PostType postTypeFromString(String typeString) {
  try {
    return PostType.values.firstWhere((e) => postTypeToString(e) == typeString);
  } catch (e) {
    return PostType.artigo; // Default ou tratar erro
  }
}

class PostModel {
  final String id; // ID do post (gerado automaticamente)
  final String autorId;
  final String autorNome; // Para exibir rapidamente sem buscar o user
  final String? autorAvatarUrl; // Para exibir rapidamente
  final PostType tipo;
  final String conteudo; // Para dicas e artigos. Para receitas, pode ser uma descrição.
  final String? imagemUrl;
  final List<String> curtidas; // Lista de UIDs de quem curtiu
  // comentarios serão uma subcoleção ou uma coleção separada referenciada
  final Timestamp data;

  // Campos específicos para Receita (podem ser nulos se não for receita)
  final String? nomeReceita;
  final List<String>? ingredientes; // Lista de strings simples por enquanto
  final String? modoPreparo;
  final String? tempoPreparo; // Ex: "30 min"
  final List<String>? tags;

  PostModel({
    required this.id,
    required this.autorId,
    required this.autorNome,
    this.autorAvatarUrl,
    required this.tipo,
    required this.conteudo,
    this.imagemUrl,
    List<String>? curtidas,
    required this.data,
    this.nomeReceita,
    this.ingredientes,
    this.modoPreparo,
    this.tempoPreparo,
    this.tags,
  }) : curtidas = curtidas ?? [];

  Map<String, dynamic> toMap() {
    return {
      'autor_id': autorId,
      'autor_nome': autorNome,
      'autor_avatar_url': autorAvatarUrl,
      'tipo': postTypeToString(tipo),
      'conteudo': conteudo,
      'imagem_url': imagemUrl,
      'curtidas': curtidas,
      'data': data,
      // Campos de receita
      'nome_receita': nomeReceita,
      'ingredientes': ingredientes,
      'modo_preparo': modoPreparo,
      'tempo_preparo': tempoPreparo,
      'tags': tags,
    };
  }

  factory PostModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PostModel(
      id: doc.id,
      autorId: data['autor_id'] ?? '',
      autorNome: data['autor_nome'] ?? 'Usuário Zymmo',
      autorAvatarUrl: data['autor_avatar_url'],
      tipo: postTypeFromString(data['tipo'] ?? 'artigo'),
      conteudo: data['conteudo'] ?? '',
      imagemUrl: data['imagem_url'],
      curtidas: List<String>.from(data['curtidas'] ?? []),
      data: data['data'] ?? Timestamp.now(),
      // Campos de receita
      nomeReceita: data['nome_receita'],
      ingredientes: List<String>.from(data['ingredientes'] ?? []),
      modoPreparo: data['modo_preparo'],
      tempoPreparo: data['tempo_preparo'],
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}