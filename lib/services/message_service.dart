import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_service.dart';

class ConversationSummary {
  final int destinataireId;
  final String destinataireNom;
  final String destinatairePrenom;
  final String? destinatairePhoto; // raw value from backend
  final String dernierMessage;
  final String dateDernierMessage; // keep raw string for now
  final int messagesNonLus;
  final String typeDernierMessage;

  ConversationSummary({
    required this.destinataireId,
    required this.destinataireNom,
    required this.destinatairePrenom,
    required this.destinatairePhoto,
    required this.dernierMessage,
    required this.dateDernierMessage,
    required this.messagesNonLus,
    required this.typeDernierMessage,
  });

  String get fullName {
    final nom = destinataireNom.trim();
    final prenom = destinatairePrenom.trim();
    if (prenom.isEmpty && nom.isEmpty) return 'Utilisateur';
    if (prenom.isEmpty) return nom;
    if (nom.isEmpty) return prenom;
    return '$prenom $nom';
  }

  // Try to turn backend path into a usable HTTP URL. Returns null if not resolvable.
  String? get resolvedPhotoUrl {
    final p = destinatairePhoto;
    if (p == null || p.trim().isEmpty) return null;
    final s = p.trim();
    if (s.startsWith('http://') || s.startsWith('https://')) return s;
    // Try to extract from local path, keep part after 'uploads'
    final normalized = s.replaceAll('\\', '/');
    final idx = normalized.toLowerCase().indexOf('/uploads/');
    if (idx != -1) {
      final tail = normalized.substring(idx); // /uploads/...
      return ApiConfig.baseUrl + tail; // assumes backend serves uploads statically
    }
    return null;
  }

  factory ConversationSummary.fromJson(Map<String, dynamic> json) {
    return ConversationSummary(
      destinataireId: _toInt(json['destinataireId']) ?? 0,
      destinataireNom: (json['destinataireNom'] ?? '').toString(),
      destinatairePrenom: (json['destinatairePrenom'] ?? '').toString(),
      destinatairePhoto: json['destinatairePhoto']?.toString(),
      dernierMessage: (json['dernierMessage'] ?? '').toString(),
      dateDernierMessage: (json['dateDernierMessage'] ?? '').toString(),
      messagesNonLus: _toInt(json['messagesNonLus']) ?? 0,
      typeDernierMessage: (json['typeDernierMessage'] ?? '').toString(),
    );
  }
}

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

class MessageService {
  static const String _conversationsEndpoint = '/api/messages/conversations';
  static const String _conversationEndpoint = '/api/messages/conversation';
  static const String _sendTextEndpoint = '/api/messages/texte';

  static Future<List<ConversationSummary>> getConversations() async {
    final token = await TokenService.getToken();
    final url = Uri.parse(ApiConfig.baseUrl + _conversationsEndpoint);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List dataList;
      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        dataList = decoded['data'];
      } else if (decoded is List) {
        dataList = decoded;
      } else {
        dataList = const [];
      }
      return dataList
          .whereType<Map<String, dynamic>>()
          .map((e) => ConversationSummary.fromJson(e))
          .toList();
    }
    throw Exception('Erreur lors de la récupération des conversations: ${response.statusCode}');
  }

  static String? _resolvePhotoUrl(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final s = raw.trim();
    if (s.startsWith('http://') || s.startsWith('https://')) return s;
    final normalized = s.replaceAll('\\', '/');
    final idx = normalized.toLowerCase().indexOf('/uploads/');
    if (idx != -1) {
      final tail = normalized.substring(idx);
      return ApiConfig.baseUrl + tail;
    }
    return null;
  }

  static Future<List<Map<String, dynamic>>> getConversationMessages({required int destinataireId}) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$_conversationEndpoint/$destinataireId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        return (decoded['data'] as List).cast<Map<String, dynamic>>();
      }
      if (decoded is List) return decoded.cast<Map<String, dynamic>>();
      return <Map<String, dynamic>>[];
    }
    throw Exception('Erreur lors du chargement des messages: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> sendTextMessage({required int destinataireId, required String contenu}) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$_sendTextEndpoint/$destinataireId');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({'contenu': contenu}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic> && decoded['data'] is Map<String, dynamic>) {
        final data = (decoded['data'] as Map<String, dynamic>);
        final photo = _resolvePhotoUrl(data['expediteurPhoto']?.toString());
        return {
          ...data,
          'expediteurPhotoResolved': photo,
        };
      }
      return {};
    }
    String msg = 'Erreur envoi message: ${response.statusCode}';
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        msg = decoded['message'];
      }
    } catch (_) {}
    throw Exception(msg);
  }
}
