import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'courses_screen.dart';

// Support Feature model
class _SupportFeature {
  final String title;
  final String description;
  final IconData icon;

  const _SupportFeature({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _CourseHighlightConfig {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  const _CourseHighlightConfig({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}

const List<_CourseHighlightConfig> _courseHighlightConfigs = [
  _CourseHighlightConfig(
    title: 'Web Development',
    description: 'Craft responsive web experiences using modern frameworks and tooling.',
    icon: Icons.web,
    gradient: [Color(0xFF4F6ED8), Color(0xFF2F4D7D)],
  ),
  _CourseHighlightConfig(
    title: 'App Development',
    description: 'Build cross-platform mobile apps with beautiful UI and smooth performance.',
    icon: Icons.phone_android,
    gradient: [Color(0xFF56C1FF), Color(0xFF2F86D7)],
  ),
  _CourseHighlightConfig(
    title: 'AI Development',
    description: 'Create intelligent solutions powered by machine learning and data insights.',
    icon: Icons.psychology,
    gradient: [Color(0xFF8B5CF6), Color(0xFF5B21B6)],
  ),
];

class _CourseHighlightCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  const _CourseHighlightCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ) ??
                const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.6,
                ) ??
                const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}


// Course data model
class Course {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String category;
  final String imageUrl;
  final String duration;
  final String level;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    required this.category,
    this.imageUrl = 'assets/placeholder_course.jpg',
    this.duration = '6 weeks',
    this.level = 'Beginner',
  });
}

// Sample course data - replace with your actual data
final List<Course> courses = [
  // Web Development Courses
  Course(
    id: 'web1',
    title: 'Web Development Fundamentals',
    description: 'Master the basics of web development with HTML, CSS, and JavaScript',
    technologies: ['HTML', 'CSS', 'JavaScript'],
    category: 'Web Development',
  ),
  Course(
    id: 'web2',
    title: 'Frontend with React.js',
    description: 'Build modern web applications using React.js and related technologies',
    technologies: ['React.js', 'Node.js', 'MySQL'],
    category: 'Web Development',
  ),
  Course(
    id: 'web3',
    title: 'MERN Stack Mastery',
    description: 'Full-stack development with MongoDB, Express, React, and Node.js',
    technologies: ['MongoDB', 'Express.js', 'React.js', 'Node.js'],
    category: 'Web Development',
  ),
  
  // App Development Courses
  Course(
    id: 'app1',
    title: 'Flutter Mobile Development',
    description: 'Build beautiful native apps for iOS and Android with Flutter',
    technologies: ['Flutter', 'Dart', 'Firebase'],
    category: 'App Development',
  ),
  Course(
    id: 'app2',
    title: 'React Native Mastery',
    description: 'Create cross-platform mobile apps with React Native',
    technologies: ['React Native', 'JavaScript', 'Redux'],
    category: 'App Development',
  ),
  
  // AI/ML Courses
  Course(
    id: 'ai1',
    title: 'Machine Learning Fundamentals',
    description: 'Introduction to machine learning concepts and algorithms',
    technologies: ['Python', 'TensorFlow', 'scikit-learn'],
    category: 'AI/ML',
  ),
  Course(
    id: 'ai2',
    title: 'Deep Learning Specialization',
    description: 'Advanced deep learning techniques and neural networks',
    technologies: ['Python', 'PyTorch', 'Keras'],
    category: 'AI/ML',
  ),
];

// Course data model
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  static const List<String> _highlights = [
    'Personalized mentorship & accountability',
    'Industry-grade projects and reviews',
    'Career prep with mock interviews',
    'Supportive global community',
  ];
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildCoursesSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720;
        final cardWidth = isCompact ? double.infinity : (constraints.maxWidth - 48) / 3;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Courses That We Offer',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F3558),
                  ) ??
                  const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F3558),
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 640,
              child: Text(
                'Level up your skills with our curated learning paths designed for modern tech careers.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF4B5D7A),
                      height: 1.6,
                    ) ??
                    const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5D7A),
                      height: 1.6,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 24,
              children: _courseHighlightConfigs.map((config) {
                final width = isCompact ? double.infinity : cardWidth;
                return SizedBox(
                  width: width,
                  child: _CourseHighlightCard(
                    title: config.title,
                    description: config.description,
                    icon: config.icon,
                    gradient: config.gradient,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CoursesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F5DA8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Course Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(scrollController: _scrollController),
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 720;
          final horizontalPadding = isCompact ? 20.0 : 48.0;
          final verticalPadding = isCompact ? 36.0 : 64.0;
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
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Code. Build. Become.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontSize: isCompact ? 40 : 64,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF24395A),
                          letterSpacing: 0.5,
                          height: 1.1,
                        ) ??
                        TextStyle(
                          fontSize: isCompact ? 40 : 64,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF24395A),
                          letterSpacing: 0.5,
                          height: 1.1,
                        ),
                  ),
                  const SizedBox(height: 40),

                  // Courses Section
                  _buildCoursesSection(),
                  const SizedBox(height: 64),

                  // Support Section
                  const _SupportSection(),
                  const SizedBox(height: 80),
                  _buildCallToActionSection(context),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
    Widget _buildCallToActionSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Ready to Join?',
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CoursesScreen(),
                  ),
                );
              },
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
                'Apply Now',
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
          "Next session starts soon. Don't wait.",
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
                      '2025 Crater Code. Code. Build. Become.',
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
                        '2025 Crater Code. Code. Build. Become.',
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
              'lib/assets/logo.png',
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
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                feature.icon,
                color: const Color(0xFF3A5BA0),
                size: 24,
              ),
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

