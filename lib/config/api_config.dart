class ApiConfig {
  // URL de base de votre API Spring Boot
  // Pour Android émulateur, utilisez: http://10.0.2.2:8080
  // Pour appareil physique, utilisez l'IP locale de votre machine: http://192.168.x.x:8080
  // Pour web, utilisez: http://localhost:8080
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Endpoints d'authentification
  static const String registerJeune = '/api/auth/register/jeune';
  static const String registerRecruteur = '/api/auth/register/recruteur';
  static const String login = '/api/auth/connexion';
}

