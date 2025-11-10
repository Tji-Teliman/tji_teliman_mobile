import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_bottom_nav_bar_recruteur.dart';
import '../../widgets/custom_menu_recruteur.dart';
import 'message_conversation_recruteur.dart';
import 'home_recruteur.dart';
import 'missions_recruteur.dart';
import 'modifier_profil_recruteur.dart';
import '../../services/profile_service.dart';
import '../../services/user_service.dart';
import '../../services/token_service.dart';
import '../../config/api_config.dart';

// Couleurs utilisées
const Color primaryBlue = Color(0xFF2563EB);
const Color primaryGreen = Color(0xFF10B981);
const Color bodyBackgroundColor = Color(0xFFf6fcfc);
const Color badgeOrange = Color(0xFFF59E0B);
const Color orangeBrand = Color(0xFFE67E22);

class ProfilRecruteurScreen extends StatefulWidget {
  const ProfilRecruteurScreen({super.key});

  @override
  State<ProfilRecruteurScreen> createState() => _ProfilRecruteurScreenState();
}

class _ProfilRecruteurScreenState extends State<ProfilRecruteurScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 2; // Onglet Profil

  // Données dynamiques
  String fullName = '';
  String role = 'Recruteur';
  String email = '';
  String phone = '';
  String location = '';
  String profession = '';
  String dateNaissance = '';
  String prenom = '';
  String nom = '';
  int missionsPubliees = 0;
  String note = '0.0/5';
  String photoUrl = '';
  bool _isEntreprise = false;
  String nomEntreprise = '';
  String secteurActivite = '';
  String emailEntreprise = '';
  String siteWeb = '';

  @override
  void initState() {
    super.initState();
    _loadProfil();
  }

  Future<void> _loadProfil() async {
    try {
      final storedName = await TokenService.getUserName();
      if (storedName != null && storedName.isNotEmpty) {
        fullName = storedName;
      }

      final profil = await ProfileService.getMonProfil();
      final data = profil['data'] as Map<String, dynamic>?;
      if (data != null) {
        final type = (data['typeRecruteur'] ?? '').toString().toUpperCase().trim();
        _isEntreprise = type == 'ENTREPRISE';

        final p = data['prenom']?.toString();
        final n = data['nom']?.toString();
        prenom = (p ?? '').trim();
        nom = (n ?? '').trim();
        final combined = [prenom, nom].where((e) => (e).toString().trim().isNotEmpty).join(' ').trim();
        if (_isEntreprise) {
          nomEntreprise = data['nomEntreprise']?.toString() ?? nomEntreprise;
          if ((nomEntreprise).trim().isNotEmpty) {
            fullName = nomEntreprise;
            role = 'Entreprise';
          } else if (combined.isNotEmpty) {
            fullName = combined;
          }
        } else {
          if (combined.isNotEmpty) fullName = combined;
          role = 'Recruteur';
        }

        // Photo (urlPhoto ou photo Map)
        final rawPhoto = data['photo'] ?? data['urlPhoto'];
        String tempPhoto = '';
        if (rawPhoto is Map) {
          tempPhoto = (rawPhoto['url'] ?? rawPhoto['path'] ?? rawPhoto['value'] ?? '').toString();
        } else if (rawPhoto != null) {
          tempPhoto = rawPhoto.toString();
        }
        final converted = _convertPhotoPathToUrl(tempPhoto);
        photoUrl = _isEntreprise ? '' : (converted ?? tempPhoto);

        emailEntreprise = data['emailEntreprise']?.toString() ?? emailEntreprise;
        siteWeb = data['siteWeb']?.toString() ?? siteWeb;
        secteurActivite = data['secteurActivite']?.toString() ?? secteurActivite;

        email = _isEntreprise
            ? (emailEntreprise.isNotEmpty ? emailEntreprise : (data['email'] ?? data['userEmail'])?.toString() ?? email)
            : (data['email'] ?? data['userEmail'])?.toString() ?? email;
        phone = (data['telephone'] ?? data['userPhone'])?.toString() ?? phone;
        location = data['adresse']?.toString() ?? location;

        // dateNaissance backend yyyy-MM-dd -> dd/MM/yyyy
        final dob = data['dateNaissance']?.toString();
        if (dob != null && dob.contains('-')) {
          final parts = dob.split('-');
          if (parts.length == 3) {
            dateNaissance = '${parts[2].padLeft(2, '0')}/${parts[1].padLeft(2, '0')}/${parts[0]}';
          } else {
            dateNaissance = dob;
          }
        } else {
          dateNaissance = dob ?? dateNaissance;
        }
        if (!_isEntreprise) {
          profession = data['profession']?.toString() ?? profession;
        }
      }

      // Statistiques
      try {
        final missionsResponse = await UserService.getMesMissions();
        if (missionsResponse.success) {
          missionsPubliees = missionsResponse.data.length;
        }
      } catch (_) {}
      try {
        final notationResponse = await UserService.getMoyenneNotation();
        if (notationResponse.success && notationResponse.data != null) {
          final moyenne = notationResponse.data!.moyenne;
          note = "${moyenne.toStringAsFixed(1)}/5";
        } else {
          note = "0.0/5";
        }
      } catch (_) {
        note = "0.0/5";
      }
    } catch (_) {
      // ignorer erreurs et conserver défauts
    } finally {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double headerHeight = screenHeight * 0.33;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bodyBackgroundColor,
      drawer: CustomDrawerRecruteur(
        userName: fullName,
        userProfile: 'Mon Profil',
      ),
      body: Stack(
        children: [
          // Header identique à home_recruteur.dart
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, headerHeight),
          ),

          // Corps avec arrondi, positionné pour chevaucher le header
          Positioned(
            top: headerHeight - 40,
            left: 0,
            right: 0,
            bottom: 80,
            child: Container(
              decoration: const BoxDecoration(
                color: bodyBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
              ),
              width: screenWidth,
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.05,
                  22.0,
                  screenWidth * 0.05,
                  20.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Informations personnelles'),
                      const SizedBox(height: 8),
                      _buildPersonalInfoCard(),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Statistiques de missions'),
                      const SizedBox(height: 8),
                      _buildStatsCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Barre de navigation inférieure
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBarRecruteur(
              initialIndex: _selectedIndex,
              onItemSelected: (index) {
                if (index == _selectedIndex) return;
                if (index == 0) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeRecruteurScreen()),
                  );
                  return;
                }
                if (index == 1) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MissionsRecruteurScreen()),
                  );
                  return;
                }
                if (index == 3) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MessageConversationScreen()),
                  );
                  return;
                }
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // Header adapté à la maquette du profil
  Widget _buildHeader(BuildContext context, double height) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/header_home.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Ligne supérieure: flèche retour et titre centré
          Positioned(
            top: 16,
            left: 12,
            right: 12,
            child: SafeArea(
              bottom: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        final navigator = Navigator.of(context);
                        if (navigator.canPop()) {
                          navigator.pop();
                        } else {
                          navigator.pushReplacement(
                            MaterialPageRoute(builder: (context) => const HomeRecruteurScreen()),
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Mon Profil',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
          // Avatar centré + nom + rôle (toujours un avatar; pas d'édition si Entreprise)
          Positioned(
            top: height * 0.28,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    if (_isEntreprise)
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : const AssetImage('') as ImageProvider,
                      ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) => ModifierProfilRecruteurScreen(
                                      initialEmail: email,
                                      initialPhone: phone,
                                      initialLocation: location,
                                      initialProfession: profession,
                                      initialDateNaissance: dateNaissance,
                                      fullName: fullName,
                                      role: role,
                                      initialPhotoUrl: photoUrl,
                                      initialEmailEntreprise: _isEntreprise ? emailEntreprise : null,
                                      initialSecteurActivite: _isEntreprise ? secteurActivite : null,
                                      initialSiteWeb: _isEntreprise ? siteWeb : null,
                                      initialPrenom: !_isEntreprise ? prenom : null,
                                      initialNom: !_isEntreprise ? nom : null,
                                      initialNomEntreprise: _isEntreprise ? nomEntreprise : null,
                                    ),
                                  ),
                                )
                                .then((result) {
                              if (!mounted) return;
                              if (result is Map<String, dynamic>) {
                                String? newFullName;
                                setState(() {
                                  // Commun
                                  email = result['email']?.toString() ?? email;
                                  phone = result['telephone']?.toString() ?? phone;
                                  location = result['adresse']?.toString() ?? location;
                                  final p = result['photoUrl']?.toString() ?? '';
                                  if (p.isNotEmpty) photoUrl = p;

                                  // Type
                                  final type = (result['typeRecruteur']?.toString() ?? '').toUpperCase();
                                  _isEntreprise = type == 'ENTREPRISE' ? true : _isEntreprise;

                                  if (_isEntreprise) {
                                    emailEntreprise = result['emailEntreprise']?.toString() ?? emailEntreprise;
                                    secteurActivite = result['secteurActivite']?.toString() ?? secteurActivite;
                                    siteWeb = result['siteWeb']?.toString() ?? siteWeb;
                                    nomEntreprise = result['nomEntreprise']?.toString() ?? nomEntreprise;
                                    if (nomEntreprise.trim().isNotEmpty) {
                                      fullName = nomEntreprise;
                                      newFullName = fullName;
                                      role = 'Entreprise';
                                    }
                                  } else {
                                    prenom = result['prenom']?.toString() ?? prenom;
                                    nom = result['nom']?.toString() ?? nom;
                                    profession = result['profession']?.toString() ?? profession;
                                    dateNaissance = result['dateNaissance']?.toString() ?? dateNaissance;
                                    final combined = [prenom, nom].where((e) => e.trim().isNotEmpty).join(' ').trim();
                                    if (combined.isNotEmpty) {
                                      fullName = combined;
                                      newFullName = fullName;
                                    }
                                    role = 'Recruteur';
                                  }
                                });
                                if (newFullName != null && newFullName!.trim().isNotEmpty) {
                                  TokenService.saveUserName(newFullName!);
                                }
                              }
                            });
                          },
                          child: const Center(
                            child: Icon(Icons.edit, size: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  fullName.isNotEmpty ? fullName : 'Mon Profil',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  role,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    if (_isEntreprise) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoTile(
            icon: Icons.email_outlined,
            label: 'Email Entreprise',
            value: emailEntreprise.isNotEmpty ? emailEntreprise : email,
            tileColor: Colors.white,
            iconBg: orangeBrand.withOpacity(0.12),
            iconColor: orangeBrand,
          ),
          const SizedBox(height: 10),
          _infoTile(
            icon: Icons.call_outlined,
            label: 'Téléphone',
            value: phone,
            tileColor: Colors.white,
            iconBg: orangeBrand.withOpacity(0.12),
            iconColor: orangeBrand,
          ),
          const SizedBox(height: 10),
          _infoTile(
            icon: Icons.location_on_outlined,
            label: 'Adresse',
            value: location,
            tileColor: Colors.white,
            iconBg: orangeBrand.withOpacity(0.12),
            iconColor: orangeBrand,
          ),
          const SizedBox(height: 10),
          _infoTile(
            icon: Icons.apartment_outlined,
            label: "Secteur d'activité",
            value: secteurActivite,
            tileColor: Colors.white,
            iconBg: orangeBrand.withOpacity(0.12),
            iconColor: orangeBrand,
          ),
          const SizedBox(height: 10),
          _infoTile(
            icon: Icons.public_outlined,
            label: 'Site Web',
            value: siteWeb,
            tileColor: Colors.white,
            iconBg: orangeBrand.withOpacity(0.12),
            iconColor: orangeBrand,
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTile(
          icon: Icons.email_outlined,
          label: 'Email',
          value: email,
          tileColor: Colors.white,
          iconBg: orangeBrand.withOpacity(0.12),
          iconColor: orangeBrand,
        ),
        const SizedBox(height: 10),
        _infoTile(
          icon: Icons.call_outlined,
          label: 'Téléphone',
          value: phone,
          tileColor: Colors.white,
          iconBg: orangeBrand.withOpacity(0.12),
          iconColor: orangeBrand,
        ),
        const SizedBox(height: 10),
        _infoTile(
          icon: Icons.location_on_outlined,
          label: 'Localisation',
          value: location,
          tileColor: Colors.white,
          iconBg: orangeBrand.withOpacity(0.12),
          iconColor: orangeBrand,
        ),
        const SizedBox(height: 10),
        _infoTile(
          icon: Icons.work_outline,
          label: 'Profession',
          value: profession,
          tileColor: Colors.white,
          iconBg: orangeBrand.withOpacity(0.12),
          iconColor: orangeBrand,
        ),
        const SizedBox(height: 10),
        _infoTile(
          icon: Icons.calendar_today_outlined,
          label: 'Date de naissance',
          value: dateNaissance,
          tileColor: Colors.white,
          iconBg: orangeBrand.withOpacity(0.12),
          iconColor: orangeBrand,
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _statTile('Missions Publier', missionsPubliees.toString()),
          _divider(),
          _statTile('Notes des jeunes', note),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: const Color(0xFFEAEAEA),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
    bool multiLine = false,
    Color? tileColor,
    Color? iconBg,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: tileColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg ?? const Color(0xFFD9D9D9).withOpacity(0.0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor ?? orangeBrand),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Convertit un chemin local (ex: C:\\...\\uploads\\...) en URL HTTP complète
  String? _convertPhotoPathToUrl(String? photoPath) {
    if (photoPath == null || photoPath.isEmpty) return null;
    if (photoPath.startsWith('http://') || photoPath.startsWith('https://')) {
      return photoPath;
    }
    if (photoPath.contains('uploads')) {
      String base = ApiConfig.baseUrl;
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      final uploadsIndex = photoPath.indexOf('uploads');
      if (uploadsIndex != -1) {
        String relativePath = photoPath.substring(uploadsIndex + 'uploads'.length);
        relativePath = relativePath.replaceAll('\\', '/');
        if (!relativePath.startsWith('/')) {
          relativePath = '/$relativePath';
        }
        final url = '$base/uploads$relativePath';
        return url;
      }
    }
    if (photoPath.startsWith('uploads')) {
      String base = ApiConfig.baseUrl;
      if (base.endsWith('/')) base = base.substring(0, base.length - 1);
      String url = '$base/$photoPath';
      url = url.replaceAll('\\', '/');
      return url;
    }
    return null;
  }
}

