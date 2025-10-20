// Fichier : lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// --- COULEURS CONSTANTES ---
const Color primaryGreen = Color(0xFF10B981);      
const Color headerGradientEndBlue = Color(0xFF2563EB); 
const Color backgroundColor = Colors.white; 
const Color inputFieldBorderColor = Color(0xFFE0E0E0); 
const double fieldBorderRadius = 15.0; 

// --- CHEMINS DES IMAGES (PNG) ---
const String headerImagePath = 'assets/images/header.png'; 
const String footerImagePath = 'assets/images/footer.png'; 
// ------------------------------------

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // Hauteurs fixes pour les images de fond
    const double headerHeight = 250.0;
    const double footerHeight = 90.0; 

    // Point de départ du contenu central (Titre + Formulaire)
    const double contentTopPosition = headerHeight - 40; 
    
    // Hauteur de la zone centrale contrainte par les images fixes
    final double contentAreaHeight = screenHeight - contentTopPosition - footerHeight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          // 1. L'en-tête (Header) : Image de fond PNG (Fixe)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BackgroundImageHeader(
              height: headerHeight,
              imagePath: headerImagePath,
            ),
          ),

          // 2. Le pied de page (Footer) : Image de fond PNG (Fixe)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BackgroundImageFooter(
              height: footerHeight,
              imagePath: footerImagePath,
            ),
          ),

          // 3. Le contenu central (Titre FIXE + Formulaire DÉFILABLE)
          Positioned(
            top: contentTopPosition, 
            left: 0,
            right: 0,
            child: SizedBox(
              height: contentAreaHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: <Widget>[
                    // Titre "Créer mon Compte" (FIXE)
                    Text( 
                      'Créer mon Compte',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Le reste du contenu (Formulaire + Lien) est DÉFILABLE
                    Expanded(
                      child: SingleChildScrollView( 
                        child: Column(
                          children: const <Widget>[
                            // FORMULAIRE D'INSCRIPTION 
                            RegistrationForm(),
                            
                            // Espace final
                            SizedBox(height: 20), 
                          ],
                        ),
                      ),
                    ),
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

// -----------------------------------------------------------------------------
// --- WIDGETS BASÉS SUR LES IMAGES (PNG) ---
// -----------------------------------------------------------------------------

class BackgroundImageHeader extends StatelessWidget {
  final double height;
  final String imagePath;
  const BackgroundImageHeader({required this.height, required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover, 
        alignment: Alignment.topCenter,
        filterQuality: FilterQuality.high, 
      ),
    );
  }
}

class BackgroundImageFooter extends StatelessWidget {
  final double height;
  final String imagePath;
  const BackgroundImageFooter({required this.height, required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover, 
        alignment: Alignment.bottomCenter,
        filterQuality: FilterQuality.high, 
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// --- WIDGET DU FORMULAIRE D'INSCRIPTION (STATEFUL AVEC LOGIQUE CORRIGÉE) ---
// -----------------------------------------------------------------------------

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  // VARIABLES D'ÉTAT POUR LES CHAMPS CONDITIONNELS
  String? _selectedRole;
  String? _selectedRecruiterType; // Pour ENTREPRISE ou PARTICULIER

  // Style des champs de texte AVEC BORDURE
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0), 
      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldBorderRadius), 
        borderSide: const BorderSide(color: inputFieldBorderColor, width: 1), 
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldBorderRadius), 
        borderSide: const BorderSide(color: inputFieldBorderColor, width: 1), 
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldBorderRadius), 
        borderSide: const BorderSide(color: primaryGreen, width: 2), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> roles = ['JEUNE_PRESTATEUR', 'RECRUTEUR'];
    final List<String> genres = ['MASCULIN', 'FÉMININ'];
    final List<String> recruiterTypes = ['ENTREPRISE', 'PARTICULIER'];
    
    // Liste pour stocker tous les widgets du formulaire
    List<Widget> formWidgets = [
      // Nom et Prénom 
      Row(
        children: <Widget>[
          Expanded(child: TextFormField(decoration: _inputDecoration('Nom'))),
          const SizedBox(width: 8), 
          Expanded(child: TextFormField(decoration: _inputDecoration('Prenom'))),
        ],
      ),
      const SizedBox(height: 15), 
      
      // Champ Genre
      DropdownButtonFormField<String>(
        decoration: _inputDecoration('Genre'),
        isExpanded: true,
        value: null, 
        items: genres.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(child: Text(value), value: value);
        }).toList(),
        onChanged: (String? newValue) {},
      ),
      const SizedBox(height: 15), 
      
      TextFormField(keyboardType: TextInputType.emailAddress, decoration: _inputDecoration('Email (facultatif)')),
      const SizedBox(height: 15), 
      TextFormField(keyboardType: TextInputType.phone, decoration: _inputDecoration('Telephone')),
      const SizedBox(height: 15), 
      
      // Rôle (Dropdown) - CLÉ POUR LA LOGIQUE CONDITIONNELLE
      DropdownButtonFormField<String>(
        decoration: _inputDecoration('Role'),
        isExpanded: true,
        value: _selectedRole, 
        items: roles.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(child: Text(value), value: value);
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedRole = newValue;
            // Réinitialise le type de recruteur si le rôle change et n'est pas "RECRUTEUR"
            if (newValue != 'RECRUTEUR') {
              _selectedRecruiterType = null;
            }
          });
        },
      ),
      const SizedBox(height: 15), 
    ];

    // --- LOGIQUE CONDITIONNELLE CORRIGÉE ---
    // Si le RÔLE est RECRUTEUR, afficher le champ 'Type de Recruteur'
    if (_selectedRole == 'RECRUTEUR') {
      formWidgets.addAll([
        // Type de Recruteur (Dropdown)
        DropdownButtonFormField<String>(
          decoration: _inputDecoration('Type de Recruteur'),
          isExpanded: true,
          value: _selectedRecruiterType, 
          items: recruiterTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(child: Text(value), value: value);
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedRecruiterType = newValue;
            });
          },
        ),
        const SizedBox(height: 15), 
      ]);
    }

    // Si le rôle est JEUNE_PRESTATEUR, AUCUN champ supplémentaire n'est ajouté (la liste `formWidgets` continue normalement).
    
    // -------------------------------------

    // Ajout des champs communs de fin (Mot de passe, Confirmer Mot de passe, Bouton)
    formWidgets.addAll([
      TextFormField(obscureText: true, decoration: _inputDecoration('Mot de Passe')),
      const SizedBox(height: 15), 
      TextFormField(obscureText: true, decoration: _inputDecoration('Confirmez Mot de Passe')),
      const SizedBox(height: 25), 
      
      // Bouton S'inscrire
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), 
          ),
          minimumSize: const Size(double.infinity, 50), 
          elevation: 5,
          shadowColor: primaryGreen.withOpacity(0.5),
        ),
        child: Text(
          "S'inscrire",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ]);


    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(25.0), 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0), 
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1), 
                blurRadius: 20,                       
                offset: Offset(0, 8),                 
              ),
            ],
          ),
          // Utilisation de la liste des widgets construite conditionnellement
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: formWidgets, // Utilisez la liste dynamique ici
          ),
        ),
        
        // Lien de connexion (scrolable)
        const SizedBox(height: 20), 
        const LoginLink(),
      ],
    );
  }
}

// --- 5. Lien de Connexion (vers LoginScreen) ---
class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    const double reducedFontSize = 13.0; 
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Vous avez un compte ? ', 
          style: TextStyle(
            color: Colors.black54,
            fontSize: reducedFontSize, 
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Text(
            'Connectez-vous ici',
            style: GoogleFonts.poppins(
              color: headerGradientEndBlue, 
              fontWeight: FontWeight.bold,
              fontSize: reducedFontSize, 
            ),
          ),
        ),
      ],
    );
  }
}