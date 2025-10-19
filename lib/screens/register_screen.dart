import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? selectedRole;
  final List<String> roles = ['Client', 'Prestataire'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top zigzag header
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopZigzagHeader(),
          ),

          // Bottom zigzag footer (more pronounced)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomZigzagFooter(),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  // Push content slightly up to overlap the wave seam like the mock
                  const SizedBox(height: 8),

                  // Logo circle overlapping the top header
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo_TJI_TELIMAN.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Créer mon Compte',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Card with form content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // First and Last name row
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                hint: 'Nom',
                                controller: firstNameController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                hint: 'Prenom',
                                controller: lastNameController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(hint: 'Genre', controller: genderController),
                        const SizedBox(height: 12),
                        _buildTextField(hint: 'Email (facultatif)', controller: emailController),
                        const SizedBox(height: 12),
                        _buildTextField(hint: 'Telephone', controller: phoneController, keyboardType: TextInputType.phone),
                        const SizedBox(height: 12),

                        // Role dropdown
                        _buildDropdown(),
                        const SizedBox(height: 12),

                        _buildTextField(hint: 'Mot de Pase', controller: passwordController, obscure: true),
                        const SizedBox(height: 12),
                        _buildTextField(hint: 'Confirmez Mot de Passe', controller: confirmPasswordController, obscure: true),
                        const SizedBox(height: 16),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF22C55E)],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    "S'inscrire",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Footer link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Vous avez un compte ? ',
                              style: GoogleFonts.inter(color: Colors.black87),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                'Connectez-vous ici',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF2563EB),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hint, TextEditingController? controller, bool obscure = false, TextInputType? keyboardType}) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          hint: Text('Role', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          onChanged: (value) => setState(() => selectedRole = value),
          items: roles
              .map((r) => DropdownMenuItem(
                    value: r,
                    child: Text(r, style: GoogleFonts.inter(color: Colors.black87, fontSize: 13)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _TopZigzagHeader extends StatelessWidget {
  const _TopZigzagHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Stack(
        children: [
          // Gradient background block (rounded top corners not required; device already rounded)
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2563EB), Color(0xFF22C55E)],
              ),
            ),
          ),
          // White main wave (over gradient)
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 76),
              painter: _WhiteWavePainter(),
            ),
          ),
          // Light blue secondary wave just under white wave
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 64),
              painter: _BlueWavePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;

    path.moveTo(0, h * 0.7);
    path.cubicTo(w * 0.15, h * 0.15, w * 0.35, h * 1.10, w * 0.55, h * 0.55);
    path.cubicTo(w * 0.8, h * 0.0, w * 0.9, h * 0.95, w, h * 0.55);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    canvas.drawPath(path, paint);

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.07)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path.shift(const Offset(0, 1.5)), shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BlueWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final Paint paint = Paint()
      ..color = const Color(0xFFD6E6FF)
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;

    path.moveTo(0, h * 0.75);
    path.cubicTo(w * 0.2, h * 0.15, w * 0.4, h * 1.05, w * 0.6, h * 0.6);
    path.cubicTo(w * 0.8, h * 0.05, w * 0.95, h * 0.95, w, h * 0.6);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomZigzagFooter extends StatelessWidget {
  const _BottomZigzagFooter();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          // Green gradient background strip at very bottom
          Positioned.fill(
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFF0EA56B), Color(0xFF34D399)],
                ),
              ),
            ),
          ),
          // Blue accent wave (lower layer)
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 90),
              painter: _BottomBlueWavePainter(),
            ),
          ),
          // White wave above blue to create layered overlap like mock
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(double.infinity, 110),
              painter: _BottomWhiteWavePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomWhiteWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;

    path.moveTo(0, h * 0.15);
    path.cubicTo(w * 0.12, h * 0.65, w * 0.35, h * 0.20, w * 0.55, h * 0.55);
    path.cubicTo(w * 0.8, h * 0.95, w * 0.95, h * 0.35, w, h * 0.6);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    canvas.drawPath(path, paint);

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path.shift(const Offset(0, 2)), shadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BottomBlueWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final Paint paint = Paint()
      ..color = const Color(0xFFD6E6FF)
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;

    path.moveTo(0, h * 0.05);
    path.cubicTo(w * 0.18, h * 0.45, w * 0.4, h * 0.05, w * 0.6, h * 0.45);
    path.cubicTo(w * 0.82, h * 0.85, w * 0.95, h * 0.25, w, h * 0.5);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
