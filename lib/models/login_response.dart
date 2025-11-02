class LoginResponse {
  final bool success;
  final String message;
  final LoginData data;

  LoginResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: LoginData.fromJson(json['data'] ?? {}),
    );
  }
}

class LoginData {
  final User user;
  final String token;

  LoginData({
    required this.user,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: User.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
    );
  }
}

class User {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String? email;
  final String role;
  final String genre;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.email,
    required this.role,
    required this.genre,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'],
      role: json['role'] ?? '',
      genre: json['genre'] ?? '',
    );
  }
}