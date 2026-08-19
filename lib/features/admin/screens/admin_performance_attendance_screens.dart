import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminAttendanceScreen extends ConsumerWidget {
  const AdminAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a full implementation, this would fetch all staff attendance for today
    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Attendance (Admin)')),
      body: const Center(child: Text('Admin Attendance Overview')),
    );
  }
}

class AdminPerformanceScreen extends ConsumerWidget {
  const AdminPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a full implementation, this would list staff and their performance metrics
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Performance (Admin)')),
      body: const Center(child: Text('Admin Performance Overview')),
    );
  }
}
