// models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // UID do Firebase Auth
  final String nome;
  final String email;
  final String? avatarUrl;
  final String? plano; // Ex: "gratuito", "premium"
  final String? bio;
  final List<String> seguidores; // Lista de UIDs de quem segue este usuário
  final List<String> seguindo;   // Lista de UIDs de quem este usuário segue
  final List<String> posts;      // Lista de IDs de posts criados por este usuário
  final List<String> favoritos;  // Lista de IDs de receitas favoritas

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    this.avatarUrl,
    this.plano,
    this.bio,
    List<String>? seguidores,
    List<String>? seguindo,
    List<String>? posts,
    List<String>? favoritos,
  }) : seguidores = seguidores ?? [],
       seguindo = seguindo ?? [],
       posts = posts ?? [],
       favoritos = favoritos ?? [];

  // Converte um UserModel para um Map (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'avatar_url': avatarUrl,
      'plano': plano,
      'bio': bio,
      'seguidores': seguidores,
      'seguindo': seguindo,
      'posts': posts,
      'favoritos': favoritos,
      // Adicionar timestamp de criação/atualização se necessário
      'data_criacao': FieldValue.serverTimestamp(),
    };
  }

  // Cria um UserModel a partir de um DocumentSnapshot (do Firestore)
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      id: doc.id, // ou data['id'] se você armazenar o UID explicitamente no documento
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatar_url'],
      plano: data['plano'],
      bio: data['bio'],
      seguidores: List<String>.from(data['seguidores'] ?? []),
      seguindo: List<String>.from(data['seguindo'] ?? []),
      posts: List<String>.from(data['posts'] ?? []),
      favoritos: List<String>.from(data['favoritos'] ?? []),
    );
  }
}