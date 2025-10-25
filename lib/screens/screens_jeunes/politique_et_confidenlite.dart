import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';


class PolitiqueEtConfidenlite extends StatelessWidget {
  const PolitiqueEtConfidenlite({super.key});

  @override
  Widget build(BuildContext context) {
    return const PrivacyPolicyScreen();
  }
}

// Définition des couleurs personnalisées
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App
const Color customLightBlue = Color(0xFFE3F2FD); // Couleur de fond pour les icônes

// Modèle pour les sections de la Politique de Confidentialité
class PolicySection {
  final String title;
  final String description;

  const PolicySection({required this.title, required this.description});
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  // Données spécifiques à la Politique de Confidentialité
  final String lastUpdated = "23 Octobre 2025";

  final List<PolicySection> policyItems = const [
    PolicySection(
      title: "Tes informations et ta vie privée",
      description: "Nous collectons des informations que vous nous fournissez directement, comme votre nom, adresse e-mail, et informations de profil. Nous pouvons également collecter des données automatiquement, telles que votre adresse IP et les informations sur votre appareil.",
    ),
    PolicySection(
      title: "Comment nous utilisons vos informations",
      description: "Nous utilisons vos données pour faire fonctionner l'application, sécuriser votre compte, vous proposer des missions pertinentes, et améliorer nos services.",
    ),
    PolicySection(
      title: "Partage des informations",
      description: "Nous partageons uniquement les informations nécessaires à la mission (avec les recruteurs) ou à la loi l'exige. Nous ne vendons pas vos informations personnelles.",
    ),
    PolicySection(
      title: "Vos droits",
      description: "Vous avez le droit d'accéder à vos données, de les corriger, de les supprimer, et de vous opposer à leur traitement. Vous pouvez gérer ces droits dans les Paramètres de l'application.",
    ),
    PolicySection(
      title: "Contact",
      description: "Pour toute question concernant cette politique, veuillez nous contacter via la section 'Nous Contacter' de l'application.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: const CustomHeader(
        title: 'Politique de Confidentialité',
      ),
      
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // --- Date de dernière mise à jour ---
                    Text(
                      'Dernière mise à jour : $lastUpdated. Bienvenue sur notre application. Nous nous engageons à protéger votre vie privée. Cette politique explique quelles informations nous collectons, comment nous les utilisons, et vos droits concernant vos données.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 25),

                    // --- Liste des sections de la Politique ---
                    Column(
                      children: policyItems.map((item) {
                        return PolicyCard(policySection: item);
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 30), // Espace en bas de la page
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget pour afficher chaque section de la Politique
class PolicyCard extends StatelessWidget {
  final PolicySection policySection;

  const PolicyCard({super.key, required this.policySection});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre (Question)
          Text(
            policySection.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          
          // Contenu (Réponse)
          Text(
            policySection.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
