import 'package:flutter/material.dart';


class HistoriquePaiement extends StatelessWidget {
  const HistoriquePaiement({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes Paiements',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyPaymentsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Définition des couleurs personnalisées
const Color customOrange = Color(0xFFF59E0B);
const Color customBlue = Color(0xFF2563EB);
const Color accentColor = Color(0xFF4DD0E1); // Pour le dégradé de l'AppBar
const Color lightBlueButton = Color(0xFFE3F2FD); // Couleur de fond du bouton "Évaluer"

// Couleurs spécifiques à la nouvelle Navbar (maintenues mais inutilisées)
const Color selectedIconColor = Color(0xFF27AE60); 
const Color lightGreenBackground = Color(0xFFE8F5E9); 


// Modèle de données pour une transaction
class Transaction {
  final String title;
  final String date;
  final String amount;
  final String status;
  final bool canEvaluate;

  const Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.canEvaluate = false,
  });
}

// Classe principale devenue StatefulWidget pour gérer l'état de la NavBar
class MyPaymentsScreen extends StatefulWidget {
  const MyPaymentsScreen({super.key});

  @override
  State<MyPaymentsScreen> createState() => _MyPaymentsScreenState();
}

class _MyPaymentsScreenState extends State<MyPaymentsScreen> {
  // L'indice de la page actuelle (pour la NavBar)
  int _currentTabIndex = 0; 
  
  final List<Transaction> transactions = const [
    Transaction(title: "Cours de Maths", date: "05 Octobre 2025", amount: "+ 5 000 CFA", status: "Payé", canEvaluate: true),
    Transaction(title: "Retrait d'argent", date: "05 Octobre 2025", amount: "- 20 000 CFA", status: "Réussi"),
    Transaction(title: "Cours d'Anglais", date: "04 Octobre 2025", amount: "+ 7 500 CFA", status: "En attente"),
    Transaction(title: "Cours de Maths", date: "04 Octobre 2025", amount: "+ 6 000 CFA", status: "Annulé"),
    Transaction(title: "Livraison", date: "03 Octobre 2025", amount: "+ 2 000 CFA", status: "Payé"),
    Transaction(title: "Aide à la personne", date: "02 Octobre 2025", amount: "+ 10 000 CFA", status: "Payé"),
  ];
  
  // Fonction appelée lorsque l'utilisateur tape sur un élément de la NavBar
  void _onTabSelected(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    // Cette fonction est conservée au cas où vous souhaiteriez ajouter une barre plus tard.
    String tabName = index == 0 ? "Accueil" : index == 1 ? "Candidatures" : index == 2 ? "Profil" : "Discussions";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Navigation vers : $tabName ($index)"))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customBlue,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [customBlue, accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Logique de retour
          },
        ),
        title: const Text(
          'Mes Paiements',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // --- Résumé Financier ---
                    const FinancialSummaryCard(
                      totalGains: '150.000 CFA',
                      monthlyGains: '+ 45 000 CFA',
                    ),
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
                    // Espace final ajusté maintenant qu'il n'y a plus de barre de navigation
                    const SizedBox(height: 20), 
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      
      // --- bottomNavigationBar ENLEVÉ ---
      // bottomNavigationBar: CustomBottomNavBar(...) // Ancien code supprimé
    );
  }
}

// Widget pour le résumé financier en haut de l'écran (inchangé)
class FinancialSummaryCard extends StatelessWidget {
  final String totalGains;
  final String monthlyGains;

  const FinancialSummaryCard({
    super.key,
    required this.totalGains,
    required this.monthlyGains,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Gains Totaux',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                totalGains,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Gains du mois: $monthlyGains',
                style: const TextStyle(
                  fontSize: 14,
                  color: customBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          // Icône dans le cercle bleu clair
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: customBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.menu_book, color: customBlue, size: 30),
          ),
        ],
      ),
    );
  }
}

// Widget pour le filtre de sélection du mois (inchangé)
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

// Widget pour une seule transaction dans l'historique (inchangé)
class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  // Fonction pour déterminer la couleur du badge en fonction du statut
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Payé':
        return Colors.lightGreen.shade400; // Vert
      case 'Réussi':
        return customBlue; // Bleu
      case 'En attente':
        return customOrange; // Orange
      case 'Annulé':
        return Colors.red.shade400; // Rouge
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(transaction.status);
    final isCredit = transaction.amount.startsWith('+');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: Colors.black87,
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
                      color: isCredit ? Colors.green.shade600 : Colors.red.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Badge de Statut
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15), 
                      borderRadius: BorderRadius.circular(5),
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
          
          // --- Bouton "Évaluer le recruteur" (si disponible) ---
          if (transaction.canEvaluate)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: lightBlueButton,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    // Logique pour naviguer vers la page d'évaluation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Évaluer le recruteur..."))
                    );
                  },
                  icon: const Icon(Icons.star, color: customBlue, size: 20),
                  label: const Text(
                    'Évaluer le recruteur',
                    style: TextStyle(
                      color: customBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Les classes CustomBottomNavBar et NavBarPainter ont été supprimées car la barre est retirée.
