import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'contacter_nous.dart';


class PostulerEtCandidature extends StatelessWidget {
  const PostulerEtCandidature({super.key});

  @override
  Widget build(BuildContext context) {
    return const FaqApplicationScreen();
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

class FaqApplicationScreen extends StatelessWidget {
  const FaqApplicationScreen({super.key});

  // Données spécifiques à la FAQ Postuler & Candidature
  final List<FaqItem> faqItems = const [
    FaqItem(
      question: "Comment postuler à une mission ?",
      answer: "Allez à la section \"Missions\", sélectionnez la mission qui vous intéresse, et cliquez sur le bouton \"Postuler\". Assurez-vous que votre profil est complet et à jour !",
    ),
    FaqItem(
      question: "Puis-je modifier ma candidature après l'envoi ?",
      answer: "Non, une fois envoyée, une candidature est définitive. Vous pouvez cependant contacter le recruteur via la messagerie intégrée pour fournir des informations supplémentaires ou clarifier votre profil.",
    ),
    FaqItem(
      question: "Que signifie le statut 'En attente' ?",
      answer: "Le recruteur a bien reçu votre candidature et est en train de l'examiner. Il compare votre profil avec celui des autres candidats. Ce statut peut durer de quelques heures à 48 heures maximum.",
    ),
    FaqItem(
      question: "Comment savoir si ma candidature est acceptée ?",
      answer: "Vous recevrez une notification immédiate  dans l'application si votre candidature est acceptée. Le statut de la mission passera à 'Accepté' dans votre tableau de bord.",
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Postuler & Candidature',
        onBack: () {
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            navigator.pushReplacementNamed('/');
          }
        },
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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
