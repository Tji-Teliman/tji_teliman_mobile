import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';


class MissionParametre extends StatelessWidget {
  const MissionParametre({super.key});

  // Définition de la couleur primaire spécifiée
  final Color _primaryBlue = const Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return const MissionPreferencesScreen();
  }
}
// --- END MAIN APP STRUCTURE ---


// --- WIDGET UTILITAIRE POUR LES LIGNES DE PRÉFÉRENCE ---

// Widget réutilisable pour simuler l'apparence des lignes dans l'image
class PreferenceTile extends StatelessWidget {
  final String title;
  final bool isChecked;
  final bool isCircular; // Pour différencier le cercle (radio) ou le carré (checkbox) - même si c'est un checkbox qui gère l'état
  final ValueChanged<bool?> onChanged;

  const PreferenceTile({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onChanged,
    this.isCircular = false,
  });

  // Définition du bleu primaire pour le bouton et la coche
  final Color _primaryBlue = const Color(0xFF2563EB);
  final Color _tealColor = const Color(0xFF20B2AA);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          // Ombre légère pour chaque tuile
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!isChecked), // Inverse l'état au tap
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                // Icône personnalisée pour simuler le style de l'image
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: isCircular ? null : BorderRadius.circular(4),
                    border: Border.all(
                      color: isChecked ? _primaryBlue : Colors.grey.shade400,
                      width: isChecked ? 0 : 2,
                    ),
                    color: isChecked ? _primaryBlue : Colors.transparent,
                  ),
                  child: isChecked
                      ? const Center(
                          child: Icon(
                            Icons.check, // Icône de coche
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// --- END WIDGET UTILITAIRE ---


// --- MISSION PREFERENCES SCREEN IMPLEMENTATION ---

class MissionPreferencesScreen extends StatefulWidget {
  const MissionPreferencesScreen({super.key});

  @override
  State<MissionPreferencesScreen> createState() => _MissionPreferencesScreenState();
}

class _MissionPreferencesScreenState extends State<MissionPreferencesScreen> {
  // Définition des couleurs
  final Color _primaryTeal = const Color(0xFF20B2AA); // Couleur de l'AppBar et du fond
  final Color _primaryBlue = const Color(0xFF2563EB); // Bleu primaire pour les actions/bordures

  // États du formulaire
  Map<String, bool> _missionCategories = {
    'Cours Particuliers': true,
    'Evenementiel': false,
    'Livraison': true,
    'Cuisine': false,
  };

  Map<String, bool> _availability = {
    'Temps plein': false,
    'Temps partiel': true,
    'Week-ends': true,
  };

  // Fonction pour enregistrer les préférences (simulation)
  void _savePreferences() {
    final selectedCategories = _missionCategories.entries.where((e) => e.value).map((e) => e.key).toList();
    final selectedAvailability = _availability.entries.where((e) => e.value).map((e) => e.key).toList();
    
    String message = 'Catégories: ${selectedCategories.join(', ')} | Disponibilité: ${selectedAvailability.join(', ')} (Simulation)';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Préférences enregistrées : $message'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: const CustomHeader(
        title: 'Préférences de Missions',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catégories de Missions Préférées',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            ..._missionCategories.keys.map((key) {
              return PreferenceTile(
                title: key,
                isChecked: _missionCategories[key]!,
                isCircular: false,
                onChanged: (bool? newValue) {
                  setState(() {
                    _missionCategories[key] = newValue!;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 30),
            const Text(
              'Disponibilité',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            ..._availability.keys.map((key) {
              return PreferenceTile(
                title: key,
                isChecked: _availability[key]!,
                isCircular: false,
                onChanged: (bool? newValue) {
                  setState(() {
                    _availability[key] = newValue!;
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Enregistrer les Préférences',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
// --- END MISSION PREFERENCES SCREEN IMPLEMENTATION ---
