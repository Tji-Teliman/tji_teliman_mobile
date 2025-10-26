import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'signaler_screen.dart';
import 'historique_litige.dart';



class ListeLitige extends StatelessWidget {
  const ListeLitige({super.key});

  @override
  Widget build(BuildContext context) {
    return const DisputeListScreen();
  }
}

// Modèle de données pour un type de litige
class DisputeType {
  final IconData icon;
  final String title;
  final String description;

  // CORRECTION: Ajout du mot-clé 'const' au constructeur.
  const DisputeType({required this.icon, required this.title, required this.description});
}

class DisputeListScreen extends StatelessWidget {
  const DisputeListScreen({super.key});

  // Maintenant que le constructeur est 'const', la liste peut être 'const'
  final List<DisputeType> typesDeLitiges = const [
    DisputeType(
      icon: Icons.menu_book, // Icône pour un document/livre
      title: "Non-paiement",
      description: "Le paiement n'a pas été effectué comme convenu.",
    ),
    DisputeType(
      icon: Icons.build_circle_outlined, // Icône pour un outil/réparation
      title: "Travail non conforme",
      description: "Le travail réalisé ne correspond pas aux attentes.",
    ),
    DisputeType(
      icon: Icons.history, // Icône pour l'historique/retard
      title: "Retard de paiement",
      description: "Le paiement a été effectué en retard par rapport à l'échéance.",
    ),
    DisputeType(
      icon: Icons.person_off_outlined, // Icône pour absence de personne
      title: "Absence du jeune",
      description: "Le jeune ne s'est pas présenté au travail sans préavis.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc), // Couleur de fond du CustomHeader
      appBar: CustomHeader(
        title: 'Litiges',
        onBack: () => Navigator.of(context).pop(),
      ),
      
      // Bouton Flottant (Floating Action Button)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigation vers la page signaler un litige
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SignalerScreen()),
          );
        },
        backgroundColor: const Color(0xFF2f9bcf), // Couleur du CustomHeader
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Titre de la section ---
            const Text(
              'Types de litiges',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),

            // --- Liste des types de litiges ---
            ...typesDeLitiges.map((dispute) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: DisputeItemCard(dispute: dispute),
              );
            }).toList(),

            const SizedBox(height: 80), // Espace pour le FAB
          ],
        ),
      ),
    );
  }
}


// Widget pour un seul élément de la liste
class DisputeItemCard extends StatelessWidget {
  final DisputeType dispute;

  const DisputeItemCard({super.key, required this.dispute});

  @override
  Widget build(BuildContext context) {
    // La couleur des icônes et de l'arrière-plan pastel
    const Color pastelBlue = Color(0xFFE3F2FD); 
    const Color iconColor = Color(0xFF64B5F6);

    return InkWell(
      onTap: () {
        // Navigation vers la page historique des litiges
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HistoriqueLitige()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), 
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // --- Icône dans le cercle pastel ---
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: pastelBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(dispute.icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 15),
            
            // --- Titre et Description ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    dispute.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dispute.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
