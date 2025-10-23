import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';



class HistoriqueLitige extends StatelessWidget {
  const HistoriqueLitige({super.key});

  @override
  Widget build(BuildContext context) {
    return const DisputeHistoryScreen();
  }
}

// Définition des couleurs personnalisées
const Color customOrange = Color(0xFFF59E0B);
const Color customBlue = Color(0xFF2563EB);
const Color accentColor = Color(0xFF4DD0E1); // Pour le dégradé de l'AppBar

// Modèle de données pour un litige
class DisputeRecord {
  final String title;
  final String date;
  final String status;

  const DisputeRecord({required this.title, required this.date, required this.status});
}

class DisputeHistoryScreen extends StatelessWidget {
  const DisputeHistoryScreen({super.key});

  // Données de simulation pour l'historique
  final List<DisputeRecord> activeDisputes = const [
    DisputeRecord(title: "Livraison", date: "12/03/2025", status: "En Cours"),
    DisputeRecord(title: "Aide Demenagement", date: "12/03/2025", status: "Ouvert"),
    DisputeRecord(title: "Livraison", date: "12/03/2025", status: "En Cours"),
  ];

  final List<DisputeRecord> resolvedDisputes = const [
    DisputeRecord(title: "Aide Domestique", date: "12/03/2025", status: "Résolu"),
    DisputeRecord(title: "Livraison", date: "12/03/2025", status: "Fermé"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc), // Couleur de fond du CustomHeader
      appBar: CustomHeader(
        title: 'Historique des Litiges',
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Section Filtres ---
            const FilterSection(),
            const SizedBox(height: 25),

            // --- Section Actifs ---
            const SectionTitle(title: 'Actifs'),
            ...activeDisputes.map((record) => DisputeCard(record: record)).toList(),
            const SizedBox(height: 30),

            // --- Section Résolus & Fermés ---
            const SectionTitle(title: 'Résolus & Fermés'),
            ...resolvedDisputes.map((record) => DisputeCard(record: record)).toList(),
          ],
        ),
      ),
    );
  }
}

// Widget de titre de section (Actifs, Résolus & Fermés)
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 5.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }
}

// Widget pour la section Filtres (Titre + Dropdown)
class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Style du Dropdown pour correspondre au design
    final OutlineInputBorder borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text(
          'Filtres',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        Container(
          width: 150, // Taille fixe pour le dropdown
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: 'Tous les status',
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              isExpanded: true,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              items: <String>['Tous les status', 'Ouvert', 'En Cours', 'Résolu', 'Fermé']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Logique de filtrage
              },
            ),
          ),
        ),
      ],
    );
  }
}

// Widget pour une seule carte de litige
class DisputeCard extends StatelessWidget {
  final DisputeRecord record;

  const DisputeCard({super.key, required this.record});

  // Fonction pour déterminer la couleur du badge en fonction du statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ouvert':
        return customOrange; // Orange
      case 'En Cours':
        return Colors.blue.shade400; // Bleu clair
      case 'Résolu':
        return Colors.lightGreen.shade400; // Vert
      case 'Fermé':
        return Colors.grey.shade400; // Gris
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(record.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // --- Titre et Date ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  record.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.date,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            
            // --- Badge de Statut ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15), // Fond très clair
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                record.status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
