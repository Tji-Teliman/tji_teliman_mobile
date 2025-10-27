import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_header.dart';

class SignalerCandidatPlaceholder extends StatelessWidget {
  const SignalerCandidatPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(title: 'Signaler Candidat'),
      body: Center(
        child: Text('Signaler candidat - à implémenter', style: GoogleFonts.poppins()),
      ),
    );
  }
}


