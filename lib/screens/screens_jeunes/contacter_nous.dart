import 'package:flutter/material.dart';


class ContacterNous extends StatelessWidget {
  const ContacterNous({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nous Contacter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ContactUsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Définition des couleurs personnalisées
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App et boutons
const Color customOrange = Color(0xFFF59E0B); // Couleur Orange

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customBlue, // Fond bleu de l'App Bar
      appBar: AppBar(
        backgroundColor: customBlue,
        elevation: 0,
        leading: IconButton(
          // Utilisation de la flèche de retour courbée (iOS style)
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            // Logique de retour
          },
        ),
        title: const Text(
          'Nous Contacter',
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    
                    // --- Champ Votre Nom ---
                    const CustomTextField(hintText: 'Votre Nom'),
                    const SizedBox(height: 15),

                    // --- Champ Votre Adresse E-mail ---
                    const CustomTextField(hintText: 'Votre Adresse E-mail'),
                    const SizedBox(height: 15),

                    // --- Champ Sujet ---
                    const CustomTextField(hintText: 'Sujet'),
                    const SizedBox(height: 15),

                    // --- Champ Votre Message (Multi-lignes) ---
                    Container(
                      height: 150, // Hauteur plus grande pour le message
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300, width: 1.5),
                      ),
                      child: const TextField(
                        maxLines: null, // Permet plusieurs lignes
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Votre Message',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12.0),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // --- Bouton Envoyer ---
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Formulaire de contact envoyé !"))
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customBlue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Envoyer',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 20),
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

// Widget pour les champs de texte simples
class CustomTextField extends StatelessWidget {
  final String hintText;

  const CustomTextField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
