// screens/main_app/recipe_search/recipe_search_screen.dart
import 'package:flutter/material.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = []; // Mock de resultados
  bool _isLoading = false;

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    // Simular busca com delay
    Future.delayed(const Duration(milliseconds: 500), () {
      // Mock: aqui você chamaria seu algoritmo de busca
      // Por enquanto, apenas adicionamos o query como resultado se não for vazio
      setState(() {
        _searchResults = ["Receita com $query 1", "Receita com $query 2", "Dica sobre $query"];
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por ingredientes, nome da receita...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              onChanged: _performSearch,
            ),
          ),
          // TODO: Adicionar filtros (tags, tempo de preparo, etc.)
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
            const Expanded(child: Center(child: Text('Nenhum resultado encontrado.')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults[index]),
                    leading: const Icon(Icons.restaurant_menu), // Ícone de exemplo
                    onTap: () {
                      // Navegar para detalhes da receita/dica
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}