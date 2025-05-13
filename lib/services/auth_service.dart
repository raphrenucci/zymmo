// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zymmo/models/user_model.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUserModel;
  User? get currentUser => _auth.currentUser;
  UserModel? get currentUserModel => _currentUserModel;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _currentUserModel = null;
    } else {
      // Buscar dados do usuário no Firestore
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          _currentUserModel = UserModel.fromFirestore(userDoc);
        } else {
          // Usuário autenticado mas sem registro no Firestore (pode acontecer em migrações ou erros)
          // Poderia criar um registro básico aqui ou tratar de outra forma.
          _currentUserModel = UserModel(id: firebaseUser.uid, nome: firebaseUser.displayName ?? "Usuário", email: firebaseUser.email ?? "");
        }
      } catch (e) {
        // ignore: avoid_print
        print("Erro ao buscar dados do usuário no Firestore: $e");
        _currentUserModel = null; // Ou tratar o erro de forma mais robusta
      }
    }
    notifyListeners();
  }


  // Login com Email e Senha
  Future<UserCredential?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Atualizar _currentUserModel após login bem-sucedido
      await _onAuthStateChanged(userCredential.user);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print("Erro no login: ${e.message}");
      // Lançar a exceção para ser tratada na UI
      throw e;
    }
  }

  // Cadastro com Email e Senha
  Future<UserCredential?> signUpWithEmailPassword(String email, String password, String nome) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Criar documento do usuário no Firestore
        _currentUserModel = UserModel(
          id: firebaseUser.uid,
          nome: nome,
          email: email,
          // Outros campos podem ser inicializados aqui ou em um processo de onboarding
        );
        await _firestore.collection('users').doc(firebaseUser.uid).set(_currentUserModel!.toMap());
      }
      // Atualizar _currentUserModel após cadastro bem-sucedido
      await _onAuthStateChanged(firebaseUser);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print("Erro no cadastro: ${e.message}");
      throw e; // Lançar a exceção para ser tratada na UI
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // _onAuthStateChanged será chamado automaticamente
    } catch (e) {
      // ignore: avoid_print
      print("Erro no logout: $e");
      // Tratar erro, se necessário
    }
  }

  // TODO: Implementar Login com Google
  Future<UserCredential?> signInWithGoogle() async {
    // Implementação do login com Google (requer firebase_auth e google_sign_in)
    // Lembre-se de configurar as credenciais no Firebase Console e no projeto
    return null;
  }

  // TODO: Implementar Login com Facebook
  Future<UserCredential?> signInWithFacebook() async {
    // Implementação do login com Facebook (requer flutter_facebook_auth)
    return null;
  }

  // TODO: Implementar Login com Apple
  Future<UserCredential?> signInWithApple() async {
    // Implementação do login com Apple (requer sign_in_with_apple)
    return null;
  }
}