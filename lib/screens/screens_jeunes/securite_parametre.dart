import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'home_jeune.dart';
import 'parametre_change_mdp.dart';

// Définition des couleurs personnalisées Tji Teliman
const Color _primaryBlue = Color(0xFF2563EB); // Bleu principal
const Color _appBarColor = Color(0xFF46B3C8); // Cyan pour l'AppBar
const Color _accentColor = Color(0xFF4DD0E1); // Pour le dégradé


class SecuriteParametre extends StatelessWidget {
  const SecuriteParametre({super.key});

  @override
  Widget build(BuildContext context) {
    return const SecuritySettingsScreen();
  }
}
// --- END MAIN APP STRUCTURE ---

// --- SECURITY SETTINGS SCREEN IMPLEMENTATION ---

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Sécurité et Connexion',
        onBack: () {
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            navigator.pushReplacement(
              MaterialPageRoute(builder: (ctx) => const HomeJeuneScreen()),
            );
          }
        },
      ),
      
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: SecuritySettingsContent(),
      ),
    );
  }
}

// Widget principal du contenu de la page
class SecuritySettingsContent extends StatefulWidget {
  const SecuritySettingsContent({super.key});

  @override
  State<SecuritySettingsContent> createState() => _SecuritySettingsContentState();
}

class _SecuritySettingsContentState extends State<SecuritySettingsContent> {
  // Simuler l'état des options
  bool _isFaceIdEnabled = true;
  bool _isTwoFactorAuthEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Titre du Groupe : Sécurité du Compte ---
        const SectionHeader(title: 'Sécurité du Compte', icon: Icons.security_rounded),
        const SizedBox(height: 10),

        // 1. Modifier le Mot de Passe
        SettingsTile(
          title: 'Modifier le mot de passe',
          subtitle: 'Changez votre mot de passe pour garantir la sécurité de votre compte.',
          icon: Icons.lock_outline,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ParametreChangeMdp()),
            );
          },
        ),
        const Divider(height: 1),

        // 2. Authentification à Deux Facteurs
        SwitchTile(
          title: 'Authentification à 2 facteurs',
          subtitle: 'Ajouter une couche de sécurité supplémentaire (Recommandé).',
          icon: Icons.vpn_key_outlined,
          value: _isTwoFactorAuthEnabled,
          onChanged: (bool newValue) {
            setState(() {
              _isTwoFactorAuthEnabled = newValue;
            });
          },
        ),
        const SizedBox(height: 30),


       
  

        // --- Bouton de Déconnexion ---
        PrimaryButton(
          text: 'Déconnexion',
          color: Colors.red.shade600,
          onPressed: () {
            _showLogoutDialog(context);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// --- WIDGET UTILITAIRE : En-tête de Section ---
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _primaryBlue, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: _primaryBlue,
          ),
        ),
      ],
    );
  }
}

// --- WIDGET UTILITAIRE : Tuile de Paramètre simple (Tap) ---
class SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      leading: Icon(icon, color: Colors.black87, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
      onTap: onTap,
    );
  }
}

// --- WIDGET UTILITAIRE : Tuile de Paramètre avec Switch ---
class SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      activeColor: _primaryBlue,
      secondary: Icon(icon, color: Colors.black87, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.black54),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}

// --- WIDGET UTILITAIRE : Bouton Principal ---
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// --- Fonction pour afficher le dialogue de déconnexion (remplace l'alerte) ---
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        content: const Text(
            'Vous devrez vous reconnecter pour accéder à votre compte. Assurez-vous d\'avoir sauvegardé toutes vos données.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Annuler', style: TextStyle(color: Colors.black54)),
            onPressed: () {
              Navigator.of(context).pop(); // Ferme la boîte de dialogue
            },
          ),
          TextButton(
            child: const Text('Déconnexion', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(context).pop(); // Ferme la boîte de dialogue
              // Logique de déconnexion Firebase ou autre
              // print("Déconnexion de l'utilisateur...");
            },
          ),
        ],
      );
    },
  );
}
