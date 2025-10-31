import 'package:flutter/material.dart';
import '../../widgets/custom_header.dart';
import 'profil_jeune.dart';
import 'securite_parametre.dart';
import 'competences_parametre.dart';
import 'mission_parametre.dart';
import 'moyen_paiement_parametre.dart';
import 'home_jeune.dart';
import 'centre_aide.dart';
import 'conditions_generales.dart';
import 'politique_et_confidenlite.dart';

// --- 1. Gestionnaire d'état pour le thème ---
class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// --- NOUVEAU: Gestionnaire d'état pour les notifications ---
class NotificationManager with ChangeNotifier {
  bool _notificationsEnabled = true; // Par défaut : activé

  bool get notificationsEnabled => _notificationsEnabled;

  void toggleNotifications(bool newValue) {
    _notificationsEnabled = newValue;
    notifyListeners();
  }
}


class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _MyAppState();
}

class _MyAppState extends State<Parametre> {
  final ThemeManager _themeManager = ThemeManager();
  final NotificationManager _notificationManager = NotificationManager(); // NOUVEAU MANAGER

  @override
  void initState() {
    super.initState();
    // Écouter les changements du thème
    _themeManager.addListener(_onThemeChanged);
    // Écouter les changements des notifications
    _notificationManager.addListener(_onNotificationsChanged);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_onThemeChanged);
    _notificationManager.removeListener(_onNotificationsChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    // Rebuild l'application lorsque le thème change
    setState(() {});
  }
  
  void _onNotificationsChanged() {
    // Rebuild l'application lorsque les notifications changent
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    // Retourner directement l'écran, sans MaterialApp imbriqué
    return SettingsScreen(
        themeManager: _themeManager,
      notificationManager: _notificationManager,
    );
  }
}

// Définition des couleurs personnalisées
const Color customBlue = Color(0xFF2563EB); // Bleu foncé de la barre d'App
const Color customRed = Color(0xFFEF4444); // Rouge pour la déconnexion
const Color customGreen = Color(0xFF10B981); // Vert pour l'activation

// Modèle pour les éléments de la liste de paramètres
class SettingItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final Widget? trailingWidget;
  final bool isNavigation; // True si c'est un lien vers une autre page
  final String key; // Clé pour identifier l'élément (ex: 'modeSombre')

  const SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.iconColor,
    this.trailingWidget,
    this.isNavigation = true,
    required this.key,
  });
}

class SettingsScreen extends StatelessWidget {
  final ThemeManager themeManager;
  final NotificationManager notificationManager; // NOUVELLE PROPRIÉTÉ
  
  const SettingsScreen({
    super.key, 
    required this.themeManager, 
    required this.notificationManager,
  });

