import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/custom_app_bar.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider = context.read<CourseProvider>();
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
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, _) {
        final course = courseProvider.getCourseById(widget.course.id) ?? widget.course;
        final courseDetails = List<CourseDetail>.from(course.details)
          ..sort(
            (a, b) => (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0),
          );

        return Scaffold(
          appBar: CustomAppBar(
            scrollController: _scrollController,
            title: course.title,
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 900;

                final overviewCard = SizedBox(
                  width: isCompact ? double.infinity : 340,
                  child: _OverviewCard(course: course),
                );

                final detailSection = _CourseTechDetailsSection(
                  course: course,
                  details: courseDetails,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Course Details',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF24395A),
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Get a deeper look at what you will learn and the technologies you will master.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF4B5D7A),
                          ),
                    ),
                    const SizedBox(height: 32),
                    if (isCompact) ...[
                      overviewCard,
                      const SizedBox(height: 24),
                      detailSection,
                    ] else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          overviewCard,
                          const SizedBox(width: 32),
                          Expanded(child: detailSection),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detailCandidates = List<CourseDetail>.from(course.details)
      ..sort((a, b) => (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0));
    final primaryDetail = detailCandidates.isNotEmpty ? detailCandidates.first : null;
    final overviewDescription = primaryDetail?.description.trim().isNotEmpty == true
        ? primaryDetail!.description.trim()
        : course.primaryDetailDescription;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F3558),
                  ),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.category_outlined,
              label: 'Category',
              value: course.category.isNotEmpty ? course.category : 'General',
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.schedule_outlined,
              label: 'Duration',
              value: course.duration,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.emoji_objects_outlined,
              label: 'Level',
              value: course.level,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.computer_outlined,
              label: 'Delivery Mode',
              value: course.deliveryMode,
            ),
            if (overviewDescription != null && overviewDescription.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF24395A),
                    ),
              ),
              if (primaryDetail?.headline?.isNotEmpty == true) ...[
                const SizedBox(height: 6),
                Text(
                  primaryDetail!.headline!,
                  style: theme.textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF2F5DA8),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                overviewDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: const Color(0xFF54617A),
                    ),
              ),
            ],
            if (course.technologies.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Key Technologies',
                style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF24395A),
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: course.technologies
                    .map(
                      (tech) => Chip(
                        label: Text(tech),
                        backgroundColor: const Color(0xFFE9EFF9),
                        labelStyle: const TextStyle(
                          color: Color(0xFF1F3558),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CourseTechDetailsSection extends StatelessWidget {
  const _CourseTechDetailsSection({required this.course, required this.details});

  final Course course;
  final List<CourseDetail> details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technology Breakdown',
          style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F3558),
              ),
        ),
        const SizedBox(height: 16),
        if (details.isEmpty)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details coming soon',
                    style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF24395A),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We are updating the breakdown for ${course.title}. Check back shortly.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF54617A),
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          for (final detail in details)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
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
                                Text(
                                  detail.headline?.isNotEmpty == true
                                      ? detail.headline!
                                      : detail.techStack,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF24395A),
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  detail.techStacks?.isNotEmpty == true
                                      ? detail.techStacks!
                                      : detail.techStack,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                        color: const Color(0xFF4B5D7A),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (detail.displayOrder != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2F5DA8).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#${detail.displayOrder}',
                                style: const TextStyle(
                                  color: Color(0xFF2F5DA8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        detail.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF54617A),
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF2F5DA8)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF4B5D7A),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF1F3558),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
