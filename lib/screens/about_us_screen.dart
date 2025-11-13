import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';

class AboutUsScreen extends StatefulWidget {
  static const routeName = '/about';

  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        scrollController: _scrollController,
        activeItem: 'About Us',
      ),
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 760;
          final horizontalPadding = isCompact ? 20.0 : 48.0;
          final verticalPadding = isCompact ? 36.0 : 64.0;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF6F8FC), Color(0xFFE9EFF9)],
              ),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeroSection(context, isCompact),
                  const SizedBox(height: 48),
                  _buildStatsSection(context, isCompact),
                  const SizedBox(height: 64),
                  _buildMissionSection(context, isCompact),
                  const SizedBox(height: 64),
                  _buildValuesSection(context, isCompact),
                  const SizedBox(height: 64),
                  _buildTeamSection(context, isCompact),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isCompact) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Building the Next Generation of Makers',
          textAlign: TextAlign.center,
          style: textTheme.displaySmall?.copyWith(
                fontSize: isCompact ? 38 : 56,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF24395A),
                height: 1.1,
              ) ??
              TextStyle(
                fontSize: isCompact ? 38 : 56,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF24395A),
                height: 1.1,
              ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: isCompact ? double.infinity : 680,
          child: Text(
            'We are designers, engineers, and mentors obsessed with helping learners transform ideas into polished products. Crater Code is where ambition meets craftsmanship.',
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
                  fontSize: isCompact ? 16 : 18,
                  color: const Color(0xFF4B5D7A),
                  height: 1.6,
                  letterSpacing: 0.2,
                ) ??
                TextStyle(
                  fontSize: isCompact ? 16 : 18,
                  color: const Color(0xFF4B5D7A),
                  height: 1.6,
                  letterSpacing: 0.2,
                ),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFD8E2F2)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2F5DA8).withValues(alpha: 0.08),
                blurRadius: 26,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Text(
            'Code. Build. Become.',
            style: textTheme.titleLarge?.copyWith(
                  fontSize: isCompact ? 18 : 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2F4466),
                  letterSpacing: 0.4,
                ) ??
                TextStyle(
                  fontSize: isCompact ? 18 : 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2F4466),
                  letterSpacing: 0.4,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, bool isCompact) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24,
      runSpacing: 24,
      children: _statMetrics
          .map(
            (metric) => _StatMetricCard(
              metric: metric,
              isCompact: isCompact,
            ),
          )
          .toList(),
    );
  }

  Widget _buildMissionSection(BuildContext context, bool isCompact) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 28 : 44,
        vertical: isCompact ? 36 : 48,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4F6ED8), Color(0xFF2F4D7D)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2F4D7D).withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Mission',
            style: textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ) ??
                const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            'Empower builders to turn raw curiosity into production-ready skill. We combine rigorous learning sprints, human mentorship, and real-world product simulations to help you ship work you would be proud to put your name on.',
            style: textTheme.bodyLarge?.copyWith(
                  fontSize: isCompact ? 16 : 18,
                  color: Colors.white.withValues(alpha: 0.92),
                  height: 1.6,
                ) ??
                TextStyle(
                  fontSize: isCompact ? 16 : 18,
                  color: Colors.white.withValues(alpha: 0.92),
                  height: 1.6,
                ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _missionBullets
                .map(
                  (bullet) => _ColoredChip(label: bullet),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesSection(BuildContext context, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'What We Stand For',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F3558),
              ) ??
              const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F3558),
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: isCompact ? double.infinity : 680,
          child: Text(
            'Our culture is engineered around deep focus, continuous feedback, and a bias for building. These pillars keep every batch aligned and unstoppable.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: isCompact ? 16 : 17,
                  color: const Color(0xFF4B5D7A),
                  height: 1.6,
                ) ??
                TextStyle(
                  fontSize: isCompact ? 16 : 17,
                  color: const Color(0xFF4B5D7A),
                  height: 1.6,
                ),
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 24,
          runSpacing: 24,
          children: _valuePillars
              .map(
                (pillar) => _ValuePillarCard(
                  data: pillar,
                  isCompact: isCompact,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTeamSection(BuildContext context, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'The People Behind the Craft',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F3558),
              ) ??
              const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F3558),
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: isCompact ? double.infinity : 720,
          child: Text(
            'An interdisciplinary crew of engineers, designers, and operators who have shipped products at scale—and now mentor the next wave of builders.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: isCompact ? 16 : 17,
                  color: const Color(0xFF4B5D7A),
                  height: 1.6,
                ) ??
                TextStyle(
                  fontSize: isCompact ? 16 : 17,
                  color: const Color(0xFF4B5D7A),
                  height: 1.6,
                ),
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 24,
          runSpacing: 24,
          children: _teamMembers
              .map(
                (member) => _TeamMemberCard(
                  member: member,
                  isCompact: isCompact,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _StatMetric {
  final String value;
  final String label;
  final String description;

  const _StatMetric({
    required this.value,
    required this.label,
    required this.description,
  });
}

const List<_StatMetric> _statMetrics = [
  _StatMetric(
    value: '500+',
    label: 'Builders Trained',
    description: 'From first line of code to production deployment.',
  ),
  _StatMetric(
    value: '65%',
    label: 'Career Transitions',
    description: 'Graduates who landed new roles within 3 months.',
  ),
  _StatMetric(
    value: '120+',
    label: 'Partner Companies',
    description: 'Startups and scaleups hiring from Crater Code.',
  ),
];

class _StatMetricCard extends StatelessWidget {
  const _StatMetricCard({required this.metric, required this.isCompact});

  final _StatMetric metric;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: isCompact ? double.infinity : 240,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCE5F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.value,
            style: textTheme.displaySmall?.copyWith(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2F4466),
                ) ??
                const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2F4466),
                ),
          ),
          const SizedBox(height: 12),
          Text(
            metric.label,
            style: textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF24395A),
                ) ??
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF24395A),
                ),
          ),
          const SizedBox(height: 12),
          Text(
            metric.description,
            style: textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: const Color(0xFF5A6D8A),
                  height: 1.5,
                ) ??
                const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5A6D8A),
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

