import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 720;
          final horizontalPadding = isCompact ? 20.0 : 48.0;
          final verticalPadding = isCompact ? 36.0 : 64.0;
          final availableWidth = constraints.maxWidth;
          final contentWidth = availableWidth - (horizontalPadding * 2);
          final safeContentWidth = contentWidth > 0 ? contentWidth : availableWidth;
          final heroTextWidth = safeContentWidth < 680 ? safeContentWidth : 680.0;

          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF6F8FC),
                  Color(0xFFE9EFF9),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 30,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      'lib/assets/logo.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const FlutterLogo(),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'Code. Build. Become.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF24395A),
                          letterSpacing: 0.5,
                        ) ??
                        const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF24395A),
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: heroTextWidth,
                    child: Text(
                      'From basics to industry-ready. Join ambitious developers who build real projects with elite mentorship.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF4B5D7A),
                            height: 1.5,
                          ) ??
                          const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF4B5D7A),
                            height: 1.5,
                          ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          backgroundColor: const Color(0xFF2F5DA8),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text(
                          'Take Entry Exam',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                          foregroundColor: const Color(0xFF24395A),
                          side: const BorderSide(color: Color(0xFFD3DBE9)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.code),
                        label: const Text(
                          'View Curriculum',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 56),
                  const _StatsRow(
                    metrics: [
                      _StatMetric(title: '240', subtitle: 'Hours of Content'),
                      _StatMetric(title: '5', subtitle: 'Months to Complete'),
                      _StatMetric(title: '1:1', subtitle: 'Mentorship'),
                    ],
                  ),
                  const SizedBox(height: 72),
                  const _CurriculumSection(),
                  const SizedBox(height: 96),
                  const _SupportSection(),
                  const SizedBox(height: 120),
                  const _CtaSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CtaSection extends StatelessWidget {
  const _CtaSection();

  static const List<String> _highlights = [
    'Exclusive entry exam required',
    '240 hours of hands-on learning',
    'Limited seats per cohort',
    'Industry-ready skills in 5 months',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE9EFF8),
            Color(0xFFD7E2F4),
          ],
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 72),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFFCAD8EE)),
            ),
            child: Text(
              'Ready to Transform?',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E4C7C),
                  ) ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E4C7C),
                  ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Join the Elite',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F3558),
                ) ??
                const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F3558),
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 640,
            child: Text(
              'Only dreamers and doers allowed. Prove you have what it takes.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4B5D7A),
                    height: 1.6,
                  ) ??
                  const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5D7A),
                    height: 1.6,
                  ),
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 48,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: _highlights
                .map((item) => _CtaBullet(label: item))
                .toList(growable: false),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  backgroundColor: const Color(0xFF2F4D7D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 6,
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  'Take Entry Exam',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  foregroundColor: const Color(0xFF24395A),
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xFFCAD8EE)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Learn More',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "Next cohort starts soon. Don't wait.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF53688A),
                  letterSpacing: 0.3,
                ) ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF53688A),
                  letterSpacing: 0.3,
                ),
          ),
          const SizedBox(height: 48),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xF2FFFFFF),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFD4DEEE)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 760;
                final detailStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2F4466),
                      letterSpacing: 0.2,
                    ) ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2F4466),
                      letterSpacing: 0.2,
                    );

                final copyrightStyle = detailStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B5D7A),
                );

                if (isCompact) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildFooterBrand(context),
                      const SizedBox(height: 16),
                      Text(
                        'Elite Coding Education',
                        style: detailStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '© 2025 Crater Code. Code. Build. Become.',
                        style: copyrightStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildFooterBrand(context),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Elite Coding Education',
                          style: detailStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '© 2025 Crater Code. Code. Build. Become.',
                          style: copyrightStyle,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterBrand(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF24395A),
        ) ??
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF24395A),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD8E2F2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              'lib/assets/logo.jpg',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const FlutterLogo(size: 32),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Crater Code',
          style: labelStyle,
        ),
      ],
    );
  }
}

class _CtaBullet extends StatelessWidget {
  const _CtaBullet({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xFF3A5BA0),
          size: 22,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F4466),
              ) ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2F4466),
              ),
        ),
      ],
    );
  }
}

class _CurriculumSection extends StatelessWidget {
  const _CurriculumSection();

