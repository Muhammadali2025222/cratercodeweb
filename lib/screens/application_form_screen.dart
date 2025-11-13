import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../services/api_service.dart';
import '../widgets/custom_app_bar.dart';
import 'success_screen.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _HighlightFeature {
  const _HighlightFeature({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({required this.feature});

  final _HighlightFeature feature;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: Icon(
            feature.icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                feature.description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  String _selectedCourse = 'Web Development Fundamentals';
  bool _isSubmitting = false;

  static const List<String> _fallbackCourses = [
    'Web Development Fundamentals',
    'Frontend with React.js',
    'MERN Stack Mastery',
    'Flutter Mobile Development',
    'React Native Mastery',
    'Machine Learning Fundamentals',
    'Deep Learning Specialization',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final result = await ApiService.submitApplication(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        course: _selectedCourse,
        message: _messageController.text.isEmpty ? null : _messageController.text,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;

      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              fullName: _fullNameController.text,
              course: _selectedCourse,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to submit application'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final courseNames = courseProvider.courses
        .map((course) => course.title.trim())
        .where((title) => title.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final dropdownCourses = courseNames.isNotEmpty ? courseNames : _fallbackCourses;

    if (dropdownCourses.isNotEmpty && !dropdownCourses.contains(_selectedCourse)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedCourse = dropdownCourses.first;
        });
      });
    }

    return Scaffold(
      appBar: CustomAppBar(
        scrollController: _scrollController,
        title: 'Apply Now',
      ),
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 900;
          final horizontalPadding = isCompact ? 24.0 : 64.0;
          final verticalPadding = isCompact ? 36.0 : 72.0;

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Start Your Learning Journey',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: isCompact ? 36 : 54,
                                color: const Color(0xFF24395A),
                                height: 1.1,
                              ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: isCompact ? double.infinity : 720,
                          child: Text(
                            'Tell us a bit about yourself and we will reserve your seat in your desired program.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 18,
                                  color: const Color(0xFF4B5D7A),
                                  height: 1.5,
                                ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        if (isCompact)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildHighlightsCard(context),
                              const SizedBox(height: 24),
                              _buildApplicationForm(context, dropdownCourses),
                            ],
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildHighlightsCard(context)),
                              const SizedBox(width: 32),
                              Expanded(flex: 2, child: _buildApplicationForm(context, dropdownCourses)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHighlightsCard(BuildContext context) {
    final theme = Theme.of(context);

    const features = <_HighlightFeature>[
      _HighlightFeature(
        icon: Icons.auto_awesome,
        title: 'Personalized Mentorship',
        description: 'Weekly live sessions with industry mentors to review progress.',
      ),
      _HighlightFeature(
        icon: Icons.engineering,
        title: 'Hands-on Projects',
        description: 'Build production-ready apps that live on your portfolio.',
      ),
      _HighlightFeature(
        icon: Icons.bolt,
        title: 'Career Support',
        description: 'Interview prep, resume polishing, and job referrals on demand.',
      ),
    ];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2F5DA8),
              Color(0xFF5D7BD1),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why learners choose us',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Apply once, unlock a guided program tailored to your goals.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            for (final feature in features) ...[
              _HighlightTile(feature: feature),
              const SizedBox(height: 20),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.watch_later_outlined,
                      color: Color(0xFF2F5DA8),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Application review turnaround: under 24 hours on weekdays.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildApplicationForm(BuildContext context, List<String> dropdownCourses) {
    final theme = Theme.of(context);
    const accentColor = Color(0xFF2F5DA8);

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Reserve your seat',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF24395A),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete the form and our admissions team will reach out with next steps.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF54617A),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!emailPattern.hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                initialValue: dropdownCourses.contains(_selectedCourse) ? _selectedCourse : null,
                decoration: const InputDecoration(
                  labelText: 'Select Course',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                items: dropdownCourses.map((course) {
                  return DropdownMenuItem(
                    value: course,
                    child: Text(course),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCourse = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message (Optional)',
                  hintText: 'Tell us why you want to join this course',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  elevation: 4,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Submit Application'),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6FD),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.support_agent, color: accentColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Need help? Email admissions@cratercode.com and our team will assist you.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF4B5D7A),
                          fontWeight: FontWeight.w600,
                        ),
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