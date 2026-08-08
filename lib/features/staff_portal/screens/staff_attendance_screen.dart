import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class StaffAttendanceScreen extends StatefulWidget {
  const StaffAttendanceScreen({super.key});

  @override
  State<StaffAttendanceScreen> createState() => _StaffAttendanceScreenState();
}

class _StaffAttendanceScreenState extends State<StaffAttendanceScreen> {
  bool _isClockedIn = true;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 768.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.marginDesktop : AppSpacing.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            Row(
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
                  onPressed: () => _showLeaveRequestDialog(context),
                  icon: const Icon(Icons.event_note),
                  label: const Text('Apply for Leave'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            )
          else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Attendance & Time Logs', style: AppTypography.displayLg.copyWith(color: AppColors.onBackground, fontSize: 26)),
                const SizedBox(height: AppSpacing.xs),
                Text('Shift tracking, clock-in history, and PTO requests', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  onPressed: () => _showLeaveRequestDialog(context),
                  icon: const Icon(Icons.event_note),
                  label: const Text('Apply for Leave'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          // Clock In / Out Widget
          Container(
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
            child: isDesktop
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isClockedIn ? AppColors.primaryContainer : AppColors.error,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isClockedIn ? 'CLOCKED IN — ON DUTY' : 'CLOCKED OUT — OFF DUTY',
                                style: AppTypography.labelCaps.copyWith(
                                  color: _isClockedIn ? AppColors.primaryContainer : AppColors.error,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isClockedIn ? '04 hrs : 22 mins : 15 secs' : '00 hrs : 00 mins',
                            style: AppTypography.displayLg.copyWith(fontSize: 28, color: AppColors.onSurface),
                          ),
                          Text(
                            _isClockedIn ? 'Shift Started: 07:02 AM today' : 'Last shift ended: 03:00 PM yesterday',
                            style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          setState(() {
                            _isClockedIn = !_isClockedIn;
                          });
                        },
                        icon: Icon(_isClockedIn ? Icons.logout : Icons.login),
                        label: Text(_isClockedIn ? 'Clock Out' : 'Clock In'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _isClockedIn ? AppColors.error : AppColors.primaryContainer,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                        ),
                      ),
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
                              color: _isClockedIn ? AppColors.primaryContainer : AppColors.error,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isClockedIn ? 'CLOCKED IN — ON DUTY' : 'CLOCKED OUT — OFF DUTY',
                            style: AppTypography.labelCaps.copyWith(
                              color: _isClockedIn ? AppColors.primaryContainer : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isClockedIn ? '04 hrs : 22 mins : 15 secs' : '00 hrs : 00 mins',
                        style: AppTypography.displayLg.copyWith(fontSize: 24, color: AppColors.onSurface),
                      ),
                      Text(
                        _isClockedIn ? 'Shift Started: 07:02 AM today' : 'Last shift ended: 03:00 PM yesterday',
                        style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _isClockedIn = !_isClockedIn;
                            });
                          },
                          icon: Icon(_isClockedIn ? Icons.logout : Icons.login),
                          label: Text(_isClockedIn ? 'Clock Out' : 'Clock In'),
                          style: FilledButton.styleFrom(
                            backgroundColor: _isClockedIn ? AppColors.error : AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Weekly Log Table
          Text('Weekly Shift Log', style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.md),

          Container(
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
                      child: Column(
                        children: [
                          _buildLogRow('Monday, Jul 27', '07:00 AM', '03:05 PM', '08h 05m', 'On Time'),
                          _buildLogRow('Tuesday, Jul 28', '07:02 AM', '03:10 PM', '08h 08m', 'On Time'),
                          _buildLogRow('Wednesday, Jul 29', '07:15 AM', '03:00 PM', '07h 45m', 'Late (15m)', isLate: true),
                          _buildLogRow('Thursday, Jul 30', '07:00 AM', '03:00 PM', '08h 00m', 'On Time'),
                          _buildLogRow('Friday, Jul 31', '07:01 AM', '03:02 PM', '08h 01m', 'On Time', isLast: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                color: isLate ? AppColors.error : AppColors.primaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLeaveRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apply for Leave', style: AppTypography.headlineMd),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Leave Type', style: AppTypography.labelCaps),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              initialValue: 'PTO',
              items: const [
                DropdownMenuItem(value: 'PTO', child: Text('Paid Time Off (PTO)')),
                DropdownMenuItem(value: 'Sick', child: Text('Sick Leave')),
                DropdownMenuItem(value: 'Emergency', child: Text('Emergency Leave')),
              ],
              onChanged: (_) {},
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Dates', style: AppTypography.labelCaps),
            const SizedBox(height: 4),
            const TextField(
              decoration: InputDecoration(
                hintText: 'e.g. Aug 15 - Aug 17',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leave request submitted successfully!')),
              );
            },
            child: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }
}
