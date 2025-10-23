// Fichier : lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'register_screen.dart'; 
import 'package:google_fonts/google_fonts.dart';

// --- COULEURS CONSTANTES (Réutilisées de RegisterScreen) ---
const Color primaryGreen = Color(0xFF10B981);      
const Color headerGradientEndBlue = Color(0xFF2563EB); 
const Color backgroundColor = Colors.white; 
const Color inputFieldBorderColor = Color(0xFFE0E0E0); 
const Color iconColorOrange = Color(0xFFF59E0B); 
const double fieldBorderRadius = 15.0; 
const double buttonBorderRadius = 15.0; 

// --- CHEMINS DES IMAGES (PNG) ---
const String headerImagePath = 'assets/images/header.png'; 
// NOUVEAU: Ajout du chemin pour le footer
const String footerImagePath = 'assets/images/footer.png'; 
// ------------------------------------

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // Hauteur fixe pour l'image de fond
    const double headerHeight = 250.0; 
    // NOUVEAU: Hauteur fixe pour l'image du footer (90.0 comme dans register_screen)
    const double footerHeight = 90.0; 

    // Position de départ du contenu : commence juste à la fin du header
    const double contentTopPosition = headerHeight; 
    
    // MODIFIÉ: Hauteur de la zone centrale ajustée pour s'arrêter avant le footer
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

          // NOUVEAU: 2. Le pied de page (Footer) : Image de fond PNG (Fixe)
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
              // Hauteur de la zone centrale MODIFIÉE
              height: contentAreaHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView( 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: <Widget>[
                      
                      // Espace pour pousser le titre/formulaire sous l'image
                      const SizedBox(height: 10), // Ajusté de 10 à 50 pour une meilleure visibilité du formulaire
                      
                      // Titre "AW BISSIMILAH !" 
                       Text(
                        'AW BISSIMILAH !',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // FORMULAIRE DE CONNEXION (Cadre blanc)
                      const LoginForm(),
                      
                      // IMPORTANT : S'assurer qu'il y a assez d'espace pour que le SingleChildScrollView
                      // puisse descendre complètement sans être coupé par le footer.
                    //   const SizedBox(height: 50), 
                    ],
                  ),
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

// NOUVEAU: Ajout du widget BackgroundImageFooter
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
// --- WIDGET DU FORMULAIRE DE CONNEXION ---
// -----------------------------------------------------------------------------

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordVisible = false;

  InputDecoration _inputDecoration(String hint, {IconData? prefixIcon, IconData? suffixIcon, Function? suffixOnTap}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0), 
      
      prefixIcon: prefixIcon != null 
          ? Icon(prefixIcon, color: iconColorOrange, size: 20) 
          : null,
          
      suffixIcon: suffixIcon != null
          ? GestureDetector(
              onTap: () { if (suffixOnTap != null) suffixOnTap(); },
              child: Icon(suffixIcon, color: iconColorOrange, size: 20),
            )
          : null,
      
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
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Champ Téléphone
          TextFormField(
            keyboardType: TextInputType.phone, 
            decoration: _inputDecoration(
              '90-00-00-00', 
              prefixIcon: Icons.phone_android,
            ),
          ),
          const SizedBox(height: 15), 
          
          // Champ Mot de Passe
          TextFormField(
            obscureText: !_isPasswordVisible, 
            decoration: _inputDecoration(
              '••••••••••', 
              prefixIcon: Icons.lock,
              suffixIcon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              suffixOnTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }
            ),
          ),
          const SizedBox(height: 10), 
          
          // Lien Mot de passe oublié ?
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'Mot de passe oublié ?',
                style: TextStyle(
                  color: headerGradientEndBlue, 
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0, 
                ),
              ),
            ),
          ),
          const SizedBox(height: 25), 
          
          // Bouton Se Connecter
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(buttonBorderRadius), 
              ),
              minimumSize: const Size(double.infinity, 50), 
              elevation: 5,
              shadowColor: primaryGreen.withOpacity(0.5),
            ),
            child:  Text(
              "Se connecter",
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          
          const SizedBox(height: 20), 
          
          // Lien Créer un compte (Police augmentée à 15.0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Nouveau ici ? ', 
                style: TextStyle(color: Colors.black54, fontSize: 15.0),
              ),
              GestureDetector(
                onTap: () {
                  // Renvoie vers la page d'inscription
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child:  Text(
                  'Créer un compte',
                style: GoogleFonts.poppins(
              color: headerGradientEndBlue, 
              fontWeight: FontWeight.bold,
              fontSize: 14.0, 
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}