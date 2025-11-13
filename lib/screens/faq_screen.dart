import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<_FaqItem> _faqItems = const [
    _FaqItem(
      question: 'What makes Crater Code different?',
      answer:
          'We combine expert-led instruction, project-driven learning, and personalized mentorship to accelerate your growth across modern tech stacks.',
    ),
    _FaqItem(
      question: 'Do I need prior experience to enroll?',
      answer:
          'Not at all. We offer beginner-friendly tracks along with advanced programs. Each path includes foundational modules to get you up to speed.',
    ),
    _FaqItem(
      question: 'How are the courses delivered?',
      answer:
          'Live interactive sessions, on-demand video lessons, and collaborative workshops let you learn at your own pace while still getting real-time support.',
    ),
    _FaqItem(
      question: 'Will I get support after course completion?',
      answer:
          'Yes. Our alumni network and career guidance teams remain available to help with portfolios, interviews, and community meetups.',
    ),
    _FaqItem(
      question: 'Can I switch tracks after enrolling?',
      answer:
          'Absolutely. Speak with your mentor to choose the track that best matches your goals, and we will help you transition smoothly.',
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: CustomAppBar(
        scrollController: _scrollController,
        activeItem: 'FAQ',
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(textTheme),
                  const SizedBox(height: 40),
                  _buildFaqList(theme),
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
          'Frequently Asked Questions',
          style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF24395A),
              ) ??
              const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Color(0xFF24395A),
              ),
        ),
        const SizedBox(height: 16),
        Text(
          'Quick answers to the most common questions about Crater Code courses, mentorship, and learning experience.',
          style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF4B5D7A),
                height: 1.6,
              ) ??
              const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B5D7A),
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildFaqList(ThemeData theme) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionPanelList.radio(
            animationDuration: const Duration(milliseconds: 300),
            expandedHeaderPadding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            elevation: 0,
            children: [
              for (final item in _faqItems)
                ExpansionPanelRadio(
                  value: item.question,
                  headerBuilder: (context, isExpanded) => _FaqQuestionHeader(
                    question: item.question,
                    isExpanded: isExpanded,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Text(
                      item.answer,
                      style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF4B5D7A),
                            height: 1.6,
                          ) ??
                          const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF4B5D7A),
                            height: 1.6,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({
    required this.question,
    required this.answer,
  });
}

class _FaqQuestionHeader extends StatelessWidget {
  final String question;
  final bool isExpanded;

  const _FaqQuestionHeader({
    required this.question,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF24395A);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        question,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ) ??
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
      ),
      trailing: AnimatedRotation(
        turns: isExpanded ? 0.25 : 0,
        duration: const Duration(milliseconds: 200),
        child: const Icon(
          Icons.add,
          color: Color(0xFF2F5DA8),
          size: 24,
        ),
      ),
    );
  }
}
