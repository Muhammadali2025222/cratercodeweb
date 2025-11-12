import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message';
}

class ApiService {
  // Base URL for the API
  static const String baseUrl = 'http://localhost/cratercode_backend/backend/backend.php';
  
  // Timeout duration for API calls
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Headers for API requests
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Helper method to handle HTTP requests
  static Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> request,
  ) async {
    try {
      final response = await request.timeout(timeoutDuration);
      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      } else {
        throw ApiException(
          message: responseData['message'] ?? 'Request failed',
          statusCode: response.statusCode,
          data: responseData,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      
      if (e is FormatException) {
        throw ApiException(message: 'Invalid response format');
      } else if (e is TypeError) {
        throw ApiException(message: 'Type error: ${e.toString()}');
      } else if (e is ArgumentError) {
        throw ApiException(message: 'Invalid argument: ${e.message}');
      } else if (e is TimeoutException) {
        throw ApiException(message: 'Request timed out');
      } else {
        throw ApiException(message: 'Network error: ${e.toString()}');
      }
    }
  }

  static Future<Map<String, dynamic>> _postAction(Map<String, dynamic> payload) {
    return _handleRequest(
      http.post(
        Uri.parse(baseUrl),
        headers: defaultHeaders,
        body: jsonEncode(payload),
      ),
    );
  }

  // Login
  static Future<Map<String, dynamic>> login({
    String? username,
    String? email,
    String? identifier,
    required String password,
  }) async {
    if ((identifier == null || identifier.isEmpty) &&
        (username == null || username.isEmpty) &&
        (email == null || email.isEmpty)) {
      throw ApiException(message: 'Username or email is required');
    }

    try {
      final payload = <String, String>{
        'action': 'login',
        'password': password,
      };

      if (identifier != null && identifier.isNotEmpty) {
        payload['identifier'] = identifier;
      } else {
        if (username != null && username.isNotEmpty) {
          payload['username'] = username;
        }
        if (email != null && email.isNotEmpty) {
          payload['email'] = email;
        }
      }

      final response = await _postAction(payload);

      return {
        'success': true,
        'data': response['data'],
        'message': response['message'] ?? 'Login successful',
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
        'statusCode': e.statusCode,
        'data': e.data,
      };
    }
  }

  // Submit application
  static Future<Map<String, dynamic>> submitApplication({
    required String fullName,
    required String email,
    required String phone,
    required String course,
    String? message,
  }) async {
    try {
      final response = await _postAction({
        'action': 'submit_application',
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'course': course,
        'message': message,
      });

      return {
        'success': true,
        'data': response,
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
        'statusCode': e.statusCode,
      };
    }
  }

  /// Retrieve all courses with their technology detail rows.
  static Future<Map<String, dynamic>> listCourses() async {
    try {
      final response = await _postAction({'action': 'list_courses'});
      return {
        'success': true,
        'data': response['data'],
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
        'statusCode': e.statusCode,
        'data': e.data,
      };
    }
  }

  /// Create a new course record.
  static Future<Map<String, dynamic>> createCourse({
    required String title,
    required String description,
    required String category,
    required List<String> technologies,
    required int durationWeeks,
    required String difficultyLevel,
    String deliveryMode = 'Hybrid',
    String? slug,
  }) async {
    try {
      final response = await _postAction({
        'action': 'create_course',
        'title': title,
        'description': description,
        'category': category,
        'technologies': technologies,
        'duration_weeks': durationWeeks,
        'difficulty_level': difficultyLevel,
        'delivery_mode': deliveryMode,
        if (slug != null) 'slug': slug,
      });

      return {
        'success': true,
        'data': response['data'],
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
        'statusCode': e.statusCode,
        'data': e.data,
      };
    }
  }

  /// Update an existing course record.
  static Future<Map<String, dynamic>> updateCourse({
    required String id,
    required String title,
    required String description,
    required String category,
    required List<String> technologies,
    required int durationWeeks,
    required String difficultyLevel,
    String deliveryMode = 'Hybrid',
    String? slug,
  }) async {
    try {
      final response = await _postAction({
        'action': 'update_course',
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'technologies': technologies,
        'duration_weeks': durationWeeks,
        'difficulty_level': difficultyLevel,
        'delivery_mode': deliveryMode,
        if (slug != null) 'slug': slug,
      });

      return {
        'success': true,
        'data': response['data'],
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
        'statusCode': e.statusCode,
        'data': e.data,
      };
    }
  }

  /// Delete a course along with its detail rows.
  static Future<Map<String, dynamic>> deleteCourse(String id) async {
    try {
      final response = await _postAction({
        'action': 'delete_course',
        'id': id,
      });

      return {
        'success': true,
        'data': response,
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
        'statusCode': e.statusCode,
        'data': e.data,
      };
    }
  }

  /// Replace the course technology detail pairs for a course.
  static Future<Map<String, dynamic>> upsertCourseDetails({
    required String courseId,
    required List<Map<String, dynamic>> details,
  }) async {
    try {
      final response = await _postAction({
        'action': 'upsert_course_details',
        'course_id': courseId,
        'details': details,
      });

      return {
        'success': true,
        'data': response['data'],
      };
    } on ApiException catch (e) {
      return {
        'success': false,
        'message': e.message,
        'statusCode': e.statusCode,
        'data': e.data,
      };
    }
  }
}