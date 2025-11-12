import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/login_screen.dart';
import 'screens/admin/course_management_screen.dart';
import 'providers/course_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, _) {
        if (!courseProvider.hasLoadedFromApi && !courseProvider.isLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            courseProvider.fetchCourses();
          });
        }

        return MaterialApp(
          title: 'Crater Code',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const HomeScreen(),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/admin/courses': (context) => const CourseManagementScreen(),
          },
        );
      },
    );
  }
}
