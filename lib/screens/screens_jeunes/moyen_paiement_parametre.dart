import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';

class MoyenPaiementParametre extends StatelessWidget {
  const MoyenPaiementParametre({super.key});

  // Définition de la couleur primaire spécifiée
  final Color _primaryBlue = const Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return const PaymentMethodsScreen();
  }
}
// --- END MAIN APP STRUCTURE ---


// Modèle de données pour un mode de paiement
class PaymentMethod {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const PaymentMethod({
    required this.icon, 
    required this.title, 
    required this.description, 
    required this.color
  });
}


// --- PAYMENT METHODS SCREEN IMPLEMENTATION ---

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final Color _primaryBlue = const Color(0xFF2563EB);
  final Color _appBarColor = const Color(0xFF46B3C8); 
  final Color _backgroundColor = const Color(0xFFE0F7FA);

  // Liste des méthodes de paiement disponibles (sans Carte Bancaire)
  final List<PaymentMethod> availableMethods = const [
    PaymentMethod(
      icon: Icons.smartphone,
      title: "Mobile Money (Orange)",
      description: "07 12 34 56 78 - Par défaut",
      color: Color(0xFFFF6600), // Orange
    ),
    PaymentMethod(
      icon: Icons.payments,
      title: "Paiement en espèces",
      description: "Payer directement le jeune sur place",
      color: Color(0xFF374151), // Gris foncé
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: const CustomHeader(
        title: 'Moyens de Paiement',
      ),
      
      body: Column(
        children: <Widget>[
          // Conteneur blanc principal avec ombre et arrondi
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: _backgroundColor, 
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // --- Section Moyens de Paiement Existants ---
                    const SectionTitle(title: 'Moyen de paiement par défaut'),
                    const SizedBox(height: 10),
                    // Carte du mode de paiement principal (Mobile Money)
                    PaymentMethodCard(
                      method: availableMethods[0], // Le premier de la liste est le défaut
                      isDefault: true,
                      onTap: () {},
                    ),
                    
                    const SizedBox(height: 30),

                    // --- Section Autres Moyens ---
                    const SectionTitle(title: 'Autres moyens de paiement'),
                    const SizedBox(height: 10),
                    
                    // Liste des autres moyens (commence après le défaut)
                    ...availableMethods.skip(1).map((method) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: PaymentMethodCard(
                          method: method,
                          isDefault: false,
                          onTap: () {
                            // Simuler la sélection pour le mettre en défaut
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${method.title} sélectionné comme défaut (Simulation)')),
                            );
                          },
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 30),

                    // Le bouton Ajouter une Carte / Un Compte a été retiré.

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// --- END PAYMENT METHODS SCREEN IMPLEMENTATION ---


// --- WIDGET UTILITAIRE : Titre de Section ---
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}


// --- WIDGET UTILITAIRE : Carte de Mode de Paiement ---
class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final bool isDefault;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isDefault,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDefault ? const Color(0xFFF0F9FF) : Colors.white, // Fond bleu très clair si par défaut
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isDefault ? const Color(0xFF93C5FD) : Colors.grey.shade200, // Bordure bleue si par défaut
            width: isDefault ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), 
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Icône avec la couleur de la méthode
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: method.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(method.icon, color: method.color, size: 28),
            ),
            const SizedBox(width: 15),
            
            // Titre et Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    method.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDefault ? Colors.blue.shade700 : Colors.grey,
                      fontWeight: isDefault ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Badge par défaut
            if (isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade500,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'PAR DÉFAUT',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),

            // Flèche pour les options (si pas par défaut)
            if (!isDefault)
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}


// --- WIDGET UTILITAIRE : Bouton Ajouter une Carte (Supprimé de l'écran principal) ---
class AddCardButton extends StatelessWidget {
  final Color primaryColor;
  final VoidCallback onPressed;

  const AddCardButton({
    super.key,
    required this.primaryColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.add_circle_outline, color: primaryColor),
      label: Text(
        'Ajouter une Carte / Un Compte',
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }
}
