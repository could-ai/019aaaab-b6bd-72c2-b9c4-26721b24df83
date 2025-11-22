import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/survey_screen.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'Calorie Tracker Pro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SurveyWrapper(),
          '/survey': (context) => const SurveyScreen(),
          '/home': (context) => const HomeScreen(),
          '/camera': (context) => const CameraScreen(),
        },
      ),
    );
  }
}

// Wrapper to decide whether to show Survey or Home based on if profile is set
class SurveyWrapper extends StatelessWidget {
  const SurveyWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final isProfileSet = Provider.of<AppProvider>(context).isProfileSet;
    if (isProfileSet) {
      return const HomeScreen();
    } else {
      return const SurveyScreen();
    }
  }
}
