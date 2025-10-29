import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'home_recruteur.dart';

class HistoriquePaiementRecruteur extends StatelessWidget {
  const HistoriquePaiementRecruteur({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyPaymentsRecruteurScreen();
  }
}

// Définition des couleurs personnalisées
const Color customOrange = Color(0xFFF59E0B);
const Color customBlue = Color(0xFF2563EB);
const Color accentColor = Color(0xFF4DD0E1);
const Color lightBlueButton = Color(0xFFE3F2FD);
const Color recipientBadgeBlue = Color(0xFF2196F3); // Couleur du badge "Payer à"
const Color recipientBadgeBackground = Color(0xFFE3F2FD); // Fond du badge

// Modèle de données pour une transaction de recruteur
class TransactionRecruteur {
  final String title;
  final String date;
  final String amount;
  final String status;
  final String? recipient; // Nom du bénéficiaire

  const TransactionRecruteur({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.recipient,
  });
}

// Classe principale devenue StatefulWidget pour gérer l'état
class MyPaymentsRecruteurScreen extends StatefulWidget {
  const MyPaymentsRecruteurScreen({super.key});

  @override
  State<MyPaymentsRecruteurScreen> createState() => _MyPaymentsRecruteurScreenState();
}

class _MyPaymentsRecruteurScreenState extends State<MyPaymentsRecruteurScreen> {
  
  final List<TransactionRecruteur> transactions = const [
    TransactionRecruteur(
      title: "Cours de Maths",
      date: "05 Octobre 2025",
      amount: "+ 5 000 CFA",
      status: "Payé",
      recipient: "Fatou Bamba",
    ),
    TransactionRecruteur(
      title: "Cours d'Anglais",
      date: "04 Octobre 2025",
      amount: "+ 7 500 CFA",
      status: "Payé",
      recipient: "Amadou Diop",
    ),
    TransactionRecruteur(
      title: "Aide Ménagère",
      date: "03 Octobre 2025",
      amount: "+ 10 000 CFA",
      status: "Payé",
      recipient: "Mariam Traoré",
    ),
    TransactionRecruteur(
      title: "Livraison",
      date: "02 Octobre 2025",
      amount: "+ 8 000 CFA",
      status: "Payé",
      recipient: "Sidi Kone",
    ),
    TransactionRecruteur(
      title: "Cours de Français",
      date: "01 Octobre 2025",
      amount: "+ 6 500 CFA",
      status: "Payé",
      recipient: "Awa Diallo",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Mes Paiements',
        onBack: () {
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (ctx) => const HomeRecruteurScreen()),
            );
          }
        },
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            
            // --- Filtre Mois ---
            const MonthFilter(),
            const SizedBox(height: 20),

            // --- Historique Title ---
            const Text(
              'Historique',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // --- Liste des Transactions ---
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
              itemBuilder: (context, index) {
                return TransactionItem(transaction: transactions[index]);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Widget pour le filtre de sélection du mois
class MonthFilter extends StatelessWidget {
  const MonthFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: 'Mois',
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
          isExpanded: true,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          items: <String>['Mois', 'Octobre', 'Septembre', 'Août']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            // Logique de filtrage par mois
          },
        ),
      ),
    );
  }
}

// Widget pour une seule transaction dans l'historique
class TransactionItem extends StatelessWidget {
  final TransactionRecruteur transaction;

  const TransactionItem({super.key, required this.transaction});

  // Fonction pour déterminer la couleur du badge en fonction du statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Payé':
        return Colors.green.shade600;
      case 'Réussi':
        return Colors.blue.shade600;
      case 'En attente':
        return Colors.orange.shade600;
      case 'Annulé':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  // Fonction pour déterminer la couleur de fond du badge
  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Payé':
        return Colors.green.shade100;
      case 'Réussi':
        return Colors.blue.shade100;
      case 'En attente':
        return Colors.orange.shade100;
      case 'Annulé':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(transaction.status);
    final statusBackgroundColor = _getStatusBackgroundColor(transaction.status);
    final isCredit = transaction.amount.startsWith('+');

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- Titre et Date ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              // --- Montant et Statut ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // Montant
                  Text(
                    transaction.amount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCredit ? Colors.green.shade600 : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Badge de Statut
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      transaction.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // --- Badge "Payer à : [Nom]" ---
          if (transaction.recipient != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: recipientBadgeBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: recipientBadgeBlue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Payer à : ${transaction.recipient}',
                    style: TextStyle(
                      color: recipientBadgeBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

