import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'contacter_nous.dart';


class FaqSecurity extends StatelessWidget {
  const FaqSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return const FaqSecurityScreen();
  }
}

// Définition des couleurs personnalisées
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App et boutons
const Color lightBlueButton = Color(0xFFE3F2FD); // Couleur de fond pour les cartes

// Modèle pour les questions/réponses FAQ
class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

class FaqSecurityScreen extends StatelessWidget {
  const FaqSecurityScreen({super.key});

  // Données spécifiques à la FAQ Sécurité & Confidentialité
  final List<FaqItem> faqItems = const [
    FaqItem(
      question: "Comment protéger mon compte ?",
      answer: "Pour protéger votre compte, utilisez un mot de passe fort et unique, activez l'authentification à deux facteurs, et soyez vigilant face aux tentatives de phishing.",
    ),
    FaqItem(
      question: "Mes informations sont-elles partagées ?",
      answer: "Nous respectons notre Politique de Confidentialité. Seules les informations nécessaires à la mission (prénom, compétences, note) sont partagées avec les recruteurs. Vos données ne sont jamais vendues à des tiers.",
    ),
    FaqItem(
      question: "Comment signaler un comportement suspect ?",
      answer: "Utilisez l'icône \"Signaler\" (alert) sur la page de mission. Notre équipe interviendra rapidement.",
    ),
    FaqItem(
      question: "Que faire en cas de compte piraté ?",
      answer: "Contactez immédiatement notre support via le bouton \"Envoyer l'avis\" en bas de page. Nous prendrons des mesures pour sécuriser et restaurer votre accès.",
    ),
    FaqItem(
      question: "Comment désactiver les notifications ?",
      answer: "Allez dans Paramètres > Notifications pour gérer et désactiver les alertes que vous ne souhaitez plus recevoir.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Sécurité & Confidentialité',
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Catégories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: Column(
                children: faqItems.map((item) {
                  return FaqExpansionTile(faqItem: item);
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.help_outline, color: customBlue, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Vous n'avez pas trouvé de réponse ?",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ContacterNous()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customBlue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Envoyer l'avis",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget de question/réponse avec ExpansionTile
class FaqExpansionTile extends StatelessWidget {
  final FaqItem faqItem;

  const FaqExpansionTile({super.key, required this.faqItem});

  @override
  Widget build(BuildContext context) {
    // Le Container englobant permet d'ajouter le style de carte
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // Ombre plus visible pour compenser l'absence de bordure
            color: Colors.grey.withOpacity(0.2), 
            spreadRadius: 0, // Ajustement pour une ombre plus douce
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
        
        // Titre (Question)
        title: Text(
          faqItem.question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        
        // Icône de l'ExpansionTile (flèche Haut/Bas)
        iconColor: customBlue,
        collapsedIconColor: customBlue,

        // Contenu (Réponse)
        children: <Widget>[
          Text(
            faqItem.answer,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.justify, // Permet d'aligner le texte des réponses pour une meilleure lisibilité
          ),
        ],
      ),
    );
  }
}
