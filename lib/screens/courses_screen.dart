import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/custom_app_bar.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      if (!courseProvider.hasLoadedFromApi && !courseProvider.isLoading) {
        courseProvider.fetchCourses();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(scrollController: _scrollController),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, _) {
          final courses = courseProvider.courses;

          if (courseProvider.isLoading && courses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
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
                  child: Column(
                    children: [
                      const Text(
                        'Master In-Demand Tech Skills',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF24395A),
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 600,
                        child: Text(
                          'Join our comprehensive courses and transform your career with hands-on projects and expert mentorship',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4B5D7A),
                                height: 1.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                if (courseProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: _buildErrorBanner(context, courseProvider),
                  ),

                if (courses.isEmpty && courseProvider.errorMessage == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: _buildEmptyState(context, courseProvider),
                  )
                else if (courses.isNotEmpty) ...[
                  ..._buildCategoriesSection(context, courses),
                  const SizedBox(height: 40),
                  _buildLearningJourneySection(context),
                  const SizedBox(height: 60),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCategoriesSection(BuildContext context, List<Course> courses) {
    final Map<String, List<Course>> categories = {};

    for (final course in courses) {
      final categoryName = course.category.isNotEmpty ? course.category : 'Other';
      categories.putIfAbsent(categoryName, () => []).add(course);
    }

    return categories.entries.map((entry) {
      final categoryName = entry.key;
      final categoryCourses = entry.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 6,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(categoryName),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  categoryName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF24395A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.5,
              ),
              itemCount: categoryCourses.length,
              itemBuilder: (context, index) {
                final course = categoryCourses[index];
                return _buildCourseCard(course, context, courses);
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildCourseCard(Course course, BuildContext context, List<Course> allCourses) {
    return AnimationConfiguration.staggeredGrid(
      position: allCourses.indexOf(course),
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
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F3558),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: course.technologies
                            .map((tech) => _buildTechChip(tech, context))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.schedule,
                        course.duration,
                        context,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.school,
                        course.level,
                        context,
                      ),
                      const Spacer(),
                      _buildLearnMoreButton(course),
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

  Widget _buildLearnMoreButton(Course course) {
    final accentColor = _getCategoryColor(course.category);

    return OutlinedButton.icon(
      onPressed: () => _showCourseDetails(course),
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        side: BorderSide(color: accentColor.withOpacity(0.7)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      icon: const Icon(Icons.arrow_outward_rounded, size: 18),
      label: const Text(
        'Learn More',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showCourseDetails(Course course) {
    showDialog(
      context: context,
      builder: (context) {
        final accentColor = _getCategoryColor(course.category);

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            course.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF24395A),
            ),
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4B5D7A),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: course.technologies
                      .map((tech) => _buildTechChip(tech, context))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildInfoChip(Icons.schedule, course.duration, context),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.school, course.level, context),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF4B5D7A),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLearningJourneySection(BuildContext context) {
    final steps = [
      (
        icon: Icons.auto_graph,
        title: 'Career-Focused Roadmaps',
        body: 'Follow curated paths for development, data, and AI roles with weekly milestones and resources.',
        color: const Color(0xFF4A6BFF),
      ),
      (
        icon: Icons.groups,
        title: 'Mentor Guidance',
        body: 'Attend live mentor hours, portfolio reviews, and Q&A sessions to stay on track.',
        color: const Color(0xFF00C4CC),
      ),
      (
        icon: Icons.workspace_premium,
        title: 'Real-World Projects',
        body: 'Build production-ready apps, dashboards, and ML models that stand out on your resume.',
        color: const Color(0xFFFF6B6B),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6FB),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE1E6F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Learning Journey',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF24395A),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Every course is paired with guidance, community, and real-world practice so you gain skills with confidence.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 18,
                              color: const Color(0xFF4B5D7A),
                              height: 1.45,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE1E6F0)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.emoji_events, color: Color(0xFF4A6BFF)),
                      SizedBox(width: 8),
                      Text(
                        'Graduate success rate: 92%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF24395A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 900;
                final children = steps
                    .map(
                      (step) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          child: _JourneyCard(
                            icon: step.icon,
                            title: step.title,
                            description: step.body,
                            accentColor: step.color,
                          ),
                        ),
                      ),
                    )
                    .toList();

                if (isNarrow) {
                  return Column(
                    children: children
                        .map((child) => SizedBox(
                              width: double.infinity,
                              child: child,
                            ))
                        .toList(),
                  );
                }

                return Row(children: children);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, CourseProvider provider) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.menu_book_outlined, size: 72, color: Color(0xFF92A3BF)),
          const SizedBox(height: 16),
          const Text(
            'No courses available yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF314569)),
          ),
          const SizedBox(height: 12),
          const Text(
            'Check back soon or contact the admin to add courses.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF5D6C83)),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: provider.isLoading ? null : () => provider.fetchCourses(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, CourseProvider provider) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAEA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFB3B3)),
      ),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFD93025)),
              const SizedBox(width: 8),
              Text(
                'Unable to load courses',
                style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD93025),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            provider.errorMessage ?? 'An unexpected error occurred.',
            style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF5D6C83)),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: provider.isLoading ? null : () => provider.fetchCourses(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _JourneyCard({
    required IconData icon,
    required String title,
    required String description,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE1E6F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF24395A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF55627A),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

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
}
