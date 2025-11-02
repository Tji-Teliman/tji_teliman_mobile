import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/jeune_registration.dart';
import '../models/recruteur_registration.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import 'token_service.dart';

class AuthService {
  static const String _loginEndpoint = '/api/auth/connexion';

  Future<LoginResponse> login(LoginRequest request) async {
    print('🔗 URL de connexion: ${ApiConfig.baseUrl}$_loginEndpoint');
    print('📤 Données envoyées: ${json.encode(request.toJson())}');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$_loginEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    print('📥 Réponse reçue - Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        print('🔍 JSON décodé: $jsonResponse');
        
        final loginResponse = LoginResponse.fromJson(jsonResponse);
        
        // Vérifier si la connexion a réussi
        if (!loginResponse.success) {
          throw Exception(loginResponse.message);
        }
        
        // Sauvegarder le token et les infos utilisateur
        await TokenService.saveToken(
          loginResponse.data.token, 
          loginResponse.data.user.role, 
          loginResponse.data.user.id
        );
        
        // Sauvegarder le nom de l'utilisateur
        final userName = '${loginResponse.data.user.prenom} ${loginResponse.data.user.nom}';
        await TokenService.saveUserName(userName);
        
        print('✅ Token sauvegardé: ${loginResponse.data.token}');
        print('✅ Rôle utilisateur: ${loginResponse.data.user.role}');
        print('✅ Nom utilisateur: $userName');
        print('✅ ID utilisateur: ${loginResponse.data.user.id}');
        
        return loginResponse;
      } catch (e) {
        print('❌ Erreur parsing JSON: $e');
        throw Exception('Erreur lors du traitement de la réponse: $e');
      }
    } else {
      // Essayer d'extraire le message d'erreur du backend
      String errorMessage = 'Échec de la connexion: ${response.statusCode}';
      try {
        if (response.body.isNotEmpty) {
          final errorJson = json.decode(response.body);
          errorMessage = errorJson['message'] ?? errorJson['error'] ?? response.body;
        }
      } catch (e) {
        errorMessage = response.body;
      }
      throw Exception(errorMessage);
    }
  }

  // Méthode d'inscription pour les jeunes
  Future<http.Response> registerJeune(JeuneRegistrationRequest request) async {
    print('🔗 URL inscription jeune: ${ApiConfig.baseUrl}${ApiConfig.registerJeune}');
    print('📤 Données envoyées: ${json.encode(request.toJson())}');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.registerJeune}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    print('📥 Réponse inscription jeune - Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    // Si l'inscription réussit, traiter la réponse pour sauvegarder le token
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final jsonResponse = json.decode(response.body);
        print('🔍 JSON inscription jeune: $jsonResponse');
        
        if (jsonResponse['success'] == true) {
          // Structure de réponse attendue pour l'inscription
          final token = jsonResponse['data']?['token'] ?? jsonResponse['token'];
          final user = jsonResponse['data']?['user'] ?? jsonResponse['user'];
          
          if (token != null) {
            final userId = user?['id'] ?? 0;
            final userRole = user?['role'] ?? 'JEUNE';
            final userName = '${user?['prenom'] ?? ''} ${user?['nom'] ?? ''}'.trim();
            
            await TokenService.saveToken(token, userRole, userId);
            
            if (userName.isNotEmpty) {
              await TokenService.saveUserName(userName);
            }
            
            print('✅ Inscription jeune réussie - Token sauvegardé');
            print('✅ ID: $userId, Rôle: $userRole, Nom: $userName');
          }
        }
      } catch (e) {
        print('❌ Erreur lors du traitement de la réponse d\'inscription jeune: $e');
      }
    }

    return response;
  }

  // Méthode d'inscription pour les recruteurs
  Future<http.Response> registerRecruteur(RecruteurRegistrationRequest request) async {
    print('🔗 URL inscription recruteur: ${ApiConfig.baseUrl}${ApiConfig.registerRecruteur}');
    print('📤 Données envoyées: ${json.encode(request.toJson())}');

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.registerRecruteur}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    print('📥 Réponse inscription recruteur - Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    // Si l'inscription réussit, traiter la réponse pour sauvegarder le token
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        final jsonResponse = json.decode(response.body);
        print('🔍 JSON inscription recruteur: $jsonResponse');
        
        if (jsonResponse['success'] == true) {
          // Structure de réponse attendue pour l'inscription
          final token = jsonResponse['data']?['token'] ?? jsonResponse['token'];
          final user = jsonResponse['data']?['user'] ?? jsonResponse['user'];
          
          if (token != null) {
            final userId = user?['id'] ?? 0;
            final userRole = user?['role'] ?? 'RECRUTEUR';
            final userName = '${user?['prenom'] ?? ''} ${user?['nom'] ?? ''}'.trim();
            
            await TokenService.saveToken(token, userRole, userId);
            
            if (userName.isNotEmpty) {
              await TokenService.saveUserName(userName);
            }
            
            print('✅ Inscription recruteur réussie - Token sauvegardé');
            print('✅ ID: $userId, Rôle: $userRole, Nom: $userName');
          }
        }
      } catch (e) {
        print('❌ Erreur lors du traitement de la réponse d\'inscription recruteur: $e');
      }
    }

    return response;
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    return await TokenService.isLoggedIn();
  }

  // Méthode pour récupérer le token actuel
  Future<String?> getCurrentToken() async {
    return await TokenService.getToken();
  }

  // Méthode pour récupérer les infos de l'utilisateur connecté
  Future<Map<String, dynamic>> getCurrentUserInfo() async {
    final token = await TokenService.getToken();
    final userRole = await TokenService.getUserRole();
    final userId = await TokenService.getUserId();
    final userName = await TokenService.getUserName();

    return {
      'token': token,
      'role': userRole,
      'id': userId,
      'name': userName,
    };
  }

  // Méthode de déconnexion
  Future<void> logout() async {
    print('🔒 Déconnexion de l\'utilisateur');
    await TokenService.logout();
    print('✅ Utilisateur déconnecté');
  }

  // Méthode pour rafraîchir le token (si nécessaire plus tard)
  Future<bool> refreshToken() async {
    // Implémentation pour rafraîchir le token
    // À adapter selon ton API
    try {
      final currentToken = await TokenService.getToken();
      if (currentToken == null) {
        return false;
      }
      
      // Exemple d'appel pour rafraîchir le token
      // final response = await http.post(
      //   Uri.parse('${ApiConfig.baseUrl}/api/auth/refresh'),
      //   headers: {'Authorization': 'Bearer $currentToken'},
      // );
      
      // if (response.statusCode == 200) {
      //   final newToken = json.decode(response.body)['token'];
      //   await TokenService.saveToken(newToken);
      //   return true;
      // }
      
      return false;
    } catch (e) {
      print('❌ Erreur lors du rafraîchissement du token: $e');
      return false;
    }
  }
}