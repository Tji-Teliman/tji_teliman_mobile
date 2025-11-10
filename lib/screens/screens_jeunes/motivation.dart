import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/user_service.dart';

// Importation des widgets réutilisables
import '../../widgets/custom_header.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'home_jeune.dart';
import 'message_conversation.dart';

// --- COULEURS ET CONSTANTES ---
const Color primaryBlue = Color(0xFF2563EB); 
const Color lightGrey = Color(0xFFE0E0E0);
const Color darkGrey = Colors.black54;
const Color bodyBackgroundColor = Color(0xFFf6fcfc); 

class MotivationScreen extends StatefulWidget {
  // Le titre de la mission est passé en argument pour l'affichage dans le header
  final String missionTitle;
  // Identifiant de la mission à laquelle postuler (optionnel pour compatibilité)
  final int? missionId;
  
  const MotivationScreen({super.key, required this.missionTitle, this.missionId});

  @override
  State<MotivationScreen> createState() => _MotivationScreenState();
}

class _MotivationScreenState extends State<MotivationScreen> {
  final TextEditingController _motivationController = TextEditingController();
  static const int maxCharacters = 200;
  int _charCount = 0;
  bool _isSubmitting = false;
  
  // L'index de la barre de navigation est fixé à 0 (Accueil).
  final int _selectedIndex = 0; 

  @override
  void initState() {
    super.initState();
    // Écoute les changements dans le champ de texte
    _motivationController.addListener(_updateCharCount);
  }

  void _showApplySuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: primaryBlue, size: 32),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'Candidature soumise !',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Votre candidature a été soumise avec succès. Vous serez informé de la suite.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) => const HomeJeuneScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      elevation: 0,
                    ),
                    child: Text("Retour à l'Accueil", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _motivationController.text.length;
    });
  }

  Future<void> _submitApplication() async {
    if (_isSubmitting) return;
    if (widget.missionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Identifiant de mission manquant', style: GoogleFonts.poppins()),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final success = await UserService.postulerMission(
        missionId: widget.missionId!,
        motivation: _motivationController.text.trim().isEmpty ? null : _motivationController.text.trim(),
      );
      if (!mounted) return;
      if (success) {
        _showApplySuccessDialog();
      }
    } catch (e) {
      if (!mounted) return;
      final cleanMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      _showApplyErrorDialog(cleanMessage);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showApplyErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.error_outline, color: Colors.redAccent, size: 32),
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'Échec de la candidature',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.4),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      elevation: 0,
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
  }

  @override
  void dispose() {
    _motivationController.removeListener(_updateCharCount);
    _motivationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerTitle = 'Postuler pour la mission';
    
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      
      // 1. HEADER personnalisé avec CustomHeader
      appBar: CustomHeader(
        title: headerTitle,
        onBack: () => Navigator.of(context).pop(), 
      ),
      
      // 2. CORPS de la Page
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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
              onPressed: (_charCount <= maxCharacters && !_isSubmitting)
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
      
    );
  }
}
