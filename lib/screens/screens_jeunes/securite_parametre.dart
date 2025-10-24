import 'package:flutter/material.dart';

// Définition des couleurs personnalisées Tji Teliman
const Color _primaryBlue = Color(0xFF2563EB); // Bleu principal
const Color _appBarColor = Color(0xFF46B3C8); // Cyan pour l'AppBar
const Color _accentColor = Color(0xFF4DD0E1); // Pour le dégradé


class SecuriteParametre extends StatelessWidget {
  const SecuriteParametre({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tji Teliman - Sécurité',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: _primaryBlue,
        colorScheme: ColorScheme.light(
          primary: _primaryBlue,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SecuritySettingsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
// --- END MAIN APP STRUCTURE ---

// --- SECURITY SETTINGS SCREEN IMPLEMENTATION ---

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBarColor,
      appBar: AppBar(
        // Utilisation d'un dégradé pour l'AppBar
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
          'Sécurité et Connexion',
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
                child: SecuritySettingsContent(),
              ),
            ),
          ),
        ],
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
            // Logique pour naviguer vers l'écran de modification de mot de passe
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
