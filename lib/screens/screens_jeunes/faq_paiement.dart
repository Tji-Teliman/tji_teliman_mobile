import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';

class FaqPaiement extends StatelessWidget {
  const FaqPaiement({super.key});

  @override
  Widget build(BuildContext context) {
    return const FaqPaymentsScreen();
  }
}

// Définition des couleurs personnalisées
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App et boutons
const Color lightBlueButton = Color(0xFFE3F2FD); // Couleur de fond pour les cartes

// Modèle pour les questions/réponses FAQ (Réutilisé du fichier précédent)
class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

class FaqPaymentsScreen extends StatelessWidget {
  const FaqPaymentsScreen({super.key});

  // Données spécifiques à la FAQ Paiements
  final List<FaqItem> faqItems = const [
    FaqItem(
      question: "Mon paiement est en attente, que faire ?",
      answer: "Un paiement peut être en attente pour plusieurs raisons :\n• Validation par le recruteur : Le recruteur doit d'abord confirmer que la mission est terminée et validée.\n• Délai de traitement Mobile Money : Bien que généralement instantané, il peut y avoir un léger délai du côté de votre opérateur.\nSi le paiement reste en attente au-delà de 24 heures après la validation de la mission, veuillez utiliser le bouton \"Nous Contacter\" ci-dessous pour que notre équipe vérifie l'état de la transaction.",
    ),
    FaqItem(
      question: "Puis-je changer mon numéro Mobile Money ?",
      answer: "Oui, vous pouvez le mettre à jour à tout moment dans Paramètres > Moyen de paiement. Cliquez sur votre numéro actuel pour le modifier ou en ajouter un nouveau. Pour votre sécurité, une confirmation par mot de passe ou code SMS vous sera demandée avant de valider le changement.",
    ),
    FaqItem(
      question: "Quels sont les frais de transaction ?",
      answer: "Les frais de transaction varient selon l'opérateur Mobile Money et le montant retiré. Une estimation claire des frais sera affichée avant la validation finale de votre retrait.",
    ),
    FaqItem(
      question: "Comment contester un paiement incorrect ?",
      answer: "Si vous constatez une erreur de paiement, veuillez signaler un litige via la section Litiges de l'application ou utilisez le bouton \"Envoyer l'avis\" pour contacter notre support client directement.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Paiements & Mobile Money',
        onBack: () => Navigator.of(context).pop(),
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
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 20.0), // Padding pour laisser l'espace à la barre de recherche
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

                        // --- Liste des questions/réponses FAQ ---
                        // Enveloppé dans un Theme pour supprimer les séparateurs de l'ExpansionTile
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent, // Méthode pour enlever la ligne de séparation
                          ),
                          child: Column(
                            children: faqItems.map((item) {
                              return FaqExpansionTile(faqItem: item);
                            }).toList(),
                          ),
                        ),
                        
                        const SizedBox(height: 100), // Espace pour le bouton en bas
                      ],
                    ),
                  ),

                  // --- Barre de Recherche (positionnée en haut) ---
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white, // Fond blanc
                        borderRadius: BorderRadius.circular(10.0), // Coins arrondis
                        border: Border.all(color: Colors.grey.shade300, width: 1.5), // Bordure légère
                        boxShadow: [ // Ombre pour l'effet "joli"
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Recherche',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          // Suppression du trait/bordure lors du focus
                          border: InputBorder.none, 
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 15),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // --- Bouton en bas de l'écran (Sticky Footer) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
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
                // Centrage et réduction de la largeur du bouton
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75, // Réduit à 75% de la largeur de l'écran
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Ouverture du formulaire pour Envoyer l'avis"))
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
        ],
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