  static const List<_ModuleData> _modules = [
    _ModuleData(
      number: 1,
      title: 'Frontend Foundations',
      description: 'HTML, CSS, JavaScript fundamentals',
      icon: Icons.terminal,
      skills: ['HTML5', 'CSS3', 'JavaScript ES6+'],
    ),
    _ModuleData(
      number: 2,
      title: 'React Mastery',
      description: 'Modern React patterns & best practices',
      icon: Icons.code,
      skills: ['React', 'Hooks', 'Context', 'Router'],
    ),
    _ModuleData(
      number: 3,
      title: 'Backend & APIs',
      description: 'Build scalable server-side applications',
      icon: Icons.dns,
      skills: ['Node.js', 'Express', 'REST APIs'],
    ),
    _ModuleData(
      number: 4,
      title: 'Databases',
      description: 'Data modeling & database management',
      icon: Icons.storage,
      skills: ['MongoDB', 'PostgreSQL', 'Redis'],
    ),
    _ModuleData(
      number: 5,
      title: 'Full Stack Integration',
      description: 'Connect frontend to backend seamlessly',
      icon: Icons.layers,
      skills: ['Authentication', 'State Management', 'WebSockets'],
    ),
    _ModuleData(
      number: 6,
      title: 'DevOps & Deployment',
      description: 'Ship your applications to production',
      icon: Icons.cloud_upload,
      skills: ['Docker', 'CI/CD', 'AWS', 'Vercel'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Complete Curriculum',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF24395A),
              ) ??
              const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                color: Color(0xFF24395A),
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Structured path from zero to full-stack developer',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF4B5D7A),
                height: 1.5,
              ) ??
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4B5D7A),
                height: 1.5,
              ),
        ),
        const SizedBox(height: 48),
        Wrap(
          spacing: 24,
          runSpacing: 28,
          alignment: WrapAlignment.center,
          children: _modules
              .map((module) => _ModuleCard(data: module))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.data});

  final _ModuleData data;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 320),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFFE3EAF5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _IconBadge(icon: data.icon),
                const Spacer(),
                Text(
                  'Module ${data.number}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8492AF),
                        letterSpacing: 0.5,
                      ) ??
                      const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8492AF),
                        letterSpacing: 0.5,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              data.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF24395A),
                  ) ??
                  const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF24395A),
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              data.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF566685),
                    height: 1.5,
                  ) ??
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF566685),
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.skills
                  .map((skill) => _SkillChip(label: skill))
                  .toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    this.size = 52,
    this.backgroundColor = const Color(0xFFEAF1FB),
    this.iconColor = const Color(0xFF355B94),
  });

  final IconData icon;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: size * 0.5,
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5FB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF355B94),
            ) ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF355B94),
            ),
      ),
    );
  }
}

class _SupportFeature {
  const _SupportFeature({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _SupportSection extends StatelessWidget {
  const _SupportSection();

  static const List<_SupportFeature> _features = [
    _SupportFeature(
      title: "Real-Time Doubt Solving",
      description: "Get instant help when you're stuck. AI + human mentors available 24/7.",
      icon: Icons.chat_bubble_outline,
    ),
    _SupportFeature(
      title: 'AI-Powered Code Reviews',
      description: 'Smart feedback on your code quality, performance, and style.',
      icon: Icons.auto_awesome,
    ),
    _SupportFeature(
      title: 'Exclusive Community',
      description: 'Connect with ambitious peers, collaborate on projects, share knowledge.',
      icon: Icons.groups_outlined,
    ),
    _SupportFeature(
      title: '1:1 Mentorship',
      description: "Personal guidance from industry pros who've built real products.",
      icon: Icons.emoji_people_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "You're Not Alone",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF24395A),
              ) ??
              const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: Color(0xFF24395A),
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Elite support system to accelerate your growth',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF4B5D7A),
                height: 1.5,
              ) ??
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4B5D7A),
                height: 1.5,
              ),
        ),
        const SizedBox(height: 48),
        Wrap(
          spacing: 32,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: _features
              .map((feature) => _SupportCard(feature: feature))
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.feature});

  final _SupportFeature feature;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFDCE5F3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconBadge(
              icon: feature.icon,
              size: 48,
              backgroundColor: const Color(0xFFEFF4FF),
              iconColor: const Color(0xFF3A5BA0),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    feature.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                  const SizedBox(height: 8),
                  Text(
                    feature.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF566685),
                          height: 1.5,
                        ) ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF566685),
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleData {
  const _ModuleData({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.skills,
  });

  final int number;
  final String title;
  final String description;
  final IconData icon;
  final List<String> skills;
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.metrics});

  final List<_StatMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 48,
      runSpacing: 32,
      alignment: WrapAlignment.center,
      children: metrics,
    );
  }
}

class _StatMetric extends StatelessWidget {
  const _StatMetric({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF24395A),
                ) ??
                const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF24395A),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF566685),
                  height: 1.4,
                ) ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF566685),
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }
}
