import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';


class SignalerMission extends StatelessWidget {
  const SignalerMission({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignalMissionScreen();
  }
}

// Définition des couleurs personnalisées (récupérées de l'écran précédent)
const Color customOrange = Color(0xFFF59E0B);
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App
const Color accentColor = Color(0xFF4DD0E1); // Bleu/Cyan pour le dégradé (maintenu pour d'autres éléments)
const Color lightBlueButton = Color(0xFFE3F2FD); // Couleur de fond des options

class SignalMissionScreen extends StatefulWidget {
  const SignalMissionScreen({super.key});

  @override
  State<SignalMissionScreen> createState() => _SignalMissionScreenState();
}

class _SignalMissionScreenState extends State<SignalMissionScreen> {
  // État pour gérer l'option de radio sélectionnée
  String? _selectedReason;
  // Contrôleur pour le champ de texte 'Précisions'
  final TextEditingController _precisionController = TextEditingController();

  // Liste des raisons de signalement
  final List<String> reasons = [
    "Contenu inapproprié / Mission illégale",
    "Arnaque ou Fraude potentielle",
    "Demande d'informations personnelles",
    "Non-respect des conditions d'utilisation",
    "Prix irréaliste ou incohérent",
    "Autre",
  ];

  @override
  void dispose() {
    _precisionController.dispose();
    super.dispose();
  }

  void _sendReport() {
    // Logique de signalement
    String precisionText = _precisionController.text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Signalement envoyé. Raison: ${_selectedReason ?? "Non spécifiée"}. Précisions: $precisionText',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc), // Couleur de fond du CustomHeader
      appBar: CustomHeader(
        title: 'Signaler la mission',
        onBack: () => Navigator.of(context).pop(),
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Mission Info ---
            const Text(
              'Mission: Aide Déménagement',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),

            // --- Titre Raison du signalement ---
            const Text(
              'Raison du signalement',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // --- Liste des options de radio ---
            ...reasons.map((reason) => RadioOptionCard(
              title: reason,
              groupValue: _selectedReason,
              value: reason,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedReason = newValue;
                });
              },
            )).toList(),
            
            const SizedBox(height: 25),

            // --- Titre Précisions ---
            const Text(
              'Précisions',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // --- Champ de texte pour les précisions ---
            TextField(
              controller: _precisionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Expliquez pourquoi vous trouvez cette mission suspecte',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                contentPadding: const EdgeInsets.all(15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: customBlue, width: 2),
                ),
                fillColor: Colors.grey.shade50,
                filled: true,
              ),
            ),
            
            const SizedBox(height: 30),

            // --- Boutons Annuler et Envoyer ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Bouton Annuler (Bleu clair et texte bleu)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Logique d'annulation (peut fermer l'écran)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Annulation du signalement"))
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: lightBlueButton,
                      side: const BorderSide(color: customBlue),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'ANNULER',
                      style: TextStyle(color: customBlue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Bouton Envoyer (Bleu foncé plein)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedReason == null ? null : _sendReport, // Désactivé si aucune raison n'est sélectionnée
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customBlue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                    ),
                    child: const Text(
                      'ENVOYER',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


// Widget pour chaque option de radio avec un style de carte
class RadioOptionCard extends StatelessWidget {
  final String title;
  final String? groupValue;
  final String value;
  final ValueChanged<String?> onChanged;

  const RadioOptionCard({
    super.key,
    required this.title,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = groupValue == value;
    
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? lightBlueButton.withOpacity(0.5) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? customBlue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: customBlue,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Pour réduire la zone de clic par défaut
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
