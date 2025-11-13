import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/mission_accomplie_response.dart';
import '../models/mission_recruteur_response.dart';
import '../models/notation_response.dart';
import 'token_service.dart';
import 'notification_storage_service.dart';

class UserService {
  // Endpoints pour les JEUNES
  static const String _mesMissionsAccompliesEndpoint = '/api/missions/mes-missions-accomplies';
  
  // Endpoints pour les RECRUTEURS
  static const String _mesMissionsEndpoint = '/api/missions/mes-missions';
  
  // Endpoint commun pour la notation
  static const String _moyenneNotationEndpoint = '/api/notations/moyenne';
  // Endpoint pour les candidatures du jeune
  static const String _mesCandidaturesEndpoint = '/api/candidatures/mes-candidatures';
  // Endpoint pour les notifications
  static const String _mesNotificationsEndpoint = '/api/notifications/mes-notifications';

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

  // Notifications (JEUNES et RECRUTEURS)
  static bool _parseNotificationReadFlag(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value.toString().trim().toLowerCase();
    if (normalized.isEmpty) return false;
    return normalized == 'true' ||
        normalized == '1' ||
        normalized == 'oui' ||
        normalized == 'yes';
  }

  static bool isNotificationRead(Map<String, dynamic> notification) {
    final raw = notification['estLue'] ??
        notification['est_lue'] ??
        notification['lue'] ??
        notification['isRead'] ??
        notification['read'];
    return _parseNotificationReadFlag(raw);
  }

  static Future<int> getUnreadNotificationsCount() async {
    final notifications = await getMesNotifications();
    int unread = 0;
    for (final notif in notifications) {
      final backendRead = isNotificationRead(notif);
      bool seenLocally = false;
      final idAny = notif['id'];
      if (idAny != null) {
        final id = idAny is int ? idAny : int.tryParse(idAny.toString());
        if (id != null) {
          seenLocally = await NotificationStorageService.isNotificationSeenLocally(id);
        }
      }
      final isUnread = !backendRead || !seenLocally;
      if (isUnread) {
        unread++;
      }
    }
    return unread;
  }

