// Fichier : lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import '../login_screen.dart';
import 'home_jeune.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../services/auth_service.dart';
import '../../models/jeune_registration.dart';
import '../../config/api_config.dart';

// --- COULEURS CONSTANTES ----
const Color primaryGreen = Color(0xFF10B981);      
const Color headerGradientEndBlue = Color(0xFF2563EB); 
const Color backgroundColor = Colors.white; 
const Color inputFieldBorderColor = Color(0xFFE0E0E0); 
const double fieldBorderRadius = 30.0; 

// --- CHEMINS DES IMAGES (PNG) ---
const String headerImagePath = 'assets/images/header.png'; 
const String footerImagePath = 'assets/images/footer.png'; 
// ------------------------------------

class RegisterJeune extends StatelessWidget {
  const RegisterJeune({super.key});

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
  // Contrôleurs pour les champs du formulaire
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // États
  String? _selectedGenre;
  bool _isSubmitting = false;
  final _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Helper pour l'ombre et les coins arrondis
  Widget _buildInputShadow(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(fieldBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // Style des champs de texte SANS BORDURE (géré par le conteneur)
  InputDecoration _inputDecoration(String hint, {IconData? suffixIcon, VoidCallback? suffixOnTap}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
      fillColor: Colors.transparent,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
      
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      suffixIcon: suffixIcon != null
          ? GestureDetector(
              onTap: suffixOnTap,
              child: Icon(suffixIcon, color: headerGradientEndBlue, size: 20),
            )
          : null,
    );
  }

  /// Gère la soumission du formulaire
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = JeuneRegistrationRequest(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        genre: _selectedGenre!,
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        telephone: _telephoneController.text.trim(),
        motDePasse: _passwordController.text,
        confirmationMotDePasse: _confirmPasswordController.text,
      );

      // Debug: Afficher les données envoyées
      print('📤 Envoi inscription jeune: ${request.toJson()}');
      print('🔗 URL: ${ApiConfig.baseUrl}${ApiConfig.registerJeune}');

      final response = await _authService.registerJeune(request);

      // Debug: Afficher la réponse
      print('📥 Réponse reçue - Status: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Succès : Navigation vers la page d'accueil
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeJeuneScreen(),
          ),
        );
      } else {
        // Erreur : Afficher le message d'erreur et rester sur la page
        String errorMessage = 'Inscription échouée (Code: ${response.statusCode})';
        try {
          if (response.body.isNotEmpty) {
            final jsonResponse = jsonDecode(response.body);
            if (jsonResponse is Map<String, dynamic>) {
              // Tentative d'extraire le message d'erreur du backend
              if (jsonResponse.containsKey('message')) {
                errorMessage = jsonResponse['message'].toString();
              } else if (jsonResponse.containsKey('error')) {
                errorMessage = jsonResponse['error'].toString();
              } else {
                errorMessage = 'Erreur: ${response.body}';
              }
            } else {
              errorMessage = response.body;
            }
          }
        } catch (e) {
          // Si le parsing JSON échoue, utiliser le body brut
          if (response.body.isNotEmpty) {
            errorMessage = 'Erreur: ${response.body}';
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      // Erreur réseau ou autre exception
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de connexion: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> genres = ['MASCULIN', 'FEMININ'];
    
    // Liste pour stocker tous les widgets du formulaire
    List<Widget> formWidgets = [
      // Nom et Prénom 
      Row(
        children: <Widget>[
          Expanded(
            child: _buildInputShadow(
              TextFormField(
                controller: _nomController,
                decoration: _inputDecoration('Nom'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(width: 8), 
          Expanded(
            child: _buildInputShadow(
              TextFormField(
                controller: _prenomController,
                decoration: _inputDecoration('Prenom'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Le prénom est requis';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 15), 
      
      // Champ Genre
      _buildInputShadow(
        DropdownButtonFormField<String>(
          decoration: _inputDecoration('Genre'),
          isExpanded: true,
          value: _selectedGenre, 
          items: genres.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(child: Text(value), value: value);
          }).toList(),
          validator: (value) {
            if (value == null) {
              return 'Le genre est requis';
            }
            return null;
          },
          onChanged: (String? newValue) {
            setState(() {
              _selectedGenre = newValue;
            });
          },
        ),
      ),
      const SizedBox(height: 15), 
      
      _buildInputShadow(
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDecoration('Email (facultatif)'),
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              // Validation basique de l'email
              if (!value.contains('@') || !value.contains('.')) {
                return 'Email invalide';
              }
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 15), 
      _buildInputShadow(
        TextFormField(
          controller: _telephoneController,
          keyboardType: TextInputType.phone,
          decoration: _inputDecoration('Telephone'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Le téléphone est requis';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 15), 
      
      // Champ Rôle supprimé (sélectionné désormais via splash_screen_role)
      const SizedBox(height: 15), 
    ];
    // Aucun champ conditionnel requis pour Jeune

    // Ajout des champs communs de fin (Mot de passe, Confirmer Mot de passe, Bouton)
    formWidgets.addAll([
      _buildInputShadow(
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: _inputDecoration(
            'Mot de Passe',
            suffixIcon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            suffixOnTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Le mot de passe est requis';
            }
            if (value.length < 6) {
              return 'Le mot de passe doit contenir au moins 6 caractères';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 15), 
      _buildInputShadow(
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: !_isConfirmPasswordVisible,
          decoration: _inputDecoration(
            'Confirmez Mot de Passe',
            suffixIcon: _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            suffixOnTap: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Veuillez confirmer le mot de passe';
            }
            if (value != _passwordController.text) {
              return 'Les mots de passe ne correspondent pas';
            }
            return null;
          },
        ),
      ),
      const SizedBox(height: 25), 
      
      // Bouton S'inscrire
      ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), 
          ),
          minimumSize: const Size(double.infinity, 50), 
          elevation: 5,
          shadowColor: primaryGreen.withOpacity(0.5),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
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
          child: Form(
            key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: formWidgets, // Utilisez la liste dynamique ici
            ),
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
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Text(
          'Vous avez un compte ? ', 
            style: const TextStyle(
            color: Colors.black54,
            fontSize: reducedFontSize, 
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(
          child: GestureDetector(
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
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}