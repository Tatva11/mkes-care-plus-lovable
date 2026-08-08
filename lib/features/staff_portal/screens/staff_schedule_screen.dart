import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class AppointmentModel {
  AppointmentModel({
    required this.id,
    required this.time,
    required this.patientName,
    required this.patientId,
    required this.type,
    required this.room,
    required this.status,
    required this.statusColor,
    this.isVisitingDoctor = false,
    this.doctorName,
    this.specialty,
    this.previousVisitSummary,
    this.previousTreatment,
    this.currentDiagnosis,
    this.plannedTreatment,
    this.doctorNotes,
  });

  final String id;
  final String time;
  final String patientName;
  final String patientId;
  final String type;
  final String room;
  String status;
  Color statusColor;
  final bool isVisitingDoctor;
  final String? doctorName;
  final String? specialty;
  final String? previousVisitSummary;
  final String? previousTreatment;
  final String? currentDiagnosis;
  final String? plannedTreatment;
  final String? doctorNotes;
}

class StaffScheduleScreen extends StatefulWidget {
  const StaffScheduleScreen({super.key});

  @override
  State<StaffScheduleScreen> createState() => _StaffScheduleScreenState();
}

class _StaffScheduleScreenState extends State<StaffScheduleScreen> {
  final List<AppointmentModel> _appointments = [
    AppointmentModel(
      id: 'APT-101',
      time: '09:00 AM',
      patientName: 'Sarah Jenkins',
      patientId: 'P-4092',
      type: 'Optometry Refraction & Fitting',
      room: 'Room 102',
      status: 'Confirmed',
      statusColor: AppColors.primaryContainer,
      isVisitingDoctor: false,
    ),
    AppointmentModel(
      id: 'APT-102',
      time: '10:30 AM',
      patientName: 'Michael Chen',
      patientId: 'P-4093',
      type: 'Retinal OCT & Macular Screening',
      room: 'Specialist Suite B',
      status: 'In Triage',
      statusColor: AppColors.secondary,
      isVisitingDoctor: true,
      doctorName: 'Dr. Robert Sterling',
      specialty: 'Visiting Retina Specialist',
      previousVisitSummary: 'Consulted May 04, 2026 for diabetic eye screening',
      previousTreatment: 'Dilated Macular Exam & 3D Topography',
      currentDiagnosis: 'Mild central macular edema flag; IOP 17 mmHg',
      plannedTreatment: 'High-definition OCT scan & Anti-VEGF evaluation',
      doctorNotes: 'Patient reports mild central blurring. Please review macular thickness scan before consultation.',
    ),
    AppointmentModel(
      id: 'APT-103',
      time: '01:15 PM',
      patientName: 'Elena Rodriguez',
      patientId: 'P-4094',
      type: 'Routine Post-op Checkup',
      room: 'Room 204',
      status: 'Scheduled',
      statusColor: AppColors.outline,
      isVisitingDoctor: false,
    ),
    AppointmentModel(
      id: 'APT-104',
      time: '02:30 PM',
      patientName: 'James Wilson',
      patientId: 'P-4095',
      type: 'Glaucoma Pressure Screening',
      room: 'Room 105',
      status: 'Scheduled',
      statusColor: AppColors.outline,
      isVisitingDoctor: false,
    ),
  ];

  void _handleStatusChange(AppointmentModel appointment, String newStatus) {
    setState(() {
      appointment.status = newStatus;
      if (newStatus == 'Completed') {
        appointment.statusColor = AppColors.primaryContainer;
      } else if (newStatus == 'Cancelled') {
        appointment.statusColor = AppColors.error;
      }
    });

    if (newStatus == 'Completed' || newStatus == 'Cancelled') {
      _promptScheduleNextAppointment(appointment, newStatus);
    }
  }

