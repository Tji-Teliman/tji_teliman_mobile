import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_service.dart';

class ApiService {
  static Future<http.Response> get(String endpoint) async {
    final token = await TokenService.getToken();
    
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  static Future<http.Response> post(String endpoint, dynamic data) async {
    final token = await TokenService.getToken();
    
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> put(String endpoint, dynamic data) async {
    final token = await TokenService.getToken();
    
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> delete(String endpoint) async {
    final token = await TokenService.getToken();
    
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  static http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 401) {
      // Token expiré ou invalide - déconnexion
      TokenService.logout();
      throw Exception('Session expirée. Veuillez vous reconnecter.');
    } else {
      throw Exception('Erreur HTTP: ${response.statusCode}');
    }
  }
}