import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/custom_header.dart';

class SignalerScreen extends StatelessWidget {
  const SignalerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DisputeFormScreen();
  }
}

class DisputeFormScreen extends StatefulWidget {
  DisputeFormScreen({super.key});

  @override
  State<DisputeFormScreen> createState() => _DisputeFormScreenState();
}

class _DisputeFormScreenState extends State<DisputeFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Signaler un litige',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, MediaQuery.of(context).padding.bottom + 20),
        child: DisputeFormContent(
          key: ValueKey('form_content'),
        ),
      ),
    );
  }
}

class DisputeFormContent extends StatefulWidget {
  const DisputeFormContent({super.key});

  @override
  State<DisputeFormContent> createState() => _DisputeFormContentState();
}

class _DisputeFormContentState extends State<DisputeFormContent> {
  // Contrôleurs pour les champs obligatoires
  final TextEditingController _problemController = TextEditingController();
  
  // État pour la validation
  String? _selectedDisputeType;
  XFile? _selectedImage;
  
  // Style commun pour les labels
  final TextStyle labelStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.black87,
  );

  // Style commun pour les bordures
  final OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  );

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  // Vérifier si le formulaire est valide
  bool get _isFormValid {
    return _selectedDisputeType != null && 
           _problemController.text.trim().isNotEmpty;
  }

  // Fonction pour ouvrir le sélecteur d'images
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    
    // Afficher une boîte de dialogue pour choisir entre caméra et galerie
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Appareil photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Galerie'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      try {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedImage = image;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la sélection de l\'image: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _submitForm() {
    if (_isFormValid) {
      // Ici, vous ajouterez la logique de soumission
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Signalement envoyé'),
          content: const Text('Votre signalement a été envoyé avec succès.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Signaler un litige',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Veuillez fournir des détails sur le litige. Incluez toute information ou preuve à l\'appui de votre réclamation.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 25),

        // Type de Litige
        Text('Le type de Litige', style: labelStyle),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedDisputeType,
          decoration: InputDecoration(
            hintText: 'Sélectionnez le type de Litige',
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle.copyWith(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
          items: const [
            DropdownMenuItem(value: 'paiement', child: Text('Litige de paiement')),
            DropdownMenuItem(value: 'qualite', child: Text('Litige de qualité')),
            DropdownMenuItem(value: 'conduite', child: Text('Problème de conduite')),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _selectedDisputeType = newValue;
            });
          },
        ),
        const SizedBox(height: 25),

        // Décrire le problème
        Text('Décrire le problème', style: labelStyle),
        const SizedBox(height: 8),
        TextFormField(
          controller: _problemController,
          maxLines: 5,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Explique ce qui s\'est passé',
            contentPadding: const EdgeInsets.all(15),
            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle.copyWith(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
        const SizedBox(height: 25),

        // Joindre des documents
        Text('Joindre des documents (facultatif)', style: labelStyle),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _selectedImage != null ? Colors.green : Colors.grey.shade300,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: _selectedImage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 35,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedImage!.name,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Appuyez pour changer',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ],
                  )
                : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 35,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  'Televerser la photo de votre carte d\'identité',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),

        // Sélectionner la mission
        Text('Sélectionnez la mission', style: labelStyle),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: 'Sélectionnez une mission',
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle.copyWith(
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
          items: const [
            DropdownMenuItem(value: 'mission_1', child: Text('Mission #456 - Cuisine')),
            DropdownMenuItem(value: 'mission_2', child: Text('Mission #789 - Livraison')),
          ],
          onChanged: (String? newValue) {
            // Logique de sélection
          },
        ),
        const SizedBox(height: 40),

        // Bouton Soumettre
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: _isFormValid ? _submitForm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFormValid 
                  ? const Color(0xFFF9A825) 
                  : Colors.grey.shade300,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 4,
            ),
            child: Text(
              'Soumettre le signalement',
              style: TextStyle(
                color: _isFormValid ? Colors.white : Colors.grey.shade600,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