const List<String> _missionBullets = [
  'Hands-on product simulations',
  'Elite mentor network',
  'Human + AI feedback loops',
  'Portfolio-first learning',
];

class _ColoredChip extends StatelessWidget {
  const _ColoredChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ) ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
      ),
    );
  }
}

class _ValuePillarData {
  final IconData icon;
  final String title;
  final String description;

  const _ValuePillarData({
    required this.icon,
    required this.title,
    required this.description,
  });
}

const List<_ValuePillarData> _valuePillars = [
  _ValuePillarData(
    icon: Icons.auto_fix_high,
    title: 'Craftsmanship',
    description: 'We sweat the tiny details so you can ship experiences that feel effortless to users.',
  ),
  _ValuePillarData(
    icon: Icons.bolt,
    title: 'Momentum',
    description: 'Every sprint sharpens decision-making, collaboration, and delivery speed.',
  ),
  _ValuePillarData(
    icon: Icons.lock_clock,
    title: 'Accountability',
    description: 'You have mentors, peers, and rituals built to keep your goals on track.',
  ),
];

class _ValuePillarCard extends StatelessWidget {
  const _ValuePillarCard({required this.data, required this.isCompact});

  final _ValuePillarData data;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: isCompact ? double.infinity : 280,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCE5F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              data.icon,
              color: const Color(0xFF3A5BA0),
              size: 26,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            data.title,
            style: textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF24395A),
                ) ??
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF24395A),
                ),
          ),
          const SizedBox(height: 12),
          Text(
            data.description,
            style: textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: const Color(0xFF5A6D8A),
                  height: 1.6,
                ) ??
                const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5A6D8A),
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

class _TeamMember {
  final String name;
  final String role;
  final String bio;

  const _TeamMember({
    required this.name,
    required this.role,
    required this.bio,
  });
}

const List<_TeamMember> _teamMembers = [
  _TeamMember(
    name: 'Aarav Sharma',
    role: 'Founder & CEO',
    bio: 'Ex-product engineer at multiple YC startups. Leads curriculum vision and product strategy.',
  ),
  _TeamMember(
    name: 'Mira Kapoor',
    role: 'Head of Learning',
    bio: 'Instructional designer who has built academies for top tech companies and universities.',
  ),
  _TeamMember(
    name: 'Rohan Iyer',
    role: 'Lead Mentor',
    bio: 'Full-stack specialist who has shipped apps to millions of users across fintech and health.',
  ),
];

class _TeamMemberCard extends StatelessWidget {
  const _TeamMemberCard({required this.member, required this.isCompact});

  final _TeamMember member;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: isCompact ? double.infinity : 280,
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDCE5F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF56C1FF), Color(0xFF2F86D7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2F86D7).withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Center(
              child: Text(
                member.name.characters.first,
                style: textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ) ??
                    const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            member.name,
            style: textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF24395A),
                ) ??
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF24395A),
                ),
          ),
          const SizedBox(height: 6),
          Text(
            member.role,
            style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2F5DA8),
                  letterSpacing: 0.2,
                ) ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F5DA8),
                  letterSpacing: 0.2,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            member.bio,
            style: textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: const Color(0xFF5A6D8A),
                  height: 1.6,
                ) ??
                const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5A6D8A),
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}
