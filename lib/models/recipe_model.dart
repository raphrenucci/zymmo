// models/recipe_model.dart (Estrutura para a coleção 'receitas' principal)
// Esta pode ser similar ao PostModel do tipo receita, mas mais detalhada
// ou pode ser a mesma se PostModel cobrir bem.
// Por simplicidade inicial, um PostModel do tipo 'receita' pode representar uma receita.
// Se precisar de mais campos específicos apenas para a coleção 'receitas', crie um modelo separado.

class RecipeModel {
  final String id;
  final String nome;
  final List<Map<String, String>> ingredientes; // Ex: [{'nome': 'Tomate', 'quantidade': '2 unidades'}]
  final String modoPreparo;
  final String autorId;
  final String autorNome; // Denormalizado
  final String? imagemUrl;
  final String tempoPreparo; // Ex: "30 minutos", "1 hora"
  final List<String> tags;
  final List<String> curtidas; // user_ids
  // Comentários podem ser uma subcoleção ou referenciar a coleção 'comentarios'
  final Timestamp dataCriacao;

  RecipeModel({
    required this.id,
    required this.nome,
    required this.ingredientes,
    required this.modoPreparo,
    required this.autorId,
    required this.autorNome,
    this.imagemUrl,
    required this.tempoPreparo,
    List<String>? tags,
    List<String>? curtidas,
    required this.dataCriacao,
  }) : tags = tags ?? [],
       curtidas = curtidas ?? [];

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'ingredientes': ingredientes,
      'modo_preparo': modoPreparo,
      'autor_id': autorId,
      'autor_nome': autorNome,
      'imagem_url': imagemUrl,
      'tempo_preparo': tempoPreparo,
      'tags': tags,
      'curtidas': curtidas,
      'data_criacao': dataCriacao,
      'tipo': 'receita', // Para diferenciar na coleção 'posts' se for unificado
    };
  }

  factory RecipeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return RecipeModel(
      id: doc.id,
      nome: data['nome'] ?? '',
      ingredientes: List<Map<String, String>>.from(
        (data['ingredientes'] as List<dynamic>? ?? []).map(
          (item) => Map<String, String>.from(item as Map<dynamic, dynamic>),
        ),
      ),
      modoPreparo: data['modo_preparo'] ?? '',
      autorId: data['autor_id'] ?? '',
      autorNome: data['autor_nome'] ?? 'Chef Zymmo',
      imagemUrl: data['imagem_url'],
      tempoPreparo: data['tempo_preparo'] ?? 'N/A',
      tags: List<String>.from(data['tags'] ?? []),
      curtidas: List<String>.from(data['curtidas'] ?? []),
      dataCriacao: data['data_criacao'] ?? Timestamp.now(),
    );
  }
}


// Outros modelos como FavoriteModel, ShoppingListModel podem ser adicionados aqui.
// FavoriteModel: user_id, receita_id, nota_pessoal, data_adicao
// ShoppingListModel: user_id, ingredientes[], resumo_por_loja, export_url