  // Navigation fiable basée sur la clé (item.key) et non le titre affiché
  void _handleTap(BuildContext context, String key) {
    switch (key) {
      case 'infoPerso':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfilJeuneScreen()),
        );
        return;
      case 'securite':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SecuriteParametre()),
        );
        return;
      case 'competences':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CompetencesParametre()),
        );
        return;
      case 'prefMissions':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MissionParametre()),
        );
        return;
      case 'moyenPaiement':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MoyenPaiementParametre()),
        );
        return;
      case 'aide':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CentreAide()),
        );
        return;
      case 'cgu':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ConditionsGenerales()),
        );
        return;
      case 'confidentialite':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PolitiqueEtConfidenlite()),
        );
        return;
      default:
    ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Navigation: $key"), duration: const Duration(milliseconds: 800)),
    );
    }
  }

  // Liste des sections de paramètres
  List<Map<String, dynamic>> getSettingSections(BuildContext context) {
    final bool isDarkMode = themeManager.themeMode == ThemeMode.dark;
    final bool areNotificationsEnabled = notificationManager.notificationsEnabled; // NOUVEL ÉTAT
    
    // La couleur de l'icône du mode sombre dépend de l'état du mode sombre
    final Color modeSombreIconColor = isDarkMode ? Colors.yellow.shade700 : Colors.grey;

    return [
      {
        'header': 'Généralités (Mon Compte)',
        'items': const [
          SettingItem(
            icon: Icons.person_outline,
            title: 'Informations Personnelles',
            iconColor: customBlue,
            key: 'infoPerso',
          ),
          SettingItem(
            icon: Icons.lock_outline,
            title: 'Sécurité et Connexion',
            iconColor: customBlue,
            key: 'securite',
          ),
          SettingItem(
            icon: Icons.description_outlined,
            title: 'Mes Compétences',
            iconColor: customBlue,
            key: 'competences',
          ),
        ],
      },
      {
        'header': 'Préférences de l\'Application',
        'items': [
          // --- MISE À JOUR de l'élément Notifications ---
          SettingItem(
            icon: Icons.notifications, 
            title: 'Notifications',
            iconColor: customGreen,
            isNavigation: false,
            key: 'notifications',
            trailingWidget: SwitchWidget(
              initialValue: areNotificationsEnabled, 
              activeColor: customGreen,
              onChanged: (value) => notificationManager.toggleNotifications(value),
            ),
          ),
          const SettingItem(
            icon: Icons.location_on_outlined,
            title: 'Préférences de Missions',
            iconColor: customBlue,
            key: 'prefMissions',
          ),
          // --- Mise à jour de l'élément Mode Sombre ---
          SettingItem(
            icon: isDarkMode ? Icons.mode_night : Icons.mode_night_outlined,
            title: 'Mode Sombre',
            iconColor: modeSombreIconColor,
            isNavigation: false,
            key: 'modeSombre',
            trailingWidget: SwitchWidget(
              initialValue: isDarkMode, 
              activeColor: customGreen,
              onChanged: (value) => themeManager.toggleTheme(),
            ),
          ),
        ],
      },
      {
        'header': 'Paiement et Finance',
        'items': const [
          SettingItem(
            icon: Icons.sell_outlined, 
            title: 'Moyen de Paiement',
            iconColor: customBlue,
            key: 'moyenPaiement',
            trailingWidget: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ),
        ],
      },
      {
        'header': 'Support et Mention Légales',
        'items': const [
          SettingItem(
            icon: Icons.contact_support_outlined,
            title: 'Centre d\'Aide/FAQ',
            iconColor: Colors.grey,
            key: 'aide',
          ),
          SettingItem(
            icon: Icons.info_outline,
            title: 'Conditions Générales d\'Utilisation (CGU)',
            iconColor: Colors.grey,
            key: 'cgu',
          ),
          SettingItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Politique de Confidentialité',
            iconColor: Colors.grey,
            key: 'confidentialite',
          ),
        ],
      },
    ];
  }

  // Le switch général "Paiement et Finance" du design original
  Widget _buildPaymentToggle(BuildContext context) {
    final bool isDarkMode = themeManager.themeMode == ThemeMode.dark;
    
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Paiement et Finance',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          // Suppression du SwitchWidget ici, comme demandé.
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> settingSections = getSettingSections(context);
    final bool isDarkMode = themeManager.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: const Color(0xFFf6fcfc),
      appBar: CustomHeader(
        title: 'Paramètres du Compte',
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
      
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFf6fcfc), // This is the color of your background
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30.0)),
              ),
              child: SingleChildScrollView(
                 padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // --- Construction des Sections ---
                    ...settingSections.where((s) => s['header'] != 'Paiement et Finance').map((section) {
                      return SettingSection(
                        header: section['header'],
                        items: section['items'],
                        onTap: (title) => _handleTap(context, title),
                        isDarkMode: isDarkMode,
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    // --- Section Paiement et Finance spécifique avec le Switch en entête ---
                    _buildPaymentToggle(context), // Le titre est ici
                    SettingSection(
                      header: '', // Pas de titre car le titre est dans le toggle
                      items: settingSections.firstWhere((s) => s['header'] == 'Paiement et Finance')['items'],
                      onTap: (title) => _handleTap(context, title),
                      showBoxShadow: true,
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 20),
                    
                    // --- Bouton de Déconnexion ---
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: customRed.withOpacity(0.1), // Fond rouge très léger
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _handleTap(context, "Déconnexion");
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          '[-> Déconnexion',
                          style: TextStyle(
                            color: customRed,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30), 
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

// Widget pour la structure d'une section
class SettingSection extends StatelessWidget {
  final String header;
  final List<SettingItem> items;
  final Function(String) onTap;
  final bool showBoxShadow;
  final bool isDarkMode;

  const SettingSection({
    super.key, 
    required this.header, 
    required this.items, 
    required this.onTap,
    this.showBoxShadow = false, 
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la Section (Affiché uniquement s'il n'est pas vide)
          if (header.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                header,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ),
          
          // Liste des Éléments
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            decoration: BoxDecoration(
              // Couleur de fond de la carte
              color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: showBoxShadow ? [
                BoxShadow(
                  color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ] : null,
            ),
            child: Column(
              children: items.map((item) {
                return SettingRow(
                  item: item,
                  onTap: () => onTap(item.key),
                  isDarkMode: isDarkMode,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget pour chaque ligne/option de paramètre
class SettingRow extends StatelessWidget {
  final SettingItem item;
  final VoidCallback onTap;
  final bool isDarkMode;

  const SettingRow({super.key, required this.item, required this.onTap, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
      child: InkWell(
        onTap: item.isNavigation ? onTap : null, 
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              // Icône
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: item.iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 24),
              ),
              const SizedBox(width: 15),
              
              // Titre et Sous-titre
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Widget de fin (Flèche ou Switch)
              if (item.trailingWidget != null) item.trailingWidget!,
              if (item.trailingWidget == null && item.isNavigation)
                const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget personnalisé pour l'exemple de Switch
class SwitchWidget extends StatefulWidget {
  final bool initialValue;
  final Color activeColor;
  final ValueChanged<bool>? onChanged;

  const SwitchWidget({
    super.key, 
    required this.initialValue, 
    required this.activeColor, 
    this.onChanged,
  });

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  // Mettre à jour l'état si l'initialValue change (nécessaire pour le mode sombre et les notifications)
  @override
  void didUpdateWidget(covariant SwitchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _value,
      onChanged: (newValue) {
        setState(() {
          _value = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        } else {
           // Logique de changement par défaut (pour les autres switches)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Changement de l'état : ${newValue ? 'Activé' : 'Désactivé'}"),
              duration: const Duration(milliseconds: 500),
            ),
          );
        }
      },
      activeColor: widget.activeColor,
    );
  }
}
