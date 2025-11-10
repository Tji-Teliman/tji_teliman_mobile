import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';
  static const String _userRoleKey = 'user_role';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _recruiterTypeKey = 'user_recruiter_type'; // ENTREPRISE / PARTICULIER

  // Sauvegarder le token et les infos utilisateur
  static Future<void> saveToken(String token, String role, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userRoleKey, role);
    await prefs.setInt(_userIdKey, userId);
  }

  // Sauvegarder le nom de l'utilisateur
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  // Sauvegarder le type de recruteur
  static Future<void> saveRecruiterType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_recruiterTypeKey, type);
  }

  // Récupérer le token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Récupérer le rôle de l'utilisateur
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  // Récupérer l'ID de l'utilisateur
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  // Récupérer le nom de l'utilisateur
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Récupérer le type de recruteur (ENTREPRISE / PARTICULIER)
  static Future<String?> getRecruiterType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_recruiterTypeKey);
  }

  // Vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Déconnexion
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_recruiterTypeKey);
  }

  // Récupérer toutes les infos utilisateur
  static Future<Map<String, dynamic>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString(_tokenKey),
      'role': prefs.getString(_userRoleKey),
      'id': prefs.getInt(_userIdKey),
      'name': prefs.getString(_userNameKey),
      'recruiterType': prefs.getString(_recruiterTypeKey),
    };
  }
}