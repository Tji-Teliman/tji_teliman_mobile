import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'contacter_nous.dart';

class FaqProblemeTechnique extends StatelessWidget {
  const FaqProblemeTechnique({super.key});

  @override
  Widget build(BuildContext context) {
    return const FaqTechnicalScreen();
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

class FaqTechnicalScreen extends StatelessWidget {
  const FaqTechnicalScreen({super.key});

  // Données spécifiques à la FAQ Problèmes Techniques
  final List<FaqItem> faqItems = const [
    FaqItem(
      question: "L'application plante, que faire ?",
      answer: "Si l'application plante, essayez de la redémarrer. Si le problème persiste, vérifiez si des mises à jour sont disponibles ou contactez directement le support technique.",
    ),
    FaqItem(
      question: "Le bouton 'Envoyer' ne fonctionne pas.",
      answer: "Assurez-vous d'avoir rempli tous les champs obligatoires du formulaire (ils sont souvent marqués d'un astérisque *). Si ce problème persiste, redémarrez l'application et réessayez.",
    ),
    FaqItem(
      question: "Je ne reçois pas les notifications.",
      answer: "Vérifiez les paramètres de notification de votre téléphone pour l'application. Assurez-vous également que votre mode 'Ne pas déranger' est désactivé.",
    ),
    FaqItem(
      question: "L'application est lente.",
      answer: "Vérifiez votre connexion internet (Wi-Fi ou données mobiles). Si la connexion est bonne, essayez de vider le cache de l'application via les paramètres de votre téléphone.",
    ),
    FaqItem(
      question: "Je vois un écran blanc (ou une erreur 404).",
      answer: "Cela est généralement un problème temporaire de connexion. Fermez l'application, vérifiez votre réseau, et réouvrez-la. Si l'erreur persiste, contactez le support.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Problèmes Techniques',
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
