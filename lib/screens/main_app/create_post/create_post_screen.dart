// screens/main_app/create_post/create_post_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zymmo/models/post_model.dart';
import 'package:zymmo/services/auth_service.dart';
import 'package:zymmo/services/firestore_service.dart';
import 'package:zymmo/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para Timestamp
import 'package:firebase_storage/firebase_storage.dart'; // Para Storage
import 'package:uuid/uuid.dart'; // Para gerar IDs únicos para imagens

class CreatePostScreen extends StatefulWidget {
  final String? initialPostType; // Para pré-selecionar o tipo de post

  const CreatePostScreen({super.key, this.initialPostType});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _recipeNameController = TextEditingController();
  final _ingredientsController = TextEditingController(); // Para lista simples
  final _preparationController = TextEditingController();
  final _prepTimeController = TextEditingController();

  PostType _selectedPostType = PostType.artigo;
  File? _selectedImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();


  @override
  void initState() {
    super.initState();
    if (widget.initialPostType != null) {
      try {
        _selectedPostType = postTypeFromString(widget.initialPostType!);
      } catch (_) {
        _selectedPostType = PostType.artigo;
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 70, maxWidth: 1024);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao selecionar imagem: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao selecionar imagem: $e")),
      );
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeria'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Câmera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _uploadImage(File imageFile, String userId) async {
    try {
      String fileName = 'posts/${userId}_${_uuid.v4()}.jpg';
      Reference storageRef = _storage.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao fazer upload da imagem: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao fazer upload da imagem: $e")),
      );
      return null;
    }
  }


  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUserModel;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Você precisa estar logado para postar.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _uploadImage(_selectedImage!, currentUser.id);
      if (imageUrl == null && _selectedImage != null) { // Erro no upload
         setState(() => _isLoading = false);
         return; // Mensagem de erro já foi mostrada
      }
    }

    try {
      PostModel newPost = PostModel(
        id: '', // Será gerado pelo FirestoreService
        autorId: currentUser.id,
        autorNome: currentUser.nome,
        autorAvatarUrl: currentUser.avatarUrl,
        tipo: _selectedPostType,
        conteudo: _selectedPostType == PostType.receita ? _preparationController.text : _contentController.text,
        imagemUrl: imageUrl,
        data: Timestamp.now(),
        // Campos específicos de receita
        nomeReceita: _selectedPostType == PostType.receita ? _recipeNameController.text : null,
        ingredientes: _selectedPostType == PostType.receita
            ? _ingredientsController.text.split('\n').where((s) => s.trim().isNotEmpty).toList()
            : null,
        modoPreparo: _selectedPostType == PostType.receita ? _preparationController.text : null,
        tempoPreparo: _selectedPostType == PostType.receita ? _prepTimeController.text : null,
        tags: [], // TODO: Adicionar campo para tags
      );

      await _firestoreService.createPost(newPost);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post criado com sucesso!")),
      );
      if (mounted) Navigator.of(context).pop();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao criar post: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Novo Post'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(
              onPressed: _submitPost,
              child: Text(
                'POSTAR',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Seletor de Tipo de Post
              SegmentedButton<PostType>(
                segments: const <ButtonSegment<PostType>>[
                  ButtonSegment<PostType>(value: PostType.receita, label: Text('Receita'), icon: Icon(Icons.receipt_long)),
                  ButtonSegment<PostType>(value: PostType.dica, label: Text('Dica'), icon: Icon(Icons.lightbulb_outline)),
                  ButtonSegment<PostType>(value: PostType.artigo, label: Text('Artigo'), icon: Icon(Icons.article_outlined)),
                ],
                selected: {_selectedPostType},
                onSelectionChanged: (Set<PostType> newSelection) {
                  setState(() {
                    _selectedPostType = newSelection.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedForegroundColor: Colors.white,
                  selectedBackgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.neutralLightColor.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 20),

              // Campos Comuns
              if (_selectedImage == null)
                OutlinedButton.icon(
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text('Adicionar Imagem'),
                  onPressed: () => _showImageSourceActionSheet(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                )
              else
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      icon: const CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                      onPressed: () => setState(() => _selectedImage = null),
                    ),
                  ],
                ),
              const SizedBox(height: 16),

              // Campos específicos por tipo
              if (_selectedPostType == PostType.receita) ...[
                TextFormField(
                  controller: _recipeNameController,
                  decoration: const InputDecoration(labelText: 'Nome da Receita*'),
                  validator: (value) => (value == null || value.isEmpty) && _selectedPostType == PostType.receita
                      ? 'Nome da receita é obrigatório.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(
                    labelText: 'Ingredientes*',
                    hintText: 'Um ingrediente por linha (ex: 2 ovos)',
                  ),
                  maxLines: 5,
                  validator: (value) => (value == null || value.isEmpty) && _selectedPostType == PostType.receita
                      ? 'Ingredientes são obrigatórios.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _preparationController, // Usado para modo de preparo na receita
                  decoration: const InputDecoration(labelText: 'Modo de Preparo*'),
                  maxLines: 8,
                   validator: (value) => (value == null || value.isEmpty) && _selectedPostType == PostType.receita
                      ? 'Modo de preparo é obrigatório.'
                      : null,
                ),
                const SizedBox(height: 16),
                 TextFormField(
                  controller: _prepTimeController,
                  decoration: const InputDecoration(labelText: 'Tempo de Preparo', hintText: 'Ex: 30 min, 1 hora'),
                ),
              ] else ...[ // Dica ou Artigo
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: _selectedPostType == PostType.dica ? 'Sua Dica Culinária*' : 'Conteúdo do Artigo*',
                    hintText: _selectedPostType == PostType.dica
                        ? 'Compartilhe uma dica rápida (até 250 caracteres recomendado)'
                        : 'Escreva seu artigo aqui...',
                  ),
                  maxLines: _selectedPostType == PostType.dica ? 3 : 10,
                  maxLength: _selectedPostType == PostType.dica ? 250 : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _selectedPostType == PostType.dica
                          ? 'A dica não pode estar vazia.'
                          : 'O conteúdo do artigo não pode estar vazio.';
                    }
                    return null;
                  },
                ),
              ],
              // TODO: Adicionar campo para Tags
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}