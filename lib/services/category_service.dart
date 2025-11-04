                          import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/category.dart';

class CategoryService {
  static const String _categoriesEndpoint = '/api/admin/categories';

  // Récupérer toutes les catégories
  static Future<List<Category>> getAllCategories() async {
    try {
      print('📡 Récupération des catégories...');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}$_categoriesEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📥 Réponse catégories - Status: ${response.statusCode}');
      print('📥 Body catégories: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final List<Category> categories = jsonResponse
            .map((categoryJson) => Category.fromJson(categoryJson))
            .toList();
        
        print('✅ ${categories.length} catégories récupérées avec succès');
        return categories;
      } else {
        throw Exception('Erreur lors de la récupération des catégories: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des catégories: $e');
      rethrow;
    }
  }
}

