// screens/main_app/favorites/favorites_screen.dart
import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mockup: Lista de receitas favoritas (hardcoded por enquanto)
    final List<Map<String, String>> favoriteRecipes = [
      {"name": "Bolo de Cenoura com Cobertura", "author": "Ana Maria", "image": "assets/images/placeholder_recipe1.png"},
      {"name": "Lasanha à Bolonhesa Clássica", "author": "Chef Zymmo", "image": "assets/images/placeholder_recipe2.png"},
      {"name": "Smoothie Verde Detox", "author": "NutriBem", "image": "assets/images/placeholder_recipe3.png"},
    ];

    return Scaffold(
      body: favoriteRecipes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Você ainda não tem receitas favoritas.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore o feed e adicione as que mais gostar!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    // leading: recipe["image"] != null && File(recipe["image"]!).existsSync()
                    //     ? ClipRRect(
                    //         borderRadius: BorderRadius.circular(8.0),
                    //         child: Image.asset(
                    //           recipe["image"]!,
                    //           width: 70,
                    //           height: 70,
                    //           fit: BoxFit.cover,
                    //           errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 70),
                    //         ),
                    //       )
                    //     : const Icon(Icons.restaurant_menu, size: 40, color: AppTheme.primaryColor),
                    leading: const Icon(Icons.restaurant_menu, size: 40, color: AppTheme.primaryColor), // Placeholder
                    title: Text(recipe["name"]!, style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text("Por: ${recipe["author"]!}", style: Theme.of(context).textTheme.bodySmall),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        // TODO: Implementar remoção dos favoritos
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${recipe["name"]} removido dos favoritos (mock).")),
                        );
                      },
                    ),
                    onTap: () {
                      // TODO: Navegar para a tela de detalhes da receita
                    },
                  ),
                );
              },
            ),
    );
  }
}