import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/token_service.dart';
import '../login_screen.dart';
import '../../config/api_config.dart';
import 'dart:io';
import 'dart:async';

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

  // Soumission / erreurs backend
  bool _submitting = false;
  String? _backendError;


  @override
  void initState() {
    super.initState();
    // Écouter les changements du nouveau mot de passe pour la validation en temps réel
    _newPasswordController.addListener(_onNewPasswordChange);
    // Écouter aussi les autres champs pour réévaluer l'état du bouton en direct
    _currentPasswordController.addListener(_onAnyPasswordFieldChange);
    _confirmPasswordController.addListener(_onAnyPasswordFieldChange);
  }

  void _onNewPasswordChange() {
    setState(() {
      _newPassword = _newPasswordController.text;
    });
  }

  void _onAnyPasswordFieldChange() {
    // Force le rebuild pour recalculer _canSubmit à chaque frappe
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_onNewPasswordChange);
    _currentPasswordController.removeListener(_onAnyPasswordFieldChange);
    _confirmPasswordController.removeListener(_onAnyPasswordFieldChange);
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

  bool get _allRulesOk => passwordRegExp.hasMatch(_newPasswordController.text);

  bool get _canSubmit {
    return !_submitting &&
        _currentPasswordController.text.isNotEmpty &&
        _allRulesOk &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text;
  }

  // Fonction pour gérer la soumission
  Future<void> _submitForm() async {
    // Réinitialiser l'erreur de non-concordance
    setState(() {
        _passwordsDoNotMatch = false;
        _backendError = null;
    });
    
    // 1. Valider le formulaire
    bool formIsValid = _formKey.currentState!.validate();

    // 2. Vérifier la complexité (car _validatePassword retourne null si l'erreur est gérée par le widget)
    if (!_allRulesOk) {
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
      if (!_canSubmit) return; // sécurité
      // Demande de confirmation avant de procéder
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(color: customBlue.withOpacity(0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.lock_reset, color: customBlue, size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text('Confirmer la modification', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(
                    'Voulez-vous vraiment modifier votre mot de passe ?\nVous serez automatiquement déconnecté après la réussite.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Annuler', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Modifier', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
      if (confirm != true) return;

      setState(() {
        _submitting = true;
      });
      try {
        final uri = Uri.parse('${ApiConfig.baseUrl}/api/auth/change-password');

        final token = await TokenService.getToken();
        final headers = <String, String>{
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        };
        final body = jsonEncode({
          'motDePasseActuel': _currentPasswordController.text,
          'nouveauMotDePasse': _newPasswordController.text,
          'confirmationMotDePasse': _confirmPasswordController.text,
        });
        final resp = await http
            .post(uri, headers: headers, body: body)
            .timeout(const Duration(seconds: 20));

        if (!mounted) return;

        if (resp.statusCode >= 200 && resp.statusCode < 300) {
          // Succès -> popup stylé puis déconnexion
          await showDialog(
            context: context,
            builder: (ctx) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(color: customGreen.withOpacity(0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: customGreen, size: 30),
                      ),
                      const SizedBox(height: 12),
                      Text('Mot de passe modifié', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        'Votre mot de passe a été modifié avec succès. Vous allez être déconnecté.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text('OK', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          // Déconnexion automatique
          try { await TokenService.logout(); } catch (_) {}
          if (!mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        } else {
          // Erreur backend
          String message = 'Échec de la modification du mot de passe';
          try {
            final data = jsonDecode(resp.body);
            if (data is Map && data['message'] is String) {
              message = data['message'];
            } else if (data is Map && data['error'] is String) {
              message = data['error'];
            }
          } catch (_) {}
          setState(() {
            _backendError = message;
          });
        }
      } on SocketException catch (e) {
        if (!mounted) return;
        setState(() {
          _backendError = "Impossible de se connecter au serveur (${e.osError?.errorCode}). Vérifiez l'URL du backend (${ApiConfig.baseUrl}) et votre connexion réseau.";
        });
      } on TimeoutException {
        if (!mounted) return;
        setState(() {
          _backendError = "La requête a expiré. Veuillez réessayer.";
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _backendError = 'Erreur réseau: ${e.toString()}';
        });
      } finally {
        if (mounted) {
          setState(() {
            _submitting = false;
          });
        }
      }
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
                      if (_backendError != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE5E5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFFFB3B3)),
                          ),
                          child: Text(
                            _backendError!,
                            style: const TextStyle(color: customRed, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _canSubmit ? _submitForm : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: customGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                          ),
                          child: _submitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                                )
                              : const Text(
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
