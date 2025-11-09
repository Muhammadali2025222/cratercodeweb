import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/custom_app_bar.dart';
import 'home.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(scrollController: _scrollController),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with the new quote
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
            
            // Categories Section
            ..._buildCategoriesSection(context),
            
            // Call to Action Section
            const SizedBox(height: 80),
            _buildCallToActionSection(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoriesSection(BuildContext context) {
    // Group courses by category
    final categories = {
      'Web Development': courses.where((c) => c.category == 'Web Development').toList(),
      'App Development': courses.where((c) => c.category == 'App Development').toList(),
      'AI/ML': courses.where((c) => c.category == 'AI/ML').toList(),
    };

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
                return _buildCourseCard(course, context);
              },
            ),
          ],
        ),
      );
    }).toList();
  }

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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to course details
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getCategoryColor(course.category),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Learn More',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

  Widget _buildCallToActionSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2A4B7C),
            Color(0xFF1F3558),
          ],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Ready to Start Your Journey?',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const SizedBox(
            width: 600,
            child: Text(
              'Join thousands of students who have transformed their careers with our industry-leading programs.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              // Handle apply now
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A6BFF),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Apply Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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