  void _promptScheduleNextAppointment(AppointmentModel appointment, String triggerReason) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    triggerReason == 'Completed' ? Icons.check_circle_outline : Icons.cancel_outlined,
                    color: triggerReason == 'Completed' ? AppColors.primaryContainer : AppColors.error,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Appointment $triggerReason',
                    style: AppTypography.headlineMd,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Prompt follow-up for ${appointment.patientName} (${appointment.patientId})',
                style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.md),
              Text('Schedule Next Appointment:', style: AppTypography.labelCaps.copyWith(color: AppColors.primary)),
              const SizedBox(height: AppSpacing.sm),

              // Option 1: Tomorrow
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  side: const BorderSide(color: AppColors.outlineVariant),
                ),
                leading: const Icon(Icons.today, color: AppColors.primary),
                title: const Text('Tomorrow'),
                subtitle: const Text('Schedule for Aug 4, 2026'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  _confirmNextAppointmentScheduled(appointment.patientName, 'Tomorrow (Aug 4, 2026)');
                },
              ),
              const SizedBox(height: AppSpacing.xs),

              // Option 2: Next Week
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  side: const BorderSide(color: AppColors.outlineVariant),
                ),
                leading: const Icon(Icons.date_range, color: AppColors.secondary),
                title: const Text('Next Week'),
                subtitle: const Text('Schedule for Aug 10, 2026'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  _confirmNextAppointmentScheduled(appointment.patientName, 'Next Week (Aug 10, 2026)');
                },
              ),
              const SizedBox(height: AppSpacing.xs),

              // Option 3: Schedule Later
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  side: const BorderSide(color: AppColors.outlineVariant),
                ),
                leading: const Icon(Icons.edit_calendar, color: AppColors.tertiary),
                title: const Text('Schedule Later'),
                subtitle: const Text('Select a custom future date'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 14)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    final formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    _confirmNextAppointmentScheduled(appointment.patientName, formattedDate);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmNextAppointmentScheduled(String patientName, String dateStr) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.event_available, color: Colors.white),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text('Follow-up appointment for $patientName queued for $dateStr'),
            ),
          ],
        ),
      ),
    );
  }

  void _showWhatsAppReminderModal(AppointmentModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
          titlePadding: const EdgeInsets.all(AppSpacing.md),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF25D366),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.message, color: Colors.white, size: 18),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Expanded(
                child: Text('Automated WhatsApp Reminder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25D366).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Color(0xFF128C7E), size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Visiting Doctor Clinical Context automatically attached.',
                          style: AppTypography.labelCaps.copyWith(color: const Color(0xFF128C7E), fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE5DD),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📋 *VISITING DOCTOR CLINICAL SUMMARY*',
                        style: AppTypography.labelCaps.copyWith(color: const Color(0xFF075E54), fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text('👤 *Patient Name:* ${item.patientName} (${item.patientId})', style: AppTypography.bodySm),
                      Text('📅 *Appointment:* Today @ ${item.time} (${item.room})', style: AppTypography.bodySm),
                      Text('👨‍⚕️ *Visiting Specialist:* ${item.doctorName} (${item.specialty})', style: AppTypography.bodySm),
                      const Divider(height: 12),
                      Text('🔍 *Previous Visit Summary:* ${item.previousVisitSummary}', style: AppTypography.bodySm),
                      Text('💉 *Previous Treatment:* ${item.previousTreatment}', style: AppTypography.bodySm),
                      Text('🩺 *Current Diagnosis:* ${item.currentDiagnosis}', style: AppTypography.bodySm),
                      Text('🎯 *Planned Treatment:* ${item.plannedTreatment}', style: AppTypography.bodySm),
                      Text('📌 *Important Notes:* "${item.doctorNotes}"', style: AppTypography.bodySm.copyWith(fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF128C7E),
                    behavior: SnackBarBehavior.floating,
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text('WhatsApp reminder with clinical summary sent to ${item.doctorName}'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.send, size: 16),
              label: const Text('Send WhatsApp Reminder'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

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
                    Text('My Schedule', style: AppTypography.displayLg.copyWith(color: AppColors.onBackground)),
                    const SizedBox(height: AppSpacing.xs),
                    Text('Today, Monday, August 3, 2026', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wb_sunny_outlined, color: AppColors.primaryContainer, size: 20),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MORNING SHIFT', style: AppTypography.labelCaps.copyWith(color: AppColors.primaryContainer)),
                          Text('07:00 AM – 03:00 PM', style: AppTypography.dataMono.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('My Schedule', style: AppTypography.displayLg.copyWith(color: AppColors.onBackground, fontSize: 28)),
                const SizedBox(height: AppSpacing.xs),
                Text('Today, Monday, August 3, 2026', style: AppTypography.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.primaryContainer.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wb_sunny_outlined, color: AppColors.primaryContainer, size: 20),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MORNING SHIFT', style: AppTypography.labelCaps.copyWith(color: AppColors.primaryContainer)),
                      Text('07:00 AM – 03:00 PM', style: AppTypography.dataMono.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          // AI Scheduling Tip Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 24),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'AI Tip: Visiting Doctor Dr. Robert Sterling consults at 10:30 AM. Patient clinical context is automatically attached to WhatsApp reminders.',
                    style: AppTypography.bodyMd.copyWith(color: AppColors.onSurface),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Appointment Timeline
          Text("Today's Appointments", style: AppTypography.headlineMd),
          const SizedBox(height: AppSpacing.md),

          ..._appointments.map((item) => _buildTimelineCard(item)),
        ],
      ),
    );
  }

  Widget _buildTimelineCard(AppointmentModel item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              item.time,
              style: AppTypography.dataMono.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 4, right: 12),
            decoration: BoxDecoration(shape: BoxShape.circle, color: item.statusColor),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: item.isVisitingDoctor ? AppColors.secondary.withValues(alpha: 0.5) : AppColors.outlineVariant,
                  width: item.isVisitingDoctor ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(item.patientName, style: AppTypography.bodyMd.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                Text('(${item.patientId})', style: AppTypography.dataMono.copyWith(fontSize: 12, color: AppColors.outline)),
                                if (item.isVisitingDoctor) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryContainer.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: AppColors.secondary.withValues(alpha: 0.5)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.person_pin_outlined, size: 12, color: AppColors.secondary),
                                        const SizedBox(width: 4),
                                        Text(
                                          'VISITING DOCTOR',
                                          style: AppTypography.labelCaps.copyWith(color: AppColors.secondary, fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.type} • ${item.room}',
                              style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (item.isVisitingDoctor && item.doctorName != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${item.doctorName} (${item.specialty})',
                                style: AppTypography.bodySm.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.status,
                          style: AppTypography.labelCaps.copyWith(color: item.statusColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.xs),

                  // Actions Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item.isVisitingDoctor)
                        OutlinedButton.icon(
                          onPressed: () => _showWhatsAppReminderModal(item),
                          icon: const Icon(Icons.message, size: 14, color: Color(0xFF128C7E)),
                          label: const Text('WhatsApp Reminder (Auto Context)'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF128C7E),
                            side: const BorderSide(color: Color(0xFF25D366)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                      else
                        Text(
                          'Actions:',
                          style: AppTypography.labelCaps.copyWith(color: AppColors.outline),
                        ),
                      Row(
                        children: [
                          if (item.status != 'Completed')
                            TextButton.icon(
                              onPressed: () => _handleStatusChange(item, 'Completed'),
                              icon: const Icon(Icons.check_circle, size: 16, color: AppColors.primaryContainer),
                              label: const Text('Mark Completed'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryContainer,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          if (item.status != 'Cancelled') ...[
                            const SizedBox(width: 4),
                            TextButton.icon(
                              onPressed: () => _handleStatusChange(item, 'Cancelled'),
                              icon: const Icon(Icons.cancel, size: 16, color: AppColors.error),
                              label: const Text('Cancel'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.error,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
