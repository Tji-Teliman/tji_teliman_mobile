import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'contacter_nous.dart';


class FaqCompteProfil extends StatelessWidget {
  const FaqCompteProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return const FaqProfileScreen();
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

class FaqProfileScreen extends StatelessWidget {
  const FaqProfileScreen({super.key});

  final List<FaqItem> faqItems = const [
    FaqItem(
      question: "Comment modifier mon profil ?",
      answer: "Pour modifier vos informations, allez dans \"Mon Profil\" puis cliquez sur \"Modifier.\"",
    ),
    FaqItem(
      question: "Comment changer mon mot de passe ?",
      answer: "Allez dans les paramètres de sécurité, entrez votre ancien mot de passe, puis votre nouveau mot de passe deux fois pour confirmer.",
    ),
    FaqItem(
      question: "Comment ajouter une photo de profil ?",
      answer: "Sur votre page de profil, appuyez sur l'icône de l'appareil photo ou du crayon sur votre photo actuelle pour télécharger une nouvelle image.",
    ),
    FaqItem(
      question: "Comment modifier mes informations de contact ?",
      answer: "Vous pouvez mettre à jour votre adresse e-mail ou votre numéro de téléphone directement dans la section \"Informations Personnelles\" de votre profil.",
    ),
    FaqItem(
      question: "Comment supprimer mon compte ?",
      answer: "La suppression de compte est permanente. Vous devez contacter le support via le bouton \"Envoyer l'avis\" en bas de page pour initier la procédure de suppression.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Mon Compte & Profil',
        onBack: () => Navigator.of(context).pop(),
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
        
        // --- ANCIEN: Suppression de l'ancienne méthode tileTheme
        // tileTheme: ExpansionTileTheme.of(context).copyWith(
        //   dividerColor: Colors.transparent, 
        // ),

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
          ),
        ],
      ),
    );
  }
}
