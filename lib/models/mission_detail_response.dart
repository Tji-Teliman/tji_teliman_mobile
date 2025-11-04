import 'mission.dart';

class MissionDetailResponse {
  final bool success;
  final String message;
  final MissionDetailData data;

  MissionDetailResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MissionDetailResponse.fromJson(Map<String, dynamic> json) {
    return MissionDetailResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MissionDetailData.fromJson(json['data'] ?? {}),
    );
  }
}

class MissionDetailData {
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
  final double? remuneration;
  final String datePublication;
  final String statut;
  final String? heureDebut;
  final String? heureFin;
  final int dureJours;
  final int dureHeures;
  final String categorieNom;
  final String categorieUrlPhoto;
  final int nombreCandidatures;
  final String? recruteurNom;
  final String? recruteurPrenom;
  final String? recruteurUrlPhoto;
  final double? recruteurNote;

  MissionDetailData({
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
    this.heureDebut,
    this.heureFin,
    required this.dureJours,
    required this.dureHeures,
    required this.categorieNom,
    required this.categorieUrlPhoto,
    required this.nombreCandidatures,
    this.recruteurNom,
    this.recruteurPrenom,
    this.recruteurUrlPhoto,
    this.recruteurNote,
  });

  factory MissionDetailData.fromJson(Map<String, dynamic> json) {
    return MissionDetailData(
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
      remuneration: json['remuneration'] != null 
          ? (json['remuneration'] is double 
             ? json['remuneration'] 
             : double.tryParse(json['remuneration'].toString()) ?? 0.0)
          : null,
      datePublication: json['datePublication'] ?? '',
      statut: json['statut'] ?? '',
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      dureJours: json['dureJours'] ?? 0,
      dureHeures: json['dureHeures'] ?? 0,
      categorieNom: json['categorieNom'] ?? '',
      categorieUrlPhoto: json['categorieUrlPhoto'] ?? '',
      nombreCandidatures: json['nombreCandidatures'] ?? 0,
      recruteurNom: json['recruteurNom'],
      recruteurPrenom: json['recruteurPrenom'],
      recruteurUrlPhoto: json['recruteurUrlPhoto'],
      recruteurNote: json['recruteurNote'] != null
          ? (json['recruteurNote'] is double
             ? json['recruteurNote']
             : double.tryParse(json['recruteurNote'].toString()))
          : null,
    );
  }

  // Convertir en Mission pour compatibilité
  Mission toMission() {
    return Mission(
      id: id,
      titre: titre,
      description: description,
      exigence: exigence,
      dateDebut: dateDebut,
      dateFin: dateFin,
      latitude: latitude,
      longitude: longitude,
      adresse: adresse,
      placeId: placeId,
      remuneration: remuneration,
      datePublication: datePublication,
      statut: statut,
      heureDebut: heureDebut,
      heureFin: heureFin,
      dureJours: dureJours,
      dureHeures: dureHeures,
      categorieNom: categorieNom,
      categorieUrlPhoto: categorieUrlPhoto,
      nombreCandidatures: nombreCandidatures,
    );
  }
}

