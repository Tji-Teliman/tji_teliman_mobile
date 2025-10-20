import 'package:flutter/material.dart';

// --- COULEURS CONSTANTES ---
const Color primaryGreen = Color(0xFF10B981);      
const Color headerGradientEndBlue = Color(0xFF2563EB); 
const Color backgroundColor = Colors.white; 
const Color inputFieldBorderColor = Color(0xFFE0E0E0); // Gris clair pour les bordures de champs

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

    // Point de départ du contenu défilable, ajusté pour l'alignement visuel
    const double scrollableContentTop = headerHeight - 40; 
    
    // Hauteur de la zone centrale défilable, contrainte par les images fixes
    final double scrollableAreaHeight = screenHeight - scrollableContentTop - footerHeight;

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

          // 3. Le contenu central (Titre et Formulaire) - DÉFILABLE
          Positioned(
            top: scrollableContentTop, 
            left: 0,
            right: 0,
            child: SizedBox(
              height: scrollableAreaHeight,
              child: SingleChildScrollView( 
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: <Widget>[
                    // Titre "Créer mon Compte"
                    const Text(
                      'Créer mon Compte',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // FORMULAIRE D'INSCRIPTION (Cadre blanc avec coins et ombre)
                    const RegistrationForm(),
                    
                    // Espace final pour s'assurer que le formulaire ne colle pas au footer
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
// --- WIDGET DU FORMULAIRE (BORDURES ET PADDING AUGMENTÉS) ---
// -----------------------------------------------------------------------------

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({super.key});

  // Style des champs de texte AVEC BORDURE
  InputDecoration _inputDecoration(String hint) {
    // NOUVEAU: Rayon des bordures des champs augmenté à 15.0
    const double fieldBorderRadius = 15.0; 
    
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      fillColor: Colors.white,
      filled: true,
      // Hauteur interne des champs légèrement augmentée (12.0)
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0), 
      
      // BORDURES ARRONDIS (15.0)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldBorderRadius), 
        borderSide: const BorderSide(color: inputFieldBorderColor, width: 1), // Bordure gris clair
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldBorderRadius), 
        borderSide: const BorderSide(color: inputFieldBorderColor, width: 1), // Bordure gris clair
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldBorderRadius), 
        borderSide: const BorderSide(color: primaryGreen, width: 2), // Bordure verte au focus
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> roles = ['JEUNE_PRESTATEUR', 'RECRUTEUR'];

    return Container(
      // NOUVEAU: Padding du conteneur blanc augmenté à 25.0 (augmente la hauteur)
      padding: const EdgeInsets.all(25.0), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0), // Coins arrondis du cadre principal
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
        children: <Widget>[
          // Nom et Prénom 
          Row(
            children: <Widget>[
              Expanded(child: TextFormField(decoration: _inputDecoration('Nom'))),
              const SizedBox(width: 8), 
              Expanded(child: TextFormField(decoration: _inputDecoration('Prenom'))),
            ],
          ),
          const SizedBox(height: 15), 
          
          TextFormField(decoration: _inputDecoration('Genre')),
          const SizedBox(height: 15), 
          TextFormField(keyboardType: TextInputType.emailAddress, decoration: _inputDecoration('Email (facultatif)')),
          const SizedBox(height: 15), 
          TextFormField(keyboardType: TextInputType.phone, decoration: _inputDecoration('Telephone')),
          const SizedBox(height: 15), 
          
          // Rôle (Dropdown)
          DropdownButtonFormField<String>(
            decoration: _inputDecoration('Role'),
            isExpanded: true,
            value: null, 
            items: roles.map<DropdownMenuItem<String>>((String value) {
              // Le style du texte dans le Dropdown doit correspondre
              return DropdownMenuItem<String>(child: Text(value), value: value);
            }).toList(),
            onChanged: (String? newValue) {},
          ),
          const SizedBox(height: 15), 
          
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
                borderRadius: BorderRadius.circular(10.0),
              ),
              minimumSize: const Size(double.infinity, 50), 
              elevation: 5,
              shadowColor: primaryGreen.withOpacity(0.5),
            ),
            child: const Text(
              "S'inscrire",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          
          const SizedBox(height: 20), 
          const LoginLink(), 
        ],
      ),
    );
  }
}

// --- 5. Lien de Connexion ---
class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    // Taille de police réduite à 13.0
    const double reducedFontSize = 13.0; 
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Vous avez un compte ? ', 
          style: TextStyle(
            color: Colors.black54,
            fontSize: reducedFontSize, // Taille réduite
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Connectez-vous ici',
            style: TextStyle(
              color: headerGradientEndBlue, 
              fontWeight: FontWeight.bold,
              fontSize: reducedFontSize, // Taille réduite
            ),
          ),
        ),
      ],
    );
  }
}