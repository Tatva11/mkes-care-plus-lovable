import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/providers/auth_provider.dart';
import '../../staff/models/attendance_record.dart';
import '../../staff/providers/attendance_provider.dart';
import 'staff_leave_screen.dart';

class StaffAttendanceScreen extends ConsumerStatefulWidget {
  const StaffAttendanceScreen({super.key});

  @override
  ConsumerState<StaffAttendanceScreen> createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends ConsumerState<StaffAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 768.0;
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) return const Center(child: CircularProgressIndicator());

    final attendanceAsync = ref.watch(attendanceProvider(currentUser.id));
    final todayAsync = ref.watch(todayAttendanceProvider(currentUser.id));

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.marginDesktop : AppSpacing.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDesktop, context),
          const SizedBox(height: AppSpacing.lg),
          _buildClockInOutWidget(isDesktop, todayAsync, currentUser.id),
          const SizedBox(height: AppSpacing.lg),
          Text('Monthly Shift Log', style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.md),
          _buildLogTable(attendanceAsync),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, BuildContext context) {
    if (isDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Attendance & Time Logs', style: AppTypography.displayLg.copyWith(color: AppColors.onBackground)),
              const SizedBox(height: AppSpacing.xs),
              Text('Shift tracking, clock-in history, and PTO requests', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StaffLeaveScreen()));
            },
            icon: const Icon(Icons.event_note),
            label: const Text('Leave Management'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attendance & Time Logs', style: AppTypography.displayLg.copyWith(color: AppColors.onBackground, fontSize: 26)),
          const SizedBox(height: AppSpacing.xs),
          Text('Shift tracking, clock-in history, and PTO requests', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StaffLeaveScreen()));
            },
            icon: const Icon(Icons.event_note),
            label: const Text('Leave Management'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildClockInOutWidget(bool isDesktop, AsyncValue<AttendanceRecord?> todayAsync, String staffId) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: todayAsync.when(
        data: (record) {
          final isClockedIn = record != null && record.checkOutTime == null;
          final hasCompletedShift = record != null && record.checkOutTime != null;
          final isLeave = record != null && record.status == 'leave';
          final isHoliday = record != null && record.status == 'holiday';

          if (isLeave || isHoliday) {
            return Center(
              child: Text(
                isLeave ? 'YOU ARE ON LEAVE TODAY' : 'TODAY IS A HOLIDAY',
                style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
              ),
            );
          }

          if (hasCompletedShift) {
            return Center(
              child: Text(
                'SHIFT COMPLETED: ${record.workingHours?.toStringAsFixed(1) ?? "0"} hrs',
                style: AppTypography.headlineMd.copyWith(color: AppColors.primaryContainer),
              ),
            );
          }

          return isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isClockedIn ? AppColors.primaryContainer : AppColors.error,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  isClockedIn ? 'CLOCKED IN — ON DUTY' : 'CLOCKED OUT — OFF DUTY',
                                  style: AppTypography.labelCaps.copyWith(
                                    color: isClockedIn ? AppColors.primaryContainer : AppColors.error,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isClockedIn ? 'Shift Started' : 'Ready to Start',
                            style: AppTypography.displayLg.copyWith(fontSize: 28, color: AppColors.onSurface),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            isClockedIn ? 'Check-in: ${record.checkInTime?.hour.toString().padLeft(2, '0')}:${record.checkInTime?.minute.toString().padLeft(2, '0')}' : 'Click Clock In to start your day',
                            style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _buildActionButton(isClockedIn, staffId),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isClockedIn ? AppColors.primaryContainer : AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            isClockedIn ? 'CLOCKED IN — ON DUTY' : 'CLOCKED OUT — OFF DUTY',
                            style: AppTypography.labelCaps.copyWith(
                              color: isClockedIn ? AppColors.primaryContainer : AppColors.error,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isClockedIn ? 'Shift Started' : 'Ready to Start',
                      style: AppTypography.displayLg.copyWith(fontSize: 24, color: AppColors.onSurface),
                    ),
                    Text(
                      isClockedIn ? 'Check-in: ${record.checkInTime?.hour.toString().padLeft(2, '0')}:${record.checkInTime?.minute.toString().padLeft(2, '0')}' : 'Click Clock In to start your day',
                      style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: _buildActionButton(isClockedIn, staffId),
                    ),
                  ],
                );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading status: $e')),
      ),
    );
  }

  Widget _buildActionButton(bool isClockedIn, String staffId) {
    return FilledButton.icon(
      onPressed: () async {
        try {
          if (isClockedIn) {
            await ref.read(attendanceProvider(staffId).notifier).checkOut();
          } else {
            await ref.read(attendanceProvider(staffId).notifier).checkIn();
          }
          ref.invalidate(todayAttendanceProvider(staffId));
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
          }
        }
      },
      icon: Icon(isClockedIn ? Icons.logout : Icons.login),
      label: Text(isClockedIn ? 'Clock Out' : 'Clock In'),
      style: FilledButton.styleFrom(
        backgroundColor: isClockedIn ? AppColors.error : AppColors.primaryContainer,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      ),
    );
  }

  Widget _buildLogTable(AsyncValue<List<AttendanceRecord>> attendanceAsync) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 650),
          child: Column(
            children: [
              SizedBox(width: 650, child: _buildLogHeader()),
              SizedBox(
                width: 650,
                child: attendanceAsync.when(
                  data: (records) {
                    if (records.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Text("No attendance records found."),
                      );
                    }
                    return Column(
                      children: records.asMap().entries.map((entry) {
                        final i = entry.key;
                        final r = entry.value;
                        return _buildLogRow(
                          '${r.date.year}-${r.date.month.toString().padLeft(2, '0')}-${r.date.day.toString().padLeft(2, '0')}',
                          r.checkInTime != null ? '${r.checkInTime!.hour.toString().padLeft(2, '0')}:${r.checkInTime!.minute.toString().padLeft(2, '0')}' : '--:--',
                          r.checkOutTime != null ? '${r.checkOutTime!.hour.toString().padLeft(2, '0')}:${r.checkOutTime!.minute.toString().padLeft(2, '0')}' : '--:--',
                          r.workingHours != null ? '${r.workingHours!.toStringAsFixed(1)}h' : '--',
                          r.status.toUpperCase(),
                          isLate: r.isLate,
                          isLast: i == records.length - 1,
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Padding(padding: EdgeInsets.all(AppSpacing.lg), child: CircularProgressIndicator()),
                  error: (e, st) => Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('DATE', style: AppTypography.labelCaps)),
          Expanded(flex: 2, child: Text('CLOCK IN', style: AppTypography.labelCaps)),
          Expanded(flex: 2, child: Text('CLOCK OUT', style: AppTypography.labelCaps)),
          Expanded(flex: 2, child: Text('TOTAL', style: AppTypography.labelCaps)),
          Expanded(flex: 2, child: Text('STATUS', style: AppTypography.labelCaps)),
        ],
      ),
    );
  }

  Widget _buildLogRow(String date, String inTime, String outTime, String total, String status, {bool isLate = false, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(date, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(inTime, style: AppTypography.dataMono)),
          Expanded(flex: 2, child: Text(outTime, style: AppTypography.dataMono)),
          Expanded(flex: 2, child: Text(total, style: AppTypography.dataMono.copyWith(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 2,
            child: Text(
              status,
              style: AppTypography.labelCaps.copyWith(
                color: isLate || status == 'ABSENT' ? AppColors.error : AppColors.primaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
