import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';

// Définition des couleurs personnalisées
const Color customBlue = Color(0xFF2563EB); // Couleur principale de la barre d'App et boutons
const Color customGreen = Color(0xFF10B981); // Vert pour le succès et l'enregistrement
const Color customRed = Color(0xFFEF4444); // Rouge pour les messages d'erreur
const Color customGrey = Color(0xFFE5E7EB); // Gris clair pour le fond de carte/contour

class ParametreChangeMdp extends StatelessWidget {
  const ParametreChangeMdp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChangePasswordScreen();
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  // Clé pour gérer l'état du formulaire
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les champs de texte
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // États pour l'affichage/masquage du mot de passe
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // État pour afficher l'erreur de non-concordance
  bool _passwordsDoNotMatch = false;

  // Expression régulière pour la validation (8+ chars, Majuscule, Chiffre, Spécial)
  final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$');
  
  // État de la validation du nouveau mot de passe
  String _newPassword = '';


  @override
  void initState() {
    super.initState();
    // Écouter les changements du nouveau mot de passe pour la validation en temps réel
    _newPasswordController.addListener(_onNewPasswordChange);
  }

  void _onNewPasswordChange() {
    setState(() {
      _newPassword = _newPasswordController.text;
    });
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_onNewPasswordChange);
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fonction de validation du mot de passe (règles de sécurité)
  // Cette fonction est utilisée uniquement pour la validation finale du formulaire
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez créer un mot de passe.';
    }
    if (!passwordRegExp.hasMatch(value)) {
      // Retourne null si l'erreur doit être gérée par le widget PasswordRuleIndicator
      return null; 
    }
    return null;
  }

  // Fonction pour gérer la soumission
  void _submitForm() {
    // Réinitialiser l'erreur de non-concordance
    setState(() {
        _passwordsDoNotMatch = false;
    });
    
    // 1. Valider le formulaire
    bool formIsValid = _formKey.currentState!.validate();

    // 2. Vérifier la complexité (car _validatePassword retourne null si l'erreur est gérée par le widget)
    if (!passwordRegExp.hasMatch(_newPasswordController.text)) {
      formIsValid = false;
    }

    // 3. Valider la non-concordance
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _passwordsDoNotMatch = true;
      });
      formIsValid = false; 
    }

    // Si tout est valide
    if (formIsValid) {
      // Simuler l'enregistrement
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Modifications enregistrées avec succès!'),
          backgroundColor: customGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
        // Afficher un message d'erreur si le formulaire n'est pas valide
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: const Text('Veuillez corriger les erreurs du formulaire.'),
                backgroundColor: customRed,
                duration: const Duration(seconds: 2),
            ),
        );
    }
  }
  
  // Widget de champ de texte stylisé
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    bool isNewPassword = false, 
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          keyboardType: TextInputType.text,
          validator: isNewPassword ? _validatePassword : null, 
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            // Ajout de l'icône de cadenas au début
            prefixIcon: const Icon(Icons.lock_outline, color: customBlue, size: 20), 
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: customBlue, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey.shade600,
              ),
              onPressed: toggleVisibility,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: const CustomHeader(
        title: 'Modifier le mot de passe',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildPasswordField(
                controller: _currentPasswordController,
                label: 'Mot de passe actuel',
                hint: 'Entrez votre mot de passe actuel',
                isVisible: _isCurrentPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                  });
                },
              ),
              _buildPasswordField(
                controller: _newPasswordController,
                label: 'Nouveau mot de passe',
                hint: 'Créez un nouveau mot de passe',
                isVisible: _isNewPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                },
                isNewPassword: true,
              ),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Confirmer le nouveau mot de passe',
                hint: 'Confirmer votre nouveau mot de passe',
                isVisible: _isConfirmPasswordVisible,
                toggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 20),
              PasswordRuleIndicator(password: _newPassword),
              const SizedBox(height: 15),
              if (_passwordsDoNotMatch)
                const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    '⚠️ Les nouveaux mots de passe ne correspondent pas.',
                    style: TextStyle(
                      color: customRed, 
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Enregistrer les modifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Widget personnalisé pour l'affichage des règles de complexité du mot de passe
class PasswordRuleIndicator extends StatelessWidget {
  final String password;

  const PasswordRuleIndicator({super.key, required this.password});

  // Liste des règles et fonctions de vérification
  Map<String, bool> get _rules {
    return {
      'Au moins 8 caractères': password.length >= 8,
      'Contient une majuscule': password.contains(RegExp(r'[A-Z]')),
      'Contient un chiffre (0-9)': password.contains(RegExp(r'[0-9]')),
      'Contient un caractère spécial': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: customGrey.withOpacity(0.4), // Fond légèrement grisé
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Règles de complexité :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ..._rules.entries.map((entry) {
            final isMet = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(
                    isMet ? Icons.check_circle_outline : Icons.circle_outlined,
                    color: isMet ? customGreen : Colors.grey.shade400,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.key,
                    style: TextStyle(
                      color: isMet ? customGreen : Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      decoration: isMet ? TextDecoration.none : TextDecoration.lineThrough,
                      decorationColor: customRed,
                      decorationThickness: 2,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
