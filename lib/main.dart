import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/role_selection_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/staff_portal/screens/staff_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "api.env");
  } catch (e) {
    debugPrint('Error loading environment file: $e');
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (supabaseUrl == null || supabaseAnonKey == null) {
    debugPrint('Error: SUPABASE_URL or SUPABASE_ANON_KEY not found in api.env');
    runApp(const ConfigurationErrorApp());
    return;
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseAnonKey,
    );
  } catch (e) {
    debugPrint('Error initializing Supabase: $e');
    runApp(const ConfigurationErrorApp());
    return;
  }

  runApp(
    const ProviderScope(
      child: MkesCareApp(),
    ),
  );
}

class MkesCareApp extends StatelessWidget {
  const MkesCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MKES CARE+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AuthWrapper(),
    );
  }
}

/// Central authentication routing wrapper.
///
/// Flow:
///   App Start
///     → Listen to Supabase auth state
///     → No session → RoleSelectionScreen
///     → Session exists → fetch profile
///       → profile.role == 'admin' && is_active → AdminDashboardScreen
///       → profile.role == 'staff' && is_active → StaffDashboardScreen
///       → inactive / missing / wrong role → sign out + error message
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (authState) {
        final session = authState.session;

        // No active session → show role selection (portal landing).
        if (session == null) {
          return const RoleSelectionScreen();
        }

        // Session exists — resolve the user's role via profile.
        final roleAsync = ref.watch(currentUserRoleProvider);

        return roleAsync.when(
          data: (role) {
            switch (role) {
              case 'admin':
                return const AdminDashboardScreen();

              case 'staff':
                return const StaffDashboardScreen();

              case 'inactive':
                _signOutWithMessage(
                  context,
                  'Your account is currently inactive. Please contact an administrator.',
                );
                return _loadingScaffold();

              case null:
                _signOutWithMessage(
                  context,
                  'Your account is authenticated, but your clinic profile could not be found. '
                  'Please contact your administrator.',
                );
                return _loadingScaffold();

              default:
                // Unknown role — sign out.
                _signOutWithMessage(
                  context,
                  'Your account has an unrecognised role. Please contact your administrator.',
                );
                return _loadingScaffold();
            }
          },
          loading: _loadingScaffold,
          error: (e, st) {
            debugPrint('AuthWrapper role resolution error: $e');
            _signOutWithMessage(
              context,
              'Failed to verify your account. Please sign in again.',
            );
            return _loadingScaffold();
          },
        );
      },
      loading: _loadingScaffold,
      error: (e, st) => const RoleSelectionScreen(),
    );
  }

  Widget _loadingScaffold() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void _signOutWithMessage(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 6),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Supabase.instance.client.auth.signOut();
    });
  }
}

class ConfigurationErrorApp extends StatelessWidget {
  const ConfigurationErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MKES CARE+ — Configuration Error',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  'Configuration Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please ensure the api.env file exists with valid '
                  'SUPABASE_URL and SUPABASE_ANON_KEY values.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}