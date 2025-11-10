import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_service.dart';

class PaymentService {
  static const String _paiementsStatutEndpoint = '/api/paiements/statut/EN_ATTENTE';
  static const String _paiementCandidatureEndpoint = '/api/paiements/candidature';
  static const String _mesPaiementsRecruteurEndpoint = '/api/paiements/mes-paiements-recruteur';
  static const String _mesPaiementsJeuneEndpoint = '/api/paiements/mes-paiements-jeune';

  // Récupérer la liste des paiements en attente
  static Future<List<Map<String, dynamic>>> getPaiementsEnAttente() async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$_paiementsStatutEndpoint');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }
      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        return (decoded['data'] as List).cast<Map<String, dynamic>>();
      }
      return <Map<String, dynamic>>[];
    }
    throw Exception('Erreur lors de la récupération des paiements en attente: ${response.statusCode}');
  }

  // Effectuer un paiement pour une candidature donnée
  static Future<bool> postPaiement({
    required int candidatureId,
    required String telephone,
    required double montant,
  }) async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$_paiementCandidatureEndpoint/$candidatureId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'telephone': telephone,
        'montant': montant,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
      return true;
    }

    // Try to extract a helpful error message
    String errorMessage = 'Erreur paiement: ${response.statusCode}';
    try {
      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        if (decoded['message'] is String && (decoded['message'] as String).trim().isNotEmpty) {
          errorMessage = decoded['message'];
        } else if (decoded['error'] is String && (decoded['error'] as String).trim().isNotEmpty) {
          errorMessage = decoded['error'];
        } else if (decoded['errors'] != null) {
          final errs = decoded['errors'];
          if (errs is List) {
            errorMessage = errs.map((e) => e.toString()).join('\n');
          } else if (errs is Map) {
            final parts = <String>[];
            errs.forEach((k, v) {
              if (v is List) {
                parts.add('$k: ' + v.map((e) => e.toString()).join(', '));
              } else {
                parts.add('$k: ${v.toString()}');
              }
            });
            if (parts.isNotEmpty) errorMessage = parts.join('\n');
          }
        }
      }
    } catch (_) {}
    throw Exception(errorMessage);
  }

  static Future<List<Map<String, dynamic>>> getMesPaiementsRecruteur() async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$_mesPaiementsRecruteurEndpoint');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }
      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        return (decoded['data'] as List).cast<Map<String, dynamic>>();
      }
      return <Map<String, dynamic>>[];
    }
    throw Exception('Erreur lors de la récupération des paiements recruteur: ${response.statusCode}');
  }

  static Future<List<Map<String, dynamic>>> getMesPaiementsJeune() async {
    final token = await TokenService.getToken();
    final url = Uri.parse('${ApiConfig.baseUrl}$_mesPaiementsJeuneEndpoint');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.cast<Map<String, dynamic>>();
      }
      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        return (decoded['data'] as List).cast<Map<String, dynamic>>();
      }
      return <Map<String, dynamic>>[];
    }
    throw Exception('Erreur lors de la récupération des paiements jeune: ${response.statusCode}');
  }
}