  static Future<List<Map<String, dynamic>>> getMesNotifications() async {
    final token = await TokenService.getToken();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$_mesNotificationsEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('🔔 Récupération des notifications');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    try {
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        if (decoded is Map<String, dynamic> && decoded['success'] == true) {
          final data = decoded['data'];
          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          }
          return <Map<String, dynamic>>[];
        }
        String msg = 'Erreur lors de la récupération des notifications';
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] is String) msg = decoded['message'];
          else if (decoded['error'] is String) msg = decoded['error'];
        }
        throw Exception(msg);
      } else {
        String msg = 'Erreur ${response.statusCode}';
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] is String && (decoded['message'] as String).trim().isNotEmpty) {
            msg = decoded['message'];
          } else if (decoded['error'] is String && (decoded['error'] as String).trim().isNotEmpty) {
            msg = decoded['error'];
          }
        }
        throw Exception(msg);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur lors du traitement des notifications: $e');
    }
  }

  // Pour les RECRUTEURS : Récupérer le profil d'une candidature
  static Future<Map<String, dynamic>> getProfilCandidature(int candidatureId) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/api/candidatures/$candidatureId/profil');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('🧾 RECRUTEUR - Profil candidature $candidatureId');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    try {
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        if (decoded is Map<String, dynamic> && decoded['success'] == true) {
          final data = decoded['data'];
          if (data is Map<String, dynamic>) return data;
          return <String, dynamic>{};
        }
        String msg = 'Erreur lors de la récupération du profil';
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] is String) msg = decoded['message'];
          else if (decoded['error'] is String) msg = decoded['error'];
        }
        throw Exception(msg);
      } else {
        String msg = 'Erreur ${response.statusCode}';
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] is String && (decoded['message'] as String).trim().isNotEmpty) {
            msg = decoded['message'];
          } else if (decoded['error'] is String && (decoded['error'] as String).trim().isNotEmpty) {
            msg = decoded['error'];
          }
        }
        throw Exception(msg);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur lors du traitement du profil: $e');
    }
  }

  // Pour les JEUNES : Récupérer les candidatures du jeune connecté
  static Future<List<Map<String, dynamic>>> getMesCandidatures() async {
    final token = await TokenService.getToken();

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$_mesCandidaturesEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('🎯 JEUNE - Récupération de mes candidatures');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    try {
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        if (decoded is Map<String, dynamic> && decoded['success'] == true) {
          final data = decoded['data'];
          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          }
          return <Map<String, dynamic>>[];
        }
        // Si success=false, tenter d'extraire le message
        String msg = 'Erreur lors de la récupération des candidatures';
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] is String) msg = decoded['message'];
          else if (decoded['error'] is String) msg = decoded['error'];
        }
        throw Exception(msg);
      } else {
        String msg = 'Erreur ${response.statusCode}';
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] is String && (decoded['message'] as String).trim().isNotEmpty) {
            msg = decoded['message'];
          } else if (decoded['error'] is String && (decoded['error'] as String).trim().isNotEmpty) {
            msg = decoded['error'];
          }
        }
        throw Exception(msg);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur lors du traitement des candidatures: $e');
    }
  }

  // Pour les RECRUTEURS : Récupérer les candidatures d'une mission donnée
  static Future<List<Map<String, dynamic>>> getCandidaturesParMission(int missionId) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/api/candidatures/mission/$missionId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('🎯 RECRUTEUR - Candidatures pour mission $missionId');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    try {
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          return (decoded['data'] as List).cast<Map<String, dynamic>>();
        }
        return <Map<String, dynamic>>[];
      } else {
        String msg = 'Erreur ${response.statusCode}';
        if (decoded is Map<String, dynamic>) {
          if (decoded['message'] is String && (decoded['message'] as String).trim().isNotEmpty) {
            msg = decoded['message'];
          } else if (decoded['error'] is String && (decoded['error'] as String).trim().isNotEmpty) {
            msg = decoded['error'];
          }
        }
        throw Exception(msg);
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Erreur lors du traitement des candidatures: $e');
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

  // Candidature à une mission (JEUNE)
  static Future<bool> postulerMission({required int missionId, String? motivation}) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/api/candidatures/mission/$missionId');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final Map<String, dynamic> payload = {};
    if (motivation != null && motivation.trim().isNotEmpty) {
      payload['motivationContenu'] = motivation.trim();
    }

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(payload),
    );

    print('📨 Candidature mission $missionId envoyée');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      return true;
    }
    // Tenter d'extraire un message d'erreur pertinent depuis le backend
    String errorMessage = 'Erreur lors de la candidature: ${response.statusCode}';
    try {
      final decoded = json.decode(response.body);
      // Cas communs: { message: "..." } ou { error: "..." } ou { errors: [...] / {field: [msg]} }
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] is String && (decoded['message'] as String).trim().isNotEmpty) {
          errorMessage = decoded['message'];
        } else if (decoded['error'] is String && (decoded['error'] as String).trim().isNotEmpty) {
          errorMessage = decoded['error'];
        } else if (decoded['errors'] != null) {
          final errs = decoded['errors'];
          if (errs is List) {
            // Joindre les erreurs de type liste
            errorMessage = errs.map((e) => e.toString()).join('\n');
          } else if (errs is Map) {
            // Concaténer les messages par champ
            final parts = <String>[];
            errs.forEach((key, val) {
              if (val is List) {
                parts.add('$key: ' + val.map((e) => e.toString()).join(', '));
              } else {
                parts.add('$key: ${val.toString()}');
              }
            });
            if (parts.isNotEmpty) errorMessage = parts.join('\n');
          }
        }
      }
    } catch (_) {
      // Si parsing échoue, conserver le message par défaut
    }
    throw Exception(errorMessage);
  }

  // Valider une candidature (RECRUTEUR)
  static Future<bool> validerCandidature(int candidatureId) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/api/candidatures/$candidatureId/valider');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.put(url, headers: headers);

    print('✅ Validation candidature $candidatureId');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      return true;
    }

    String errorMessage = 'Erreur lors de la validation: ${response.statusCode}';
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] is String && (decoded['message'] as String).trim().isNotEmpty) {
          errorMessage = decoded['message'];
        } else if (decoded['error'] is String && (decoded['error'] as String).trim().isNotEmpty) {
          errorMessage = decoded['error'];
        }
      }
    } catch (_) {}
    throw Exception(errorMessage);
  }

  // Rejeter une candidature (RECRUTEUR)
  static Future<bool> rejeterCandidature(int candidatureId) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}/api/candidatures/$candidatureId/rejeter');

    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.put(url, headers: headers);

    print('❌ Rejet candidature $candidatureId');
    print('📥 Status: ${response.statusCode}');
    print('📥 Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      return true;
    }

    String errorMessage = 'Erreur lors du rejet: ${response.statusCode}';
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] is String && (decoded['message'] as String).trim().isNotEmpty) {
          errorMessage = decoded['message'];
        } else if (decoded['error'] is String && (decoded['error'] as String).trim().isNotEmpty) {
          errorMessage = decoded['error'];
        }
      }
    } catch (_) {}
    throw Exception(errorMessage);
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