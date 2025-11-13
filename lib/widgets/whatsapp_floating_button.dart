import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppFloatingButton extends StatelessWidget {
  const WhatsAppFloatingButton({super.key});

  static final Uri _whatsAppUri = Uri.parse(
    'https://wa.me/923018838137?text=Hey%20there!',
  );

  Future<void> _openWhatsApp(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    try {
      final launched = await launchUrl(
        _whatsAppUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        scaffoldMessenger?.showSnackBar(
          const SnackBar(
            content: Text('Could not open WhatsApp.'),
          ),
        );
      }
    } catch (error) {
      scaffoldMessenger?.showSnackBar(
        const SnackBar(
          content: Text('Could not open WhatsApp.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FloatingActionButton(
            heroTag: 'whatsapp_fab',
            backgroundColor: const Color(0xFF25D366),
            onPressed: () => _openWhatsApp(context),
            child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
