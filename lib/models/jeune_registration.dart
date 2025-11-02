class JeuneRegistrationRequest {
  final String nom;
  final String prenom;
  final String genre;
  final String? email;
  final String telephone;
  final String motDePasse;
  final String confirmationMotDePasse;

  JeuneRegistrationRequest({
    required this.nom,
    required this.prenom,
    required this.genre,
    this.email,
    required this.telephone,
    required this.motDePasse,
    required this.confirmationMotDePasse,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'nom': nom,
      'prenom': prenom,
      'genre': genre,
      'telephone': telephone,
      'motDePasse': motDePasse,
      'confirmationMotDePasse': confirmationMotDePasse,
    };
    
    // Ajouter email seulement s'il n'est pas null et non vide
    if (email != null && email!.isNotEmpty) {
      json['email'] = email;
    }
    
    return json;
  }
}

