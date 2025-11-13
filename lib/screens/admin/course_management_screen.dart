import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../providers/course_provider.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../providers/whatsapp_visibility_provider.dart';

class CourseManagementScreen extends StatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  State<CourseManagementScreen> createState() => _CourseManagementScreenState();
}

class _CourseManagementScreenState extends State<CourseManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController(text: '6 weeks');
  final _levelController = TextEditingController(text: 'Beginner');
  final _categoryController = TextEditingController();
  final _technologiesController = TextEditingController();

  String? _editingCourseId;
  final _scrollController = ScrollController();

  // Detail pairs shown in the dialog (tech stack + description)
  final List<Map<String, TextEditingController>> _detailControllers = [];
  List<CourseDetail> _currentDetails = [];

  Course? _selectedCourse;
  bool _isSavingCourse = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      if (!courseProvider.hasLoadedFromApi && !courseProvider.isLoading) {
        courseProvider.fetchCourses();
      }
      Provider.of<WhatsAppVisibilityProvider>(context, listen: false).setVisibility(false);
    });
  }

  @override
  void dispose() {
    Provider.of<WhatsAppVisibilityProvider>(context, listen: false).setVisibility(true);
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _levelController.dispose();
    _categoryController.dispose();
    _technologiesController.dispose();
    _scrollController.dispose();
    _disposeDetailControllers();
    super.dispose();
  }

  void _showCourseForm({Course? course}) {
    if (course != null) {
      _editingCourseId = course.id;
      _selectedCourse = course;
      _titleController.text = course.title;
      _descriptionController.text = course.description;
      _durationController.text = course.duration;
      _levelController.text = course.level;
      _categoryController.text = course.category;
      _technologiesController.text = course.technologies.join(', ');
      _currentDetails = _safeDetails(course)
          .map((detail) => detail.copyWith())
          .toList();
    } else {
      _editingCourseId = null;
      _selectedCourse = null;
      _titleController.clear();
      _descriptionController.clear();
      _durationController.text = '6 weeks';
      _levelController.text = 'Beginner';
      _categoryController.clear();
      _technologiesController.clear();
      _currentDetails = [];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 24,
          right: 24,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course == null ? 'Add New Course' : 'Edit Course',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Course Title
                Text(
                  'Course Title',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter course title',
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Enter course description',
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Category and Duration Row
                Row(
                  children: [
                    // Category Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _categoryController,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'e.g., Web Development',
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Duration Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Duration',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _durationController,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'e.g., 6 weeks',
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Level and Technologies Row
                Row(
                  children: [
                    // Level Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _levelController,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'e.g., Beginner',
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Technologies Field
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Technologies',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _technologiesController,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'e.g., Flutter, Dart, Firebase',
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              helperText: 'Separate with commas',
                              helperStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 13,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Submit Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSavingCourse ? null : () => _saveCourse(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: _isSavingCourse
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                course == null ? 'Add Course' : 'Save Changes',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveCourse() async {
    if (_isSavingCourse) return;
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final category = _categoryController.text.trim();
    final duration = _durationController.text.trim().isEmpty
        ? '6 weeks'
        : _durationController.text.trim();
    final level = _levelController.text.trim().isEmpty
        ? 'Beginner'
        : _levelController.text.trim();
    final technologies = _technologiesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    setState(() => _isSavingCourse = true);

    final courseProvider = Provider.of<CourseProvider>(
      context,
      listen: false,
    );

    try {
      Course? savedCourse;

      if (_editingCourseId != null) {
        final baseCourse = (_selectedCourse ??
                Course(
                  id: _editingCourseId!,
                  slug: null,
                  title: title,
                  description: description,
                  technologies: technologies,
                  details: _currentDetails,
                  category: category,
                  duration: duration,
                  level: level,
                  deliveryMode: _selectedCourse?.deliveryMode ?? 'Hybrid',
                ))
            .copyWith(
          id: _editingCourseId,
          title: title,
          description: description,
          technologies: technologies,
          details: _currentDetails.map((detail) => detail.copyWith()).toList(),
          category: category,
          duration: duration,
          level: level,
        );

        savedCourse = await courseProvider.updateCourse(baseCourse);

        if (mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Course updated successfully')),
          );
        }
      } else {
        final newCourse = Course(
          id: '',
          title: title,
          description: description,
          technologies: technologies,
          details: _currentDetails.map((detail) => detail.copyWith()).toList(),
          category: category,
          duration: duration,
          level: level,
          deliveryMode: 'Hybrid',
        );

        savedCourse = await courseProvider.createCourse(newCourse);

        if (mounted) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Course created successfully')),
          );
        }
      }

      final courseForState = savedCourse;
      if (courseForState != null && mounted) {
        setState(() {
          _selectedCourse = courseForState;
          _editingCourseId = courseForState.id;
          _currentDetails = courseForState.details
              .map((detail) => detail.copyWith())
              .toList();
        });

        navigator.pop();
      }
    } on ApiException catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Failed to save course')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingCourse = false);
      }
    }
  }

  void _confirmDelete(Course course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: Text('Are you sure you want to delete "${course.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              final courseProvider = Provider.of<CourseProvider>(
                context,
                listen: false,
              );

              try {
                await courseProvider.deleteCourse(course.id);
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text('${course.title} deleted')),
                );
              } on ApiException catch (e) {
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text(e.message)),
                );
              } catch (_) {
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text('Failed to delete course')),
                );
              }
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(Course course) {
    _initializeDetailControllers(_safeDetails(course));

    bool isSavingDetails = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final theme = Theme.of(context);
            return AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                    decoration: BoxDecoration(
                      color: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Course Details',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Add a tech stack and its description in pairs',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.textTheme.bodySmall?.color
                                            ?.withValues(alpha: 0.7),
                                      ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Close',
                              onPressed: () => Navigator.of(sheetContext).pop(),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ..._detailControllers.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final controllers = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: theme.colorScheme.surface,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Pair ${index + 1}',
                                                  style: theme.textTheme.titleMedium?.copyWith(
                                                        fontWeight: FontWeight.w700,
                                                      ),
                                                ),
                                                const Spacer(),
                                                if (_detailControllers.length > 1)
                                                  IconButton(
                                                    tooltip: 'Remove this pair',
                                                    icon: const Icon(Icons.delete_outline,
                                                        color: Colors.redAccent),
                                                    onPressed: () {
                                                      setSheetState(() {
                                                        controllers['techStack']?.dispose();
                                                        controllers['description']?.dispose();
                                                        _detailControllers.removeAt(index);
                                                      });
                                                    },
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 14),
                                            TextFormField(
                                              controller: controllers['techStack'],
                                              decoration: InputDecoration(
                                                labelText: 'Technological Stack',
                                                hintText: 'e.g., Flutter + Firebase',
                                                filled: true,
                                                fillColor: theme
                                                    .colorScheme.surfaceContainerHighest
                                                    .withValues(alpha: 0.4),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(14),
                                                  borderSide: BorderSide(
                                                    color: theme.dividerColor.withValues(alpha: 0.4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormField(
                                              controller: controllers['description'],
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                labelText: 'Detailed Description',
                                                hintText:
                                                    'Share key outcomes, tools, or topics for this stack',
                                                filled: true,
                                                fillColor: theme
                                                    .colorScheme.surfaceContainerHighest
                                                    .withValues(alpha: 0.4),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(14),
                                                  borderSide: BorderSide(
                                                    color: theme.dividerColor.withValues(alpha: 0.4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      setSheetState(_addDetailPair);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text('Add another pair'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(sheetContext).pop(),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isSavingDetails
                                    ? null
                                    : () async {
                                        final messenger = ScaffoldMessenger.of(context);
                                        final sheetNavigator = Navigator.of(sheetContext);
                                        final updatedDetails = _detailControllers
                                            .map((pair) => CourseDetail(
                                                  techStack: pair['techStack']!.text.trim(),
                                                  description: pair['description']!.text.trim(),
                                                ))
                                            .where((detail) =>
                                                detail.techStack.isNotEmpty ||
                                                detail.description.isNotEmpty)
                                            .toList();

                                        final courseProvider =
                                            Provider.of<CourseProvider>(context, listen: false);

                                        setSheetState(() => isSavingDetails = true);

                                        try {
                                          final updatedCourse = await courseProvider
                                              .upsertCourseDetails(course.id, updatedDetails);

                                          final courseForState = updatedCourse;
                                          if (!mounted) return;
                                          if (courseForState != null) {
                                            setState(() {
                                              if (_editingCourseId == courseForState.id) {
                                                _selectedCourse = courseForState;
                                                _currentDetails = courseForState.details
                                                    .map((detail) => detail.copyWith())
                                                    .toList();
                                              }
                                            });
                                          }

                                          if (!sheetContext.mounted) return;
                                          sheetNavigator.pop();

                                          messenger.showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Details updated for "${course.title}"'),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        } on ApiException catch (e) {
                                          if (!mounted) return;
                                          messenger.showSnackBar(
                                            SnackBar(content: Text(e.message)),
                                          );
                                        } catch (_) {
                                          if (!mounted) return;
                                          messenger.showSnackBar(
                                            const SnackBar(
                                              content: Text('Failed to update course details'),
                                            ),
                                          );
                                        } finally {
                                          if (sheetContext.mounted) {
                                            setSheetState(() => isSavingDetails = false);
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: isSavingDetails
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.save_alt_rounded),
                                label: const Text('Save Details'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(_disposeDetailControllers);
  }

  List<CourseDetail> _safeDetails(Course course) {
    try {
      return course.details;
    } catch (_) {
      return [];
    }
  }

  void _initializeDetailControllers(List<CourseDetail> details) {
    _disposeDetailControllers();

    final items = details.isEmpty
        ? [CourseDetail(techStack: '', description: '')]
        : details;

    for (final detail in items) {
      _detailControllers.add({
        'techStack': TextEditingController(text: detail.techStacks ?? detail.techStack),
        'description': TextEditingController(text: detail.description),
      });
    }
  }

  void _addDetailPair() {
    _detailControllers.add({
      'techStack': TextEditingController(),
      'description': TextEditingController(),
    });
  }

  void _disposeDetailControllers() {
    for (final controllers in _detailControllers) {
      controllers['techStack']?.dispose();
      controllers['description']?.dispose();
    }
    _detailControllers.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        scrollController: _scrollController,
        title: 'Course Management',
      ),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, _) {
          final courses = courseProvider.courses;

          if (courseProvider.isLoading && courses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (courseProvider.errorMessage != null && courses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      courseProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: courseProvider.isLoading
                        ? null
                        : () => courseProvider.fetchCourses(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return courses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No courses yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _showCourseForm(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Your First Course'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          course.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          course.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                              onPressed: () => _showDetailsDialog(course),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.08),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.description_outlined, size: 18),
                              label: const Text(
                                'Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showCourseForm(course: course),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(course),
                            ),
                          ],
                        ),
                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IconButton(
                        //       icon: const Icon(Icons.edit, color: Colors.blue),
                        //       onPressed: () => _showCourseForm(course: course),
                        //     ),
                        //     IconButton(
                        //       icon: const Icon(Icons.delete, color: Colors.red),
                        //       onPressed: () => _confirmDelete(course),
                        //     ),
                        //   ],
                        // ),
                        onTap: () => _showCourseForm(course: course),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCourseForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
