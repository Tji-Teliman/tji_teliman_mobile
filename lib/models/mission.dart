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
  final double? remuneration; // Changé de String? à double?
  final String datePublication;
  final String statut;
  final String? heureDebut; // Changé à nullable
  final String? heureFin;   // Changé à nullable
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
    this.heureDebut, // Maintenant optionnel
    this.heureFin,   // Maintenant optionnel
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
      // Gestion de la rémunération comme double
      remuneration: json['remuneration'] != null 
          ? (json['remuneration'] is double 
             ? json['remuneration'] 
             : double.tryParse(json['remuneration'].toString()) ?? 0.0)
          : null,
      datePublication: json['datePublication'] ?? '',
      statut: json['statut'] ?? '',
      // Heures maintenant optionnelles
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      dureJours: json['dureJours'] ?? 0,
      dureHeures: json['dureHeures'] ?? 0,
      categorieNom: json['categorieNom'] ?? '',
      categorieUrlPhoto: json['categorieUrlPhoto'] ?? '',
      nombreCandidatures: json['nombreCandidatures'] ?? 0,
    );
  }

  // Méthode pour formater la date
  String get formattedDateDebut {
    try {
      final date = DateTime.parse(dateDebut);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateDebut;
    }
  }

  String get formattedDateFin {
    try {
      final date = DateTime.parse(dateFin);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateFin;
    }
  }

  // Méthode pour obtenir la durée formatée
  String get formattedDuree {
    if (dureJours > 0) {
      return '$dureJours jour${dureJours > 1 ? 's' : ''}';
    } else {
      return '$dureHeures heure${dureHeures > 1 ? 's' : ''}';
    }
  }

  // Méthode pour obtenir le prix formaté - ADAPTÉE POUR DOUBLE
  String get formattedPrice {
    if (remuneration != null) {
      // Formater le double avec séparateur de milliers
      final formatted = remuneration!.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      );
      return '$formatted CFA';
    }
    return 'Non spécifié';
  }

  // Méthode pour obtenir les heures formatées (gère les valeurs null)
  String get formattedHeures {
    if (heureDebut != null && heureFin != null) {
      return '$heureDebut - $heureFin';
    } else if (heureDebut != null) {
      return 'À partir de $heureDebut';
    } else if (heureFin != null) {
      return 'Jusqu\'à $heureFin';
    } else {
      return 'Horaires non spécifiés';
    }
  }

  // Méthode pour obtenir le temps restant
  String get tempsRestant {
    try {
      final now = DateTime.now();
      final startDate = DateTime.parse(dateDebut);
      final difference = startDate.difference(now);

      if (difference.isNegative) {
        return 'Commencée';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} min';
      } else {
        return 'Maintenant';
      }
    } catch (e) {
      return 'Date invalide';
    }
  }

  // Méthode pour vérifier si la mission est urgente
  bool get isUrgent {
    try {
      final now = DateTime.now();
      final startDate = DateTime.parse(dateDebut);
      final difference = startDate.difference(now);
      
      return difference.inHours <= 24 && difference.inHours >= 0;
    } catch (e) {
      return false;
    }
  }

  // Méthode utilitaire pour vérifier si les heures sont disponibles
  bool get hasHeures => heureDebut != null || heureFin != null;

  // Méthode utilitaire pour vérifier si la rémunération est disponible
  bool get hasRemuneration => remuneration != null;

  // Méthode pour obtenir la rémunération avec valeur par défaut
  double get remunerationWithDefault => remuneration ?? 0.0;
}