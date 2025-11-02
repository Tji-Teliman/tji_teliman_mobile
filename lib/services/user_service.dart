import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/mission_accomplie_response.dart';
import '../models/mission_recruteur_response.dart';
import '../models/notation_response.dart';
import 'token_service.dart';

class UserService {
  // Endpoints pour les JEUNES
  static const String _mesMissionsAccompliesEndpoint = '/api/missions/mes-missions-accomplies';
  
  // Endpoints pour les RECRUTEURS
  static const String _mesMissionsEndpoint = '/api/missions/mes-missions';
  
  // Endpoint commun pour la notation
  static const String _moyenneNotationEndpoint = '/api/notations/moyenne';

  // =============================================
  // MÉTHODES POUR LES JEUNES
  // =============================================

  // Pour les JEUNES : Récupérer les missions accomplies
  static Future<MissionAccomplieResponse> getMesMissionsAccomplies() async {
    final token = await TokenService.getToken();
    
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$_mesMissionsAccompliesEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('🎯 JEUNE - Récupération missions accomplies');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        final missionResponse = MissionAccomplieResponse.fromJson(jsonResponse);
        
        print('✅ Missions accomplies récupérées: ${missionResponse.data.nombreMissions}');
        return missionResponse;
      } catch (e) {
        print('❌ Erreur parsing missions accomplies: $e');
        throw Exception('Erreur lors du traitement des missions accomplies: $e');
      }
    } else {
      throw Exception('Erreur lors de la récupération des missions accomplies: ${response.statusCode}');
    }
  }

  // =============================================
  // MÉTHODES POUR LES RECRUTEURS
  // =============================================

  // Pour les RECRUTEURS : Récupérer les missions publiées
  static Future<MissionRecruteurResponse> getMesMissions() async {
    final token = await TokenService.getToken();
    
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$_mesMissionsEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('🎯 RECRUTEUR - Récupération missions publiées');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        final missionResponse = MissionRecruteurResponse.fromJson(jsonResponse);
        
        print('✅ Missions publiées récupérées: ${missionResponse.data.length}');
        
        // Debug: Afficher le détail des missions
        for (var mission in missionResponse.data) {
          print('   📋 ${mission.titre} (${mission.statut}) - ${mission.nombreCandidatures} candidatures');
        }
        
        return missionResponse;
      } catch (e) {
        print('❌ Erreur parsing missions publiées: $e');
        throw Exception('Erreur lors du traitement des missions publiées: $e');
      }
    } else {
      throw Exception('Erreur lors de la récupération des missions publiées: ${response.statusCode}');
    }
  }

  // =============================================
  // MÉTHODES COMMUNES
  // =============================================

  // Récupérer la moyenne de notation (commun aux jeunes et recruteurs)
  static Future<NotationResponse> getMoyenneNotation() async {
    final token = await TokenService.getToken();
    
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$_moyenneNotationEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('⭐ Récupération moyenne de notation');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        final notationResponse = NotationResponse.fromJson(jsonResponse);
        
        if (notationResponse.success && notationResponse.data != null) {
          print('✅ Moyenne de notation: ${notationResponse.data!.moyenne}');
        } else {
          print('ℹ️ Aucune notation: ${notationResponse.message}');
        }
        
        return notationResponse;
      } catch (e) {
        print('❌ Erreur parsing notation: $e');
        throw Exception('Erreur lors du traitement de la notation: $e');
      }
    } else {
      throw Exception('Erreur lors de la récupération de la moyenne: ${response.statusCode}');
    }
  }

  // Récupérer les informations de l'utilisateur connecté
  static Future<Map<String, dynamic>> getUserInfo() async {
    final userId = await TokenService.getUserId();
    final userRole = await TokenService.getUserRole();
    final userName = await TokenService.getUserName();
    
    return {
      'id': userId,
      'role': userRole,
      'name': userName,
    };
  }

  // Vérifier le rôle de l'utilisateur
  static Future<bool> isJeune() async {
    final role = await TokenService.getUserRole();
    return role?.toUpperCase().contains('JEUNE') == true;
  }

  static Future<bool> isRecruteur() async {
    final role = await TokenService.getUserRole();
    return role?.toUpperCase().contains('RECRUTEUR') == true;
  }

  // Méthode utilitaire pour obtenir les statistiques selon le rôle
  static Future<Map<String, dynamic>> getStatistiques() async {
    try {
      if (await isJeune()) {
        // Pour les jeunes: missions accomplies
        final missionsResponse = await getMesMissionsAccomplies();
        final notationResponse = await getMoyenneNotation();
        
        return {
          'type': 'jeune',
          'missionsCount': missionsResponse.data.nombreMissions,
          'moyenneNote': notationResponse.data?.moyenne ?? 0.0,
          'success': true,
        };
      } else if (await isRecruteur()) {
        // Pour les recruteurs: missions publiées
        final missionsResponse = await getMesMissions();
        final notationResponse = await getMoyenneNotation();
        
        return {
          'type': 'recruteur',
          'missionsCount': missionsResponse.data.length,
          'moyenneNote': notationResponse.data?.moyenne ?? 0.0,
          'success': true,
        };
      } else {
        return {
          'type': 'inconnu',
          'missionsCount': 0,
          'moyenneNote': 0.0,
          'success': false,
          'message': 'Rôle utilisateur inconnu',
        };
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
      return {
        'type': 'erreur',
        'missionsCount': 0,
        'moyenneNote': 0.0,
        'success': false,
        'message': e.toString(),
      };
    }
  }
}