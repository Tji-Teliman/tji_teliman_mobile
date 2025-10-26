import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';


class ConditionsGenerales extends StatelessWidget {
  const ConditionsGenerales({super.key});

  @override
  Widget build(BuildContext context) {
    return const CguScreen();
  }
}

// Définition des couleurs personnalisées
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App
const Color customLightBlue = Color(0xFFE3F2FD); // Couleur de fond pour les icônes

// Modèle pour les sections des CGU
class CguSection {
  final IconData icon;
  final String title;
  final String description;

  const CguSection({required this.icon, required this.title, required this.description});
}

class CguScreen extends StatelessWidget {
  const CguScreen({super.key});

  // Données spécifiques aux Conditions Générales d'Utilisation
  final List<CguSection> cguItems = const [
    CguSection(
      icon: Icons.person_outline,
      title: "Ce que tu peux faire sur l'app",
      description: "Tu peux explorer des missions, postuler, et interagir avec d'autres jeunes. L'app est là pour t'aider à trouver des opportunités et à te connecter.",
    ),
    CguSection(
      icon: Icons.info_outline,
      title: "Tes informations et ta vie privée",
      description: "Tes données sont importantes. On les utilise pour améliorer l'app et te proposer des missions adaptées. Tu peux contrôler tes informations dans les paramètres.",
    ),
    CguSection(
      icon: Icons.rule_sharp,
      title: "Les règles à suivre",
      description: "Sois respectueux avec les autres, ne partage pas de contenu inapproprié, et utilise l'app de manière responsable. Si tu ne respectes pas les règles, ton compte pourrait être suspendu.",
    ),
    CguSection(
      icon: Icons.autorenew,
      title: "Mises à jour des conditions",
      description: "On peut changer ces conditions de temps en temps. On te préviendra si c'est le cas, et tu pourras les consulter à nouveau.",
    ),
    CguSection(
      icon: Icons.verified_user_outlined,
      title: "Consentement et Âge Minimum",
      description: "En utilisant cette application, tu certifies avoir l'âge minimum requis pour travailler dans ton pays (généralement 18 ans, ou l'âge légal avec autorisation parentale). L'application n'est pas responsable des fausses déclarations d'âge.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Conditions Générales d\'Utilisation (Jeune)',
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: cguItems.map((item) {
                return CguCard(cguSection: item);
              }).toList(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Widget pour afficher chaque section des CGU
class CguCard extends StatelessWidget {
  final CguSection cguSection;

  const CguCard({super.key, required this.cguSection});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200), // Bordure légère pour délimiter
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icône circulaire bleu clair
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: customLightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(cguSection.icon, color: customBlue, size: 24),
          ),
          const SizedBox(width: 15),
          
          // Texte (Titre et Description)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cguSection.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  cguSection.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
