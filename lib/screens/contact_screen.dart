import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ScrollController _scrollController = ScrollController();

  static const _contactItems = <_ContactInfo>[
    _ContactInfo(
      label: 'Phone',
      value: '+92 301 8838137',
      subtitle: 'Available 9:00 AM – 10:00 PM (PKT)',
      icon: Icons.phone_android,
    ),
    _ContactInfo(
      label: 'Email',
      value: 'info@cratercode.com',
      subtitle: 'Feel free to reach out anytime',
      icon: Icons.alternate_email,
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        scrollController: _scrollController,
        activeItem: 'Contact Us',
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF6F8FC), Color(0xFFE9EFF9)],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(textTheme),
                  const SizedBox(height: 36),
                  _buildContactCards(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let\'s stay in touch',
          style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF24395A),
              ) ??
              const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Color(0xFF24395A),
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Reach out via phone or email for collaboration, enrollment questions, or anything else you need.',
          style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF4B5D7A),
                height: 1.5,
              ) ??
              const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B5D7A),
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _buildContactCards(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: _contactItems
          .map(
            (item) => _ContactCard(
              info: item,
              width: MediaQuery.of(context).size.width < 720 ? double.infinity : 390,
            ),
          )
          .toList(),
    );
  }
}

class _ContactInfo {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;

  const _ContactInfo({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
  });
}

class _ContactCard extends StatelessWidget {
  final _ContactInfo info;
  final double width;

  const _ContactCard({
    required this.info,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF2F5DA8).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(info.icon, color: const Color(0xFF2F5DA8), size: 26),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF24395A),
                            fontWeight: FontWeight.w700,
                          ) ??
                          const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF24395A),
                          ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      info.value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF2F5DA8),
                            fontWeight: FontWeight.w600,
                          ) ??
                          const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2F5DA8),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      info.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF4B5D7A),
                            height: 1.5,
                          ) ??
                          const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF4B5D7A),
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
