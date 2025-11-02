class MissionRecruteurResponse {
  final bool success;
  final String message;
  final List<Mission> data;

  MissionRecruteurResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MissionRecruteurResponse.fromJson(Map<String, dynamic> json) {
    return MissionRecruteurResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((missionJson) => Mission.fromJson(missionJson))
          .toList() ?? [],
    );
  }
}

class Mission {
  final int id;
  final String titre;
  final String description;
  final String exigence;
  final String dateDebut;
  final String dateFin;
  final double latitude;
  final double longitude;
  final String adresse;
  final String placeId;
  final String? remuneration;
  final String datePublication;
  final String statut;
  final String heureDebut;
  final String heureFin;
  final int dureJours;
  final int dureHeures;
  final String categorieNom;
  final String categorieUrlPhoto;
  final int nombreCandidatures;

  Mission({
    required this.id,
    required this.titre,
    required this.description,
    required this.exigence,
    required this.dateDebut,
    required this.dateFin,
    required this.latitude,
    required this.longitude,
    required this.adresse,
    required this.placeId,
    this.remuneration,
    required this.datePublication,
    required this.statut,
    required this.heureDebut,
    required this.heureFin,
    required this.dureJours,
    required this.dureHeures,
    required this.categorieNom,
    required this.categorieUrlPhoto,
    required this.nombreCandidatures,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] ?? 0,
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      exigence: json['exigence'] ?? '',
      dateDebut: json['dateDebut'] ?? '',
      dateFin: json['dateFin'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      adresse: json['adresse'] ?? '',
      placeId: json['placeId'] ?? '',
      remuneration: json['remuneration'],
      datePublication: json['datePublication'] ?? '',
      statut: json['statut'] ?? '',
      heureDebut: json['heureDebut'] ?? '',
      heureFin: json['heureFin'] ?? '',
      dureJours: json['dureJours'] ?? 0,
      dureHeures: json['dureHeures'] ?? 0,
      categorieNom: json['categorieNom'] ?? '',
      categorieUrlPhoto: json['categorieUrlPhoto'] ?? '',
      nombreCandidatures: json['nombreCandidatures'] ?? 0,
    );
  }
}