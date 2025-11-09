import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/custom_app_bar.dart';
import 'courses_screen.dart';

// Course data model
class Course {
  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String category;
  final String imageUrl;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    required this.category,
    this.imageUrl = 'assets/placeholder_course.jpg',
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
          final availableWidth = constraints.maxWidth;
          final contentWidth = availableWidth - (horizontalPadding * 2);
          final safeContentWidth = contentWidth > 0 ? contentWidth : availableWidth;
          final heroTextWidth = safeContentWidth < 680 ? safeContentWidth : 680.0;

          // Group courses by category
          final categories = {
            'Web Development': courses.where((c) => c.category == 'Web Development').toList(),
            'App Development': courses.where((c) => c.category == 'App Development').toList(),
            'AI/ML': courses.where((c) => c.category == 'AI/ML').toList(),
          };

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
                  const SizedBox(height: 80),
                  
                  // Quote Section
                  const Text(
                    'Empower the Next Generation of Tech Leaders',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F3558),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: heroTextWidth,
                    child: Text(
                      'Our mission is to provide world-class education that transforms lives and shapes the future of technology. Join us on this journey to excellence.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: isCompact ? 16 : 18,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF4B5D7A),
                            height: 1.6,
                          ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  
                  // Courses Section
                  _buildCoursesSection(isCompact),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CoursesScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F4D7D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Explore All Courses',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  
                  // Why Choose Us Section
                  _buildWhyChooseUsSection(isCompact),
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

  // Helper method to get category color
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Web Development':
        return const Color(0xFF4A6BFF);
      case 'App Development':
        return const Color(0xFF00C4CC);
      case 'AI/ML':
        return const Color(0xFFFF6B6B);
      default:
        return const Color(0xFF4A6BFF);
    }
  }

  // Build course card widget
  Widget _buildCourseCard(Course course, BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      position: courses.indexOf(course),
      columnCount: 3,
      duration: const Duration(milliseconds: 600),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getCategoryColor(course.category).withValues(alpha: 0.1),
                    _getCategoryColor(course.category).withValues(alpha: 0.05),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(course.category).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          course.category,
                          style: TextStyle(
                            color: _getCategoryColor(course.category),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF24395A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4B5D7A),
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: course.technologies
                            .map(
                              (tech) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  tech,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF4B5D7A),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to course details
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getCategoryColor(course.category),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Learn More'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build Why Choose Us Section
  Widget _buildWhyChooseUsSection(bool isCompact) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A6BFF),
            Color(0xFF00C4CC),
          ],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Why Choose Our Courses?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isCompact ? 1 : 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            children: [
              _buildFeatureCard(
                icon: Icons.school,
                title: 'Expert Instructors',
                description: 'Learn from industry professionals with years of experience',
              ),
              _buildFeatureCard(
                icon: Icons.code,
                title: 'Hands-on Projects',
                description: 'Build real-world projects to enhance your portfolio',
              ),
              _buildFeatureCard(
                icon: Icons.people,
                title: 'Community Support',
                description: 'Join a community of like-minded learners and grow together',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToActionSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
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
                      ' 2025 Crater Code. Code. Build. Become.',
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
                        ' 2025 Crater Code. Code. Build. Become.',
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

  Widget _buildCoursesSection(bool isCompact) {
    // Get one course from each category
    final webCourse = courses.firstWhere((c) => c.category == 'Web Development');
    final appCourse = courses.firstWhere((c) => c.category == 'App Development');
    final aiCourse = courses.firstWhere((c) => c.category == 'AI/ML');

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width and adjust card width accordingly
        final availableWidth = constraints.maxWidth;
        final padding = 24.0; // Horizontal padding
        final spacing = 24.0; // Space between cards
        final maxCardWidth = 360.0; // Maximum width for each card
        
        // Calculate card width based on available space
        double cardWidth = (availableWidth - 2 * padding - 2 * spacing) / 3;
        cardWidth = cardWidth.clamp(280.0, maxCardWidth);
        
        // Calculate total width needed for all cards
        final totalWidth = (cardWidth * 3) + (spacing * 2);
        
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            width: totalWidth,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _buildCourseCard(webCourse, context),
                ),
                SizedBox(width: spacing),
                SizedBox(
                  width: cardWidth,
                  child: _buildCourseCard(appCourse, context),
                ),
                SizedBox(width: spacing),
                SizedBox(
                  width: cardWidth,
                  child: _buildCourseCard(aiCourse, context),
                ),
              ],
            ),
          ),
        );
      },
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
