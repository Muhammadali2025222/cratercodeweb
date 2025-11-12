import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../services/api_service.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;
  bool _hasLoadedFromApi = false;
  String? _errorMessage;

  List<Course> get courses => List.unmodifiable(_courses);
  bool get isLoading => _isLoading;
  bool get hasLoadedFromApi => _hasLoadedFromApi;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCourses() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.listCourses();

      if (response['success'] == true && response['data'] is List) {
        final list = response['data'] as List<dynamic>;
        _courses = list
            .map((item) => Course.fromMap(item as Map<String, dynamic>))
            .toList();
      } else {
        _errorMessage = response['message']?.toString() ?? 'Failed to load courses.';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      _hasLoadedFromApi = true;
      notifyListeners();
    }
  }

  Future<Course?> createCourse(Course course) async {
    final response = await ApiService.createCourse(
      title: course.title,
      description: course.description,
      category: course.category,
      technologies: course.technologies,
      durationWeeks: _extractDurationWeeks(course.duration),
      difficultyLevel: course.level,
      deliveryMode: course.deliveryMode,
      slug: course.slug,
    );

    if (response['success'] == true && response['data'] is Map<String, dynamic>) {
      final createdCourse = Course.fromMap(response['data'] as Map<String, dynamic>);
      _courses.add(createdCourse);
      notifyListeners();
      return createdCourse;
    }

    throw ApiException(
      message: response['message']?.toString() ?? 'Failed to create course',
      data: response['data'],
      statusCode: response['statusCode'] as int?,
    );
  }

  Future<Course?> updateCourse(Course course) async {
    final response = await ApiService.updateCourse(
      id: course.id,
      title: course.title,
      description: course.description,
      category: course.category,
      technologies: course.technologies,
      durationWeeks: _extractDurationWeeks(course.duration),
      difficultyLevel: course.level,
      deliveryMode: course.deliveryMode,
      slug: course.slug,
    );

    if (response['success'] == true && response['data'] is Map<String, dynamic>) {
      final updatedCourse = Course.fromMap(response['data'] as Map<String, dynamic>);
      final index = _courses.indexWhere((c) => c.id == updatedCourse.id);
      if (index != -1) {
        _courses[index] = updatedCourse;
      } else {
        _courses.add(updatedCourse);
      }
      notifyListeners();
      return updatedCourse;
    }

    throw ApiException(
      message: response['message']?.toString() ?? 'Failed to update course',
      data: response['data'],
      statusCode: response['statusCode'] as int?,
    );
  }

  Future<void> deleteCourse(String courseId) async {
    final response = await ApiService.deleteCourse(courseId);

    if (response['success'] == true) {
      _courses.removeWhere((course) => course.id == courseId);
      notifyListeners();
      return;
    }

    throw ApiException(
      message: response['message']?.toString() ?? 'Failed to delete course',
      data: response['data'],
      statusCode: response['statusCode'] as int?,
    );
  }

  Future<Course?> upsertCourseDetails(String courseId, List<CourseDetail> details) async {
    final payloadDetails = details.asMap().entries.map((entry) {
      final detail = entry.value;
      final order = entry.value.displayOrder ?? entry.key + 1;

      return {
        'tech_name': detail.techStack.trim(),
        'headline': (detail.headline ?? detail.techStack).trim(),
        'tech_stacks': (detail.techStacks ?? detail.techStack).trim(),
        'long_description': detail.description.trim(),
        'display_order': order,
      };
    }).toList();

    final response = await ApiService.upsertCourseDetails(
      courseId: courseId,
      details: payloadDetails,
    );

    if (response['success'] == true && response['data'] is Map<String, dynamic>) {
      final updatedCourse = Course.fromMap(response['data'] as Map<String, dynamic>);
      final index = _courses.indexWhere((c) => c.id == updatedCourse.id);
      if (index != -1) {
        _courses[index] = updatedCourse;
      } else {
        _courses.add(updatedCourse);
      }
      notifyListeners();
      return updatedCourse;
    }

    throw ApiException(
      message: response['message']?.toString() ?? 'Failed to update course details',
      data: response['data'],
      statusCode: response['statusCode'] as int?,
    );
  }

  // Get a course by ID
  Course? getCourseById(String id) {
    try {
      return _courses.firstWhere((course) => course.id == id);
    } catch (_) {
      return null;
    }
  }

  // Get courses by category
  List<Course> getCoursesByCategory(String category) {
    return _courses.where((course) => course.category == category).toList();
  }

  // Get all unique categories
  List<String> get categories {
    final categories = _courses.map((course) => course.category).toSet();
    return categories.toList();
  }

  int _extractDurationWeeks(String value) {
    final match = RegExp(r'(\d+)').firstMatch(value);
    if (match != null) {
      final weeks = int.tryParse(match.group(1)!);
      if (weeks != null && weeks > 0) {
        return weeks;
      }
    }
    return 6;
  }
}
