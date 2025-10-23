import 'package:flutter/material.dart';


class FaqSecurity extends StatelessWidget {
  const FaqSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FAQ Sécurité & Confidentialité',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const FaqSecurityScreen(),
      debugShowCheckedModeBanner: false,
    );
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
      backgroundColor: customBlue,
      appBar: AppBar(
        backgroundColor: customBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            // Logique de retour
          },
        ),
        title: const Text(
          'Sécurité & Confidentialité',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
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
