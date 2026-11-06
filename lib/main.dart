import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/quiz_provider.dart';
import 'providers/stats_provider.dart';
import 'providers/parent_provider.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_auth_screen.dart';
import 'utils/app_colors.dart';

import 'services/cloud_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('Firebase initialization retry with default: $e');
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (_) {}
  }
  // Immediately load cached questions from local phone storage
  try {
    await CloudSyncService.ensureCacheLoaded();
  } catch (e) {
    debugPrint('Cache load notice: $e');
  }
  runApp(const PintarBersamaApp());
}

class PintarBersamaApp extends StatelessWidget {
  const PintarBersamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => StatsProvider()),
        ChangeNotifierProvider(create: (_) => ParentProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'BINTANG PINTAR',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryCyan,
            primary: AppColors.primaryCyan,
            secondary: AppColors.secondaryCoral,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: AppColors.backgroundLight,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF38BDF8)),
        ),
      );
    }

    final account = userProvider.account;
    if (account != null && !account.isGuest) {
      return const HomeScreen();
    } else {
      return const WelcomeAuthScreen();
    }
  }
}
