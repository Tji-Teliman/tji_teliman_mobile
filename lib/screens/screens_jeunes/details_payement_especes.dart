import 'package:flutter/material.dart';

// Définition des couleurs personnalisées
const Color _primaryBlue = Color(0xFF2563EB); // Bleu principal
const Color _appBarColor = Color(0xFF46B3C8); // Cyan pour l'AppBar
const Color _cashColor = Color(0xFF10B981); // Vert pour l'argent
const Color _accentColor = Color(0xFF4DD0E1); // Pour le dégradé

class DetailsPayementEspeces extends StatelessWidget {
  const DetailsPayementEspeces({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tji Teliman - Règles Paiement',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: _primaryBlue,
        colorScheme: ColorScheme.light(
          primary: _primaryBlue,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CashPaymentRulesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// --- END MAIN APP STRUCTURE ---


// --- CASH PAYMENT RULES SCREEN IMPLEMENTATION ---

class CashPaymentRulesScreen extends StatelessWidget {
  const CashPaymentRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBarColor,
      appBar: AppBar(
        // Utilisation d'un dégradé pour l'AppBar pour correspondre au style Tji Teliman
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [_appBarColor, _accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 24),
          onPressed: () {
            // Logique de retour
          },
        ),
        title: const Text(
          'Règles du Paiement en Espèces',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      
      body: Column(
        children: <Widget>[
          // Conteneur blanc principal avec ombre et arrondi
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: const SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: CashPaymentRulesContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget principal du contenu de la page
class CashPaymentRulesContent extends StatelessWidget {
  const CashPaymentRulesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        // --- Icône et titre général ---
        Center(
          child: PaymentIcon(
            icon: Icons.monetization_on,
            color: _cashColor,
            title: 'Paiement en Espèces',
            subtitle: 'Direct, sécurisé et garanti par l\'application.',
          ),
        ),
        const SizedBox(height: 30),

        // --- Introduction ---
        const SectionTitle(title: 'Principe du Paiement Direct'),
        const SizedBox(height: 10),
        const Text(
          "Le paiement en espèces est un accord entre le Recruteur et le Jeune. Il doit être effectué intégralement à la fin de la mission. Suivez les étapes ci-dessous pour assurer la validité de la transaction pour les deux parties.",
          style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
        ),
        const SizedBox(height: 30),

        // --- Instructions pour le Recruteur ---
        RoleInstructions(
          roleTitle: 'Pour le Recruteur (Le Payeur)',
          icon: Icons.person_outline,
          color: _primaryBlue,
          instructions: const [
            "Préparez le montant exact de la mission pour éviter les complications.",
            "Effectuez le paiement **uniquement après la validation** de la fin de la mission.",
            "Assurez-vous que le Jeune **confirme la réception** de l'argent dans son application.",
          ],
        ),
        const SizedBox(height: 30),

        // --- Instructions pour le Jeune ---
        RoleInstructions(
          roleTitle: 'Pour le Jeune (Le Bénéficiaire)',
          icon: Icons.work_outline,
          color: _cashColor,
          instructions: const [
            "Vérifiez que le montant reçu est exact avant de quitter les lieux.",
            "Confirmez immédiatement le paiement dans votre application Tji Teliman pour que le recruteur puisse clôturer la mission.",
            "En cas de désaccord sur le montant ou le statut, signalez un litige via l'application.",
          ],
        ),
        const SizedBox(height: 40),

        // --- Garantie de la plateforme ---
        PlatformGuarantee(
          color: _cashColor,
          text: "En cas de litige, Tji Teliman intervient pour garantir une solution équitable pour les deux parties.",
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

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
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// --- WIDGET UTILITAIRE : Icône de Paiement Générique ---
class PaymentIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const PaymentIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 40),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

// --- WIDGET UTILITAIRE : Instructions par Rôle ---
class RoleInstructions extends StatelessWidget {
  final String roleTitle;
  final IconData icon;
  final Color color;
  final List<String> instructions;

  const RoleInstructions({
    super.key,
    required this.roleTitle,
    required this.icon,
    required this.color,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05), // Fond très clair pour différencier le rôle
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                roleTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: color,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black12, height: 20),
          
          // Liste des instructions
          ...instructions.asMap().entries.map((entry) {
            final instruction = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.done, color: color, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      instruction,
                      style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// --- WIDGET UTILITAIRE : Message de Garantie ---
class PlatformGuarantee extends StatelessWidget {
  final Color color;
  final String text;

  const PlatformGuarantee({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: color, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
