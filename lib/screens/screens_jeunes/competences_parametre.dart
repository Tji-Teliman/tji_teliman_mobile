import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';


class CompetencesParametre extends StatelessWidget {
  const CompetencesParametre({super.key});

  @override
  Widget build(BuildContext context) {
    return const MySkillsScreen();
  }
}
// --- END MAIN APP STRUCTURE ---


// --- MY SKILLS SCREEN IMPLEMENTATION ---

// Écran principal (Stateful pour gérer la liste des compétences)
class MySkillsScreen extends StatefulWidget {
  const MySkillsScreen({super.key});

  @override
  State<MySkillsScreen> createState() => _MySkillsScreenState();
}

class _MySkillsScreenState extends State<MySkillsScreen> {
  // Liste initiale des compétences
  final List<String> _skills = [
    'Sécurité et Connexion',
    'Sécurité et Connexion', // Dupliqué dans l'image originale
    'Mes Compétences',
  ];

  final TextEditingController _skillController = TextEditingController();

  // Couleur de l'AppBar et du fond (couleur bleu-vert similaire à customTeal)
  final Color _primaryTeal = const Color(0xFF20B2AA); 
  // Couleur du bouton Enregistrer (Bleu vif)
  final Color _primaryBlue = const Color(0xFF007BFF);

  // Fonction pour ajouter une compétence
  void _addSkill() {
    final newSkill = _skillController.text.trim();
    if (newSkill.isNotEmpty) {
      setState(() {
        _skills.add(newSkill);
        _skillController.clear(); // Efface le champ de saisie
      });
    }
  }

  // Fonction pour supprimer une compétence
  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
    });
  }

  // Fonction pour enregistrer les modifications (simulation)
  void _saveChanges() {
    // Dans une vraie application, ceci enverrait _skills à l'API/base de données
    String savedSkills = _skills.join(', ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Modifications enregistrées : $savedSkills (Simulation)'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: const CustomHeader(
        title: 'Mes Compétencess',
      ),
      body: Padding(
         padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          children: [
            // --- Liste des Compétences Actuelles ---
            Expanded(
              child: ListView.builder(
                itemCount: _skills.length,
                itemBuilder: (context, index) {
                  return SkillChip(
                    skillName: _skills[index],
                    onDelete: () => _removeSkill(index),
                  );
                },
              ),
            ),
            // --- Ajout de Compétence ---
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _skillController,
                      decoration: InputDecoration(
                        hintText: 'Ajouter compétence',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: _primaryBlue, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _addSkill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Text(
                        'Ajouter',
                        style: TextStyle(color: _primaryBlue, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // --- Bouton Enregistrer les Modifications ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Enregistrer les Modifications',
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

// Composant pour afficher une compétence dans la liste (SkillChip)
class SkillChip extends StatelessWidget {
  final String skillName;
  final VoidCallback onDelete;

  const SkillChip({
    super.key,
    required this.skillName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skillName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(
                  Icons.close, // L'icône "x" est simulée par Icons.close
                  size: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
