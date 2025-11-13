import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'package:google_fonts/google_fonts.dart';


class ContacterNous extends StatelessWidget {
  const ContacterNous({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContactUsScreen();
  }
}

// Définition des couleurs personnalisées
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App et boutons
const Color customOrange = Color(0xFFF59E0B); // Couleur Orange

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onChange);
    _emailController.addListener(_onChange);
    _messageController.addListener(_onChange);
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _nameController.removeListener(_onChange);
    _emailController.removeListener(_onChange);
    _messageController.removeListener(_onChange);
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  bool get _canSend =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _messageController.text.trim().isNotEmpty;

  Future<void> _showSuccessDialog() async {
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
                  decoration: BoxDecoration(color: customBlue.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: customBlue, size: 30),
                ),
                const SizedBox(height: 12),
                Text('Message envoyé', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  'Merci, votre avis a bien été envoyé et sera pris en compte.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customBlue,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Nous Contacter',
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
            const SizedBox(height: 0),
                    // --- Champ Votre Nom ---
                    CustomTextField(hintText: 'Votre Nom', controller: _nameController),
                    const SizedBox(height: 15),
                    // --- Champ Votre Adresse E-mail ---
                    CustomTextField(hintText: 'Votre Adresse E-mail', controller: _emailController),
                    const SizedBox(height: 15),
                    // --- Champ Votre Message (Multi-lignes) ---
                    Container(
              height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300, width: 1.5),
                      ),
                      child: TextField(
                controller: _messageController,
                maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Votre Message',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(12.0),
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // --- Bouton Envoyer ---
                    ElevatedButton(
                      onPressed: _canSend
                          ? () async {
                              await _showSuccessDialog();
                              if (!mounted) return;
                              _nameController.clear();
                              _emailController.clear();
                              _messageController.clear();
                            }
                          : null,
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
    );
  }
}

// Widget pour les champs de texte simples
class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;

  const CustomTextField({super.key, required this.hintText, this.controller});

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
        controller: controller,
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
