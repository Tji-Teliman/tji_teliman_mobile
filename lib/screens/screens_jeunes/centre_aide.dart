import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'faq_compte_profil.dart';
import 'faq_paiement.dart';
import 'postuler_et_candidature.dart';
import 'faq_probleme_technique.dart';
import 'faq_security.dart';
import 'contacter_nous.dart';
import 'conditions_generales.dart';
import 'home_jeune.dart';


class CentreAide extends StatelessWidget {
  const CentreAide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportCenterScreen();
  }
}

// Définition des couleurs personnalisées (utilisées sur les autres écrans)
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App et boutons
const Color lightBlueButton = Color(0xFFE3F2FD); // Couleur de fond pour les cartes
const Color customOrange = Color(0xFFF59E0B); // Couleur Orange

// Modèle pour les catégories d'aide
class SupportCategory {
  final String title;
  final IconData icon;

  const SupportCategory({required this.title, required this.icon});
}

class SupportCenterScreen extends StatelessWidget {
  const SupportCenterScreen({super.key});

  final List<SupportCategory> categories = const [
    SupportCategory(title: "Mon Compte & Profil", icon: Icons.person_outline),
    SupportCategory(title: "Paiements & Mobile Money", icon: Icons.account_balance_wallet_outlined),
    SupportCategory(title: "Postuler et candidature", icon: Icons.assignment_outlined),
    SupportCategory(title: "Problèmes Techniques", icon: Icons.warning_amber_outlined),
    SupportCategory(title: "Sécurité et Confidentialité", icon: Icons.security_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Centre d\'Aide / Support',
        onBack: () {
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (ctx) => const HomeJeuneScreen()),
            );
          }
        },
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Titre Catégories ---
            const Text(
              'Catégories',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            // --- Grille de Catégories ---
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return AnimatedCategoryCard(category: categories[index]);
              },
            ),
            const SizedBox(height: 40),
            // --- Section Contact ---
            const Text(
              'Vous n\'avez pas trouvé de réponse ?',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            // Bouton Nous Contacter
            ElevatedButton(
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
                'Nous Contacter',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            // Lien Conditions Générales
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ConditionsGenerales()),
                  );
                },
                child: Text(
                  'Voir les conditions Générales',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Widget pour une carte de catégorie AVEC ANIMATION
class AnimatedCategoryCard extends StatefulWidget {
  final SupportCategory category;

  const AnimatedCategoryCard({super.key, required this.category});

  @override
  State<AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<AnimatedCategoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _controller.forward();
  }

  void _onTapUp(_) {
    _controller.reverse();
    // Navigation selon la catégorie
    final title = widget.category.title.toLowerCase();
    if (title.contains('compte')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FaqCompteProfil()),
      );
      return;
    }
    if (title.contains('paiement')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FaqPaiement()),
      );
      return;
    }
    if (title.contains('postuler') || title.contains('candidature')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PostulerEtCandidature()),
      );
      return;
    }
    if (title.contains('technique')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FaqProblemeTechnique()),
      );
      return;
    }
    if (title.contains('sécurité') || title.contains('securite')) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FaqSecurity()),
      );
      return;
    }
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Icône dans un cercle bleu clair
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: lightBlueButton, // Couleur de fond lightBlueButton
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.category.icon,
                  color: customBlue,
                  size: 30,
                ),
              ),
              const SizedBox(height: 10),
              // Titre de la catégorie
              Text(
                widget.category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
