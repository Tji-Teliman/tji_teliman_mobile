import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'token_service.dart';

class ProfileService {
  static const String _profilEndpoint = '/api/profiles/mon-profil';
  static const String _competencesEndpoint = '/api/admin/competences';

  static Future<Map<String, dynamic>> getMonProfil() async {
    final token = await TokenService.getToken();
    final uri = Uri.parse('${ApiConfig.baseUrl}$_profilEndpoint');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Erreur récupération profil: ${response.statusCode} ${response.body}');
  }

  static Future<List<Map<String, dynamic>>> getCompetences() async {
    final token = await TokenService.getToken();
    final uri = Uri.parse('${ApiConfig.baseUrl}$_competencesEndpoint');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.map<Map<String, dynamic>>((e) => (e as Map).map((k, v) => MapEntry(k.toString(), v))).toList();
      }
      throw Exception('Format compétences inattendu: ${response.body}');
    }
    throw Exception('Erreur récupération compétences: ${response.statusCode} ${response.body}');
  }

  static Future<Map<String, dynamic>> updateMonProfil({
    Map<String, String>? fields,
    // Mobile/Desktop (dart:io)
    File? photoProfil,
    File? carteIdentite,
    // Web support
    Uint8List? photoBytes,
    String? photoFilename,
    Uint8List? carteIdentiteBytes,
    String? carteIdentiteFilename,
  }) async {
    final token = await TokenService.getToken();
    final uri = Uri.parse('${ApiConfig.baseUrl}$_profilEndpoint');

    final request = http.MultipartRequest('POST', uri);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    if (fields != null && fields.isNotEmpty) {
      request.fields.addAll(fields);
    }

    // Ajout photo de profil
    if (kIsWeb) {
      if (photoBytes != null && (photoFilename ?? '').isNotEmpty) {
        request.files.add(http.MultipartFile.fromBytes('photo', photoBytes, filename: photoFilename));
      }
      if (carteIdentiteBytes != null && (carteIdentiteFilename ?? '').isNotEmpty) {
        request.files.add(http.MultipartFile.fromBytes('carteIdentite', carteIdentiteBytes, filename: carteIdentiteFilename));
      }
    } else {
      if (photoProfil != null) {
        request.files.add(await http.MultipartFile.fromPath('photo', photoProfil.path));
      }
      if (carteIdentite != null) {
        request.files.add(await http.MultipartFile.fromPath('carteIdentite', carteIdentite.path));
      }
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Erreur mise à jour profil: ${response.statusCode} ${response.body}');
  }

  // Aucun utilitaire d'inférence de type nécessaire
}
