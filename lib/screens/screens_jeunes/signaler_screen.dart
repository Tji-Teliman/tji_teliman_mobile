import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';


class SignalerScreen extends StatelessWidget {
  const SignalerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DisputeFormScreen();
  }
}

class DisputeFormScreen extends StatelessWidget {
  const DisputeFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc), // Couleur de fond du CustomHeader
      appBar: CustomHeader(
        title: 'Signaler un litige',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: DisputeFormContent(),
      ),
    );
  }
}

class DisputeFormContent extends StatelessWidget {
  const DisputeFormContent({super.key});

  // Style commun pour les labels de formulaire
  final TextStyle labelStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.black87,
  );

  // Style commun pour les InputDecoration (bordure arrondie)
  final OutlineInputBorder borderStyle = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.grey, width: 1.0),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // --- Titre et description ---
        const Text(
          'Signaler un litige de paiement',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Veuillez fournir des détails sur le litige de paiement. Incluez toute information ou preuve à l\'appui de votre réclamation.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 25),

        // --- Le type de Litige (Dropdown) ---
        Text('Le type de Litige', style: labelStyle),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
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
            // ... autres types ...
          ],
          onChanged: (String? newValue) {
            // Logique de sélection
          },
        ),
        const SizedBox(height: 25),

        // --- Décrire le problème (Textarea) ---
        Text('Décrire le problème', style: labelStyle),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 5,
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

        // --- Joindre des documents (Upload) ---
        Text('Joindre des documents (facultatif)', style: labelStyle),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Logique pour ouvrir le sélecteur de fichiers
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: const Column(
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

        // --- Sélectionner la mission (Dropdown) ---
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
            // ... autres missions ...
          ],
          onChanged: (String? newValue) {
            // Logique de sélection
          },
        ),
        const SizedBox(height: 40),

        // --- Bouton Soumettre ---
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              // Logique de soumission du formulaire
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF9A825), // Orange vif
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Soumettre un litige',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}