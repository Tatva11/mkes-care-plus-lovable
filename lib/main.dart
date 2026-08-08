import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/staff_portal/screens/staff_dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "api.env");
  } catch (e) {
    debugPrint('Error loading environment file: $e');
    // Continue with empty env - will fail gracefully later
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

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return authStateAsync.when(
      data: (authState) {
        final session = authState.session;
        if (session == null) {
          return const LoginScreen();
        }

        // We are authenticated. Now check the role to redirect correctly.
        final roleAsync = ref.watch(currentUserRoleProvider);

        return roleAsync.when(
          data: (role) {
            if (role == 'admin') {
              return const AdminDashboardScreen();
            } else if (role == 'staff') {
              return const StaffDashboardScreen();
            } else if (role == 'inactive') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('This account has been disabled.'),
                    backgroundColor: Colors.red,
                  ),
                );
                Supabase.instance.client.auth.signOut();
              });
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            } else {
              // If role is null or an error occurred
              final errorMessage = (role != null && role.startsWith('ERROR: ')) 
                  ? role 
                  : 'Profile not found. Please contact your administrator.';
                  
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
                Supabase.instance.client.auth.signOut();
              });
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to load profile. Please try logging in again.'),
                  backgroundColor: Colors.red,
                ),
              );
              Supabase.instance.client.auth.signOut();
            });
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          },
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => const LoginScreen(),
    );
  }
}

class ConfigurationErrorApp extends StatelessWidget {
  const ConfigurationErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MKES CARE+ - Configuration Error',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Configuration Error',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Please ensure api.env file exists with SUPABASE_URL and SUPABASE_ANON_KEY.',
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