import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importation des widgets réutilisables
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'home_jeune.dart';
import 'message_conversation.dart';

// --- COULEURS ET CONSTANTES ---
const Color primaryBlue = Color(0xFF2563EB); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFF5F5F5); 

class MotivationScreen extends StatefulWidget {
  // Le titre de la mission est passé en argument pour l'affichage dans le header
  final String missionTitle;
  
  const MotivationScreen({super.key, required this.missionTitle});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final TextEditingController _motivationController = TextEditingController();
  static const int maxCharacters = 200;
  int _charCount = 0;
  
  // L'index de la barre de navigation est fixé à 0 (Accueil).
  final int _selectedIndex = 0; 

  @override
  void initState() {
    super.initState();
    // Écoute les changements dans le champ de texte
    _motivationController.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _motivationController.text.length;
    });
  }

  void _submitApplication() {
    // ⚠️ Logique de soumission de candidature à implémenter ici
    // La motivation (_motivationController.text) peut être vide.
    
    // Exemple de feedback simple pour l'utilisateur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Candidature soumise pour : ${widget.missionTitle}. Motivation: ${_charCount > 0 ? 'Oui' : 'Non'}", 
          style: GoogleFonts.poppins()
        ),
        backgroundColor: primaryBlue,
      ),
    );
    // Retour à la page précédente après la soumission
    // Navigator.of(context).pop(); 
  }

  @override
  void dispose() {
    _motivationController.removeListener(_updateCharCount);
    _motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerTitle = 'Postuler pour ${widget.missionTitle}';
    
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      
      // 1. HEADER personnalisé avec CustomHeader
      appBar: CustomHeader(
        // Le titre prend le nom de la mission
        title: headerTitle,
        // OnBack géré par défaut dans CustomHeader (pop)
        onBack: () => Navigator.of(context).pop(), 
      ),
      
      // 2. CORPS de la Page
      // Rétablissement de l'alignement par défaut (non centré)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // Retire mainAxisAlignment.center pour un alignement haut par défaut
          children: <Widget>[
            
            // Carte pour la zone de motivation (conforme à la maquette)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bloc de titre bleu clair
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3F2FD), // Un bleu très clair pour le bloc titre
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Pourquoi cette mission vous intéresse ? (Motivation)',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkGrey,
                      ),
                    ),
                  ),
                  
                  // Champ de texte
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          controller: _motivationController,
                          maxLength: maxCharacters,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Décrivez vos motivation et compétences pour cette mission ....',
                            hintStyle: GoogleFonts.poppins(color: darkGrey.withOpacity(0.6)),
                            border: InputBorder.none, 
                            counterText: '', // On masque le compteur par défaut
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                        ),
                        
                        // Compteur de caractères personnalisé (comme dans la maquette)
                        Text(
                          '$_charCount/$maxCharacters',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: _charCount > maxCharacters ? Colors.red : darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Bouton de Soumission de Candidature
            ElevatedButton(
              // La candidature n'est plus obligatoire. 
              // On désactive seulement si le texte est trop long (> maxCharacters).
              onPressed: _charCount <= maxCharacters 
                  ? _submitApplication
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'SOUMETTRE LA CANDIDATURE',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
      
      // 3. FOOTER : Barre de Navigation Personnalisée
      bottomNavigationBar: CustomBottomNavBar(
        // Utilise l'index 0 (Accueil)
        initialIndex: _selectedIndex,
        onItemSelected: (index) {
          if (index == 0) {
            // Aller vers Accueil
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeJeuneScreen()),
            );
            return;
          }
          if (index == 3) {
            // Aller vers Discussions
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MessageConversationScreen()),
            );
            return;
          }
          // Autres onglets: à implémenter si nécessaire
        },
      ),
    );
  }
}
