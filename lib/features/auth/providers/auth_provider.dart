import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/auth_repository.dart';

/// Provides the current AuthState from Supabase (including session).
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Provides the currently logged-in user, or null if unauthenticated.
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user;
});

/// Provides the role of the currently logged-in user by fetching from the profiles table.
final currentUserRoleProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  try {
    final response = await Supabase.instance.client
        .from('profiles')
        .select('role, is_active')
        .eq('id', user.id)
        .maybeSingle();
        
    if (response == null) {
      debugPrint('Profile not found for user: ${user.id}');
      return null;
    }
        
    final isActive = response['is_active'] as bool? ?? false;
    if (!isActive) {
      return 'inactive';
    }
    
    return response['role'] as String?;
  } catch (e) {
    debugPrint('Error fetching user role: $e');
    return null;
  }
});
