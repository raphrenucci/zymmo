// services/firestore_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart'; // Já importado
// import 'package:zymmo/models/post_model.dart'; // Já importado
// import 'package:zymmo/models/comment_model.dart'; // Já importado
// import 'package:uuid/uuid.dart'; // Para gerar IDs únicos

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final Uuid _uuid = const Uuid(); // Descomente se for gerar IDs no cliente

  // --- Posts ---
  // Criar um novo post
  Future<void> createPost(PostModel post) async {
    try {
      // Se o ID do post não for gerado pelo Firestore automaticamente (como doc().id),
      // você pode gerar um ID no cliente:
      // final postId = post.id.isEmpty ? _uuid.v4() : post.id;
      // final postWithId = PostModel(id: postId, ... (copiar outros campos de post));
      // await _firestore.collection('posts').doc(postId).set(postWithId.toMap());

      // Se o ID é gerado pelo Firestore:
      DocumentReference postRef = _firestore.collection('posts').doc();
      await postRef.set(post.copyWith(id: postRef.id).toMap()); // Salva o post com seu próprio ID

      // Atualizar a lista de posts do usuário (opcional, pode ser feito por trigger no backend)
      // await _firestore.collection('users').doc(post.autorId).update({
      //   'posts': FieldValue.arrayUnion([postRef.id])
      // });

    } catch (e) {
      // ignore: avoid_print
      print("Erro ao criar post: $e");
      rethrow;
    }
  }

  // Buscar todos os posts para o feed (com paginação no futuro)
  Stream<List<PostModel>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('data', descending: true) // Ordena pelos mais recentes
        // .limit(20) // Adicionar limite para paginação
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    });
  }

    // Buscar um post específico
  Future<PostModel?> getPostById(String postId) async {
    try {
      final doc = await _firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        return PostModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao buscar post por ID: $e");
      return null;
    }
  }


  // Curtir/Descurtir um post
  Future<void> toggleLikePost(String postId, String userId, bool isLiked) async {
    try {
      DocumentReference postRef = _firestore.collection('posts').doc(postId);
      if (isLiked) { // Se já está curtido, remover o like (descurtir)
        await postRef.update({
          'curtidas': FieldValue.arrayRemove([userId])
        });
      } else { // Se não está curtido, adicionar o like
        await postRef.update({
          'curtidas': FieldValue.arrayUnion([userId])
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao curtir/descurtir post: $e");
      rethrow;
    }
  }

  // --- Comentários (como coleção separada) ---
  // Adicionar um comentário a um post
  Future<void> addComment(CommentModel comment) async {
    try {
      DocumentReference commentRef = _firestore.collection('comentarios').doc();
      await commentRef.set(comment.copyWith(id: commentRef.id).toMap());

      // Opcional: Incrementar contador de comentários no post (ou usar subcoleção)
      // await _firestore.collection('posts').doc(comment.postId).update({
      //   'numero_comentarios': FieldValue.increment(1)
      // });
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao adicionar comentário: $e");
      rethrow;
    }
  }

  // Buscar comentários de um post
  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return _firestore
        .collection('comentarios')
        .where('post_id', isEqualTo: postId)
        .orderBy('data', descending: false) // Comentários mais antigos primeiro ou true para mais novos
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CommentModel.fromFirestore(doc)).toList();
    });
  }

  // --- Usuários ---
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao buscar perfil do usuário: $e");
      return null;
    }
  }


  // --- Receitas (coleção 'receitas') ---
  Future<void> createRecipe(RecipeModel recipe) async {
    try {
      DocumentReference recipeRef = _firestore.collection('receitas').doc();
      await recipeRef.set(recipe.copyWith(id: recipeRef.id).toMap());
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao criar receita: $e");
      rethrow;
    }
  }

  Stream<List<RecipeModel>> getRecipesStream() {
    return _firestore
        .collection('receitas')
        .orderBy('data_criacao', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => RecipeModel.fromFirestore(doc)).toList();
    });
  }

  // TODO: Implementar métodos para:
  // - Salvar receita em favoritos (coleção 'favoritos' ou campo no usuário)
  // - Criar/Gerenciar lista de compras (coleção 'listas_compras')
  // - Seguir/Deixar de seguir usuários (atualizar campos 'seguidores'/'seguindo' nos documentos dos usuários)
  // - Buscar receitas por ingredientes (requer lógica mais complexa, talvez busca textual ou array-contains-any)
}

// Extensões para facilitar a cópia de modelos com novos valores
extension PostModelCopy on PostModel {
  PostModel copyWith({
    String? id,
    String? autorId,
    String? autorNome,
    String? autorAvatarUrl,
    PostType? tipo,
    String? conteudo,
    String? imagemUrl,
    List<String>? curtidas,
    Timestamp? data,
    String? nomeReceita,
    List<String>? ingredientes,
    String? modoPreparo,
    String? tempoPreparo,
    List<String>? tags,
  }) {
    return PostModel(
      id: id ?? this.id,
      autorId: autorId ?? this.autorId,
      autorNome: autorNome ?? this.autorNome,
      autorAvatarUrl: autorAvatarUrl ?? this.autorAvatarUrl,
      tipo: tipo ?? this.tipo,
      conteudo: conteudo ?? this.conteudo,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      curtidas: curtidas ?? this.curtidas,
      data: data ?? this.data,
      nomeReceita: nomeReceita ?? this.nomeReceita,
      ingredientes: ingredientes ?? this.ingredientes,
      modoPreparo: modoPreparo ?? this.modoPreparo,
      tempoPreparo: tempoPreparo ?? this.tempoPreparo,
      tags: tags ?? this.tags,
    );
  }
}

extension CommentModelCopy on CommentModel {
  CommentModel copyWith({
    String? id,
    String? postId,
    String? autorId,
    String? autorNome,
    String? autorAvatarUrl,
    String? conteudo,
    Timestamp? data,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      autorId: autorId ?? this.autorId,
      autorNome: autorNome ?? this.autorNome,
      autorAvatarUrl: autorAvatarUrl ?? this.autorAvatarUrl,
      conteudo: conteudo ?? this.conteudo,
      data: data ?? this.data,
    );
  }
}

extension RecipeModelCopy on RecipeModel {
  RecipeModel copyWith({
    String? id,
    String? nome,
    List<Map<String, String>>? ingredientes,
    String? modoPreparo,
    String? autorId,
    String? autorNome,
    String? imagemUrl,
    String? tempoPreparo,
    List<String>? tags,
    List<String>? curtidas,
    Timestamp? dataCriacao,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      ingredientes: ingredientes ?? this.ingredientes,
      modoPreparo: modoPreparo ?? this.modoPreparo,
      autorId: autorId ?? this.autorId,
      autorNome: autorNome ?? this.autorNome,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      tempoPreparo: tempoPreparo ?? this.tempoPreparo,
      tags: tags ?? this.tags,
      curtidas: curtidas ?? this.curtidas,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }
}