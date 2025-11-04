class Category {
  final int id;
  final String nom;
  final String urlPhoto;
  final int missionsCount;

  Category({
    required this.id,
    required this.nom,
    required this.urlPhoto,
    required this.missionsCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      urlPhoto: json['urlPhoto'] ?? '',
      missionsCount: json['missionsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'urlPhoto': urlPhoto,
      'missionsCount': missionsCount,
    };
  }
}

