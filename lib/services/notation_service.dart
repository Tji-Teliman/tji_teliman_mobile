import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_service.dart';

class NotationService {
  static const String _noterJeuneEndpoint = '/api/notations/recruteur-noter-jeune';
  static const String _noterRecruteurEndpoint = '/api/notations/jeune-noter-recruteur';

  static Future<Map<String, dynamic>> noterJeune({
    required int candidatureId,
    required int note,
    String? commentaire,
  }) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$_noterJeuneEndpoint/$candidatureId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'note': note,
        if (commentaire != null && commentaire.trim().isNotEmpty) 'commentaire': commentaire.trim(),
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'success': true, 'data': decoded};
    }

    throw Exception(_extractError(response));
  }

  static Future<Map<String, dynamic>> noterRecruteur({
    required int candidatureId,
    required int note,
    String? commentaire,
  }) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$_noterRecruteurEndpoint/$candidatureId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'note': note,
        if (commentaire != null && commentaire.trim().isNotEmpty) 'commentaire': commentaire.trim(),
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'success': true, 'data': decoded};
    }

    throw Exception(_extractError(response));
  }

  static String _extractError(http.Response response) {
    String msg = 'Erreur (${response.statusCode})';
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] is String && decoded['message'].toString().trim().isNotEmpty) {
          return decoded['message'];
        }
        if (decoded['error'] is String && decoded['error'].toString().trim().isNotEmpty) {
          return decoded['error'];
        }
        if (decoded['errors'] != null) {
          final errs = decoded['errors'];
          if (errs is List) return errs.map((e) => e.toString()).join('\n');
          if (errs is Map) {
            final parts = <String>[];
            errs.forEach((k, v) {
              if (v is List) {
                parts.add('$k: ' + v.map((e) => e.toString()).join(', '));
              } else {
                parts.add('$k: ${v.toString()}');
              }
            });
            if (parts.isNotEmpty) return parts.join('\n');
          }
        }
      }
    } catch (_) {}
    return msg;
  }
}
