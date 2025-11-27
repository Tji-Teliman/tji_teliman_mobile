import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/mission.dart';
import '../models/mission_detail_response.dart';
import 'token_service.dart';

class MissionService {
  static const String _allMissionsEndpoint = '/api/missions/en-attente';
  static const String _createMissionEndpoint = '/api/missions/creer';

  // Récupérer toutes les missions en attente
  static Future<List<Mission>> getAllMissions() async {
    try {
      print('📡 Récupération de toutes les missions...');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}$_allMissionsEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📥 Réponse missions - Status: ${response.statusCode}');
      print('📥 Body missions: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        final List<Mission> missions = jsonResponse.map((missionJson) => Mission.fromJson(missionJson)).toList();
        
        print('✅ ${missions.length} missions récupérées avec succès');
        return missions;
      } else {
        throw Exception('Erreur lors de la récupération des missions: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des missions: $e');
      rethrow;
    }
  }

  // Récupérer les missions urgentes (statut URGENT)
  static Future<List<Mission>> getUrgentMissions() async {
    final allMissions = await getAllMissions();
    return allMissions.where((mission) => mission.statut.toUpperCase() == 'URGENT').toList();
  }

  // Récupérer les missions par catégorie
  static Future<List<Mission>> getMissionsByCategory(String category) async {
    final allMissions = await getAllMissions();
    return allMissions.where((mission) => mission.categorieNom.toLowerCase().contains(category.toLowerCase())).toList();
  }

  // Récupérer une mission par son ID
  static Future<MissionDetailResponse> getMissionById(int missionId) async {
    try {
      print('📡 Récupération de la mission ID: $missionId...');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/missions/$missionId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📥 Réponse mission - Status: ${response.statusCode}');
      print('📥 Body mission: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final missionDetailResponse = MissionDetailResponse.fromJson(jsonResponse);
        
        print('✅ Mission récupérée avec succès');
        return missionDetailResponse;
      } else {
        throw Exception('Erreur lors de la récupération de la mission: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération de la mission: $e');
      rethrow;
    }
  }

  // Supprimer une mission
  // Annuler une mission (PUT)
  static Future<bool> cancelMission(int missionId) async {
    try {
      final token = await TokenService.getToken();
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/missions/$missionId/annuler'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      
      print('🚫 Annulation mission $missionId');
      print('📥 Status: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Erreur annulation mission: $e');
      rethrow;
    }
  }

  // Supprimer une mission (DELETE) - Gardé pour compatibilité si besoin
  static Future<bool> deleteMission(int missionId) async {
    try {
      final token = await TokenService.getToken();
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/missions/$missionId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  // Créer une mission (recruteur)
  static Future<MissionDetailResponse> createMission(Map<String, dynamic> payload) async {
    try {
      print('📡 Publication de la mission...');
      print('📤 Payload: $payload');

      final token = await TokenService.getToken();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$_createMissionEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      );

      print('📥 Réponse création - Status: ${response.statusCode}');
      print('📥 Body création: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return MissionDetailResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Erreur lors de la création: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur publication mission: $e');
      rethrow;
    }
  }
}