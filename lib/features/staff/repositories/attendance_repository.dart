import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_provider.dart';
import '../models/attendance_record.dart';
import 'attendance_source.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository(ref.watch(supabaseProvider));
});

class ManualAttendanceSource implements AttendanceSource {
  final SupabaseClient _supabase;
  ManualAttendanceSource(this._supabase);

  @override
  Future<void> recordCheckIn(String staffId, DateTime time) async {
    final dateStr = time.toIso8601String().split('T').first;
    // Basic threshold logic, e.g. 9:00 AM
    final isLate = time.hour >= 9 && time.minute > 0;
    final lateMinutes = isLate ? ((time.hour - 9) * 60 + time.minute) : 0;

    await _supabase.from('staff_attendance').upsert({
      'staff_id': staffId,
      'record_date': dateStr,
      'check_in_time': time.toIso8601String(),
      'status': isLate ? 'late' : 'present',
      'is_late': isLate,
      'late_minutes': lateMinutes,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'staff_id, record_date');
  }

  @override
  Future<void> recordCheckOut(String staffId, DateTime time) async {
    final dateStr = time.toIso8601String().split('T').first;

    // Fetch existing record to calculate working hours
    final existing = await _supabase
        .from('staff_attendance')
        .select('check_in_time')
        .eq('staff_id', staffId)
        .eq('record_date', dateStr)
        .maybeSingle();

    double? workingHours;
    if (existing != null && existing['check_in_time'] != null) {
      final checkIn = DateTime.parse(existing['check_in_time'] as String);
      workingHours = time.difference(checkIn).inMinutes / 60.0;
    }

    await _supabase.from('staff_attendance').update({
      'check_out_time': time.toIso8601String(),
      'working_hours': workingHours,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('staff_id', staffId).eq('record_date', dateStr);
  }
}

class AttendanceRepository {
  final SupabaseClient _supabase;
  late final AttendanceSource _source;

  AttendanceRepository(this._supabase) {
    _source = ManualAttendanceSource(_supabase);
  }

  /// Get attendance for a specific user and month
  Future<List<AttendanceRecord>> fetchMonthlyAttendance(String staffId, int year, int month) async {
    final startDate = DateTime(year, month, 1).toIso8601String().split('T').first;
    final endDate = DateTime(year, month + 1, 0).toIso8601String().split('T').first;

    final response = await _supabase
        .from('staff_attendance')
        .select()
        .eq('staff_id', staffId)
        .gte('record_date', startDate)
        .lte('record_date', endDate)
        .order('record_date', ascending: false);

    return (response as List).map((json) => AttendanceRecord.fromJson(json)).toList();
  }

  Future<AttendanceRecord?> fetchTodayAttendance(String staffId) async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final response = await _supabase
        .from('staff_attendance')
        .select()
        .eq('staff_id', staffId)
        .eq('record_date', today)
        .maybeSingle();

    if (response == null) return null;
    return AttendanceRecord.fromJson(response);
  }

  Future<void> checkIn(String staffId) async {
    await _source.recordCheckIn(staffId, DateTime.now());
  }

  Future<void> checkOut(String staffId) async {
    await _source.recordCheckOut(staffId, DateTime.now());
  }
}
