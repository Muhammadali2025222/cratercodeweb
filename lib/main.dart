import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/login_screen.dart';
import 'screens/admin/course_management_screen.dart';
import 'providers/course_provider.dart';
import 'providers/whatsapp_visibility_provider.dart';
import 'theme/app_theme.dart';
import 'widgets/whatsapp_floating_button.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => WhatsAppVisibilityProvider()),
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
          builder: (context, child) {
            final showWhatsApp = context.watch<WhatsAppVisibilityProvider>().isVisible;
            return Stack(
              children: [
                if (child != null) child,
                if (showWhatsApp) const WhatsAppFloatingButton(),
              ],
            );
          },
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
