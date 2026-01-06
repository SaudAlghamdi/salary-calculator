import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../providers/appointments_provider.dart';

/// شاشة المواعيد - Appointments Screen
///
/// تعرض مواعيد الراتب والتقاعد مع العد التنازلي

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.appointments),
        centerTitle: true,
      ),
      body: Consumer<AppointmentsProvider>(
        builder: (context, provider, _) {
          final appointments = provider.appointments;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 24),

                // عنوان القسم
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ArabicStrings.remainingUntil,
                    style: AppTextStyles.sectionTitle,
                  ),
                ),

                const SizedBox(height: 16),

                // قائمة المواعيد
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: List.generate(appointments.length, (index) {
                      final appointment = appointments[index];
                      return _AppointmentRow(
                        appointment: appointment,
                        showBorder: index < appointments.length - 1,
                        onEdit: () => _showEditDaySheet(context, provider, index),
                        onShare: () => _shareAppointment(context, appointment),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 16),

                // ملاحظة
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ArabicStrings.editSalaryDayHint,
                    style: AppTextStyles.secondaryLabel,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDaySheet(
    BuildContext context,
    AppointmentsProvider provider,
    int appointmentIndex,
  ) {
    final currentDay = provider.getDayByIndex(appointmentIndex);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditSalaryDaySheet(
        currentDay: currentDay,
        onSave: (day) async {
          await provider.updateAppointmentDay(appointmentIndex, day);
        },
      ),
    );
  }

  void _shareAppointment(BuildContext context, SalaryAppointment appointment) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final message = '${appointment.title}\n'
        'التاريخ: ${dateFormat.format(appointment.nextDate)}\n'
        'المتبقي: ${appointment.daysRemaining} يوم';
    Share.share(message);
  }
}

/// صف الموعد
class _AppointmentRow extends StatefulWidget {
  final SalaryAppointment appointment;
  final bool showBorder;
  final VoidCallback onEdit;
  final VoidCallback onShare;

  const _AppointmentRow({
    required this.appointment,
    required this.showBorder,
    required this.onEdit,
    required this.onShare,
  });

  @override
  State<_AppointmentRow> createState() => _AppointmentRowState();
}

class _AppointmentRowState extends State<_AppointmentRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.25, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleReveal() {
    setState(() {
      _isRevealed = !_isRevealed;
      if (_isRevealed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dayName = _getArabicDayName(widget.appointment.nextDate.weekday);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < -200) {
            _toggleReveal();
          } else if (details.primaryVelocity! > 200 && _isRevealed) {
            _toggleReveal();
          }
        }
      },
      onTap: () {
        if (_isRevealed) {
          _toggleReveal();
        } else {
          widget.onEdit();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: widget.showBorder
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.borderColor.withOpacity(0.3),
                    width: 0.5,
                  ),
                )
              : null,
        ),
        child: Stack(
          children: [
            // زر المشاركة
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      _toggleReveal();
                      widget.onShare();
                    },
                    child: Container(
                      width: 80,
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.ios_share,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ArabicStrings.share,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // المحتوى الرئيسي
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                color: AppColors.cardBackground,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    // الأيام المتبقية على اليسار
                    Text(
                      '${widget.appointment.daysRemaining} ${ArabicStrings.days}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    // العنوان والتاريخ على اليمين
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.appointment.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$dayName ${dateFormat.format(widget.appointment.nextDate)}',
                          style: AppTextStyles.secondaryLabel,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getArabicDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'الإثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      default:
        return '';
    }
  }
}

/// ورقة تعديل يوم الراتب
class _EditSalaryDaySheet extends StatefulWidget {
  final int currentDay;
  final Future<void> Function(int) onSave;

  const _EditSalaryDaySheet({
    required this.currentDay,
    required this.onSave,
  });

  @override
  State<_EditSalaryDaySheet> createState() => _EditSalaryDaySheetState();
}

class _EditSalaryDaySheetState extends State<_EditSalaryDaySheet> {
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.currentDay;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),

          // الأيقونة
          const Text(
            '💰',
            style: TextStyle(fontSize: 40),
          ),

          const SizedBox(height: 16),

          // العنوان
          Text(
            ArabicStrings.editSalaryDay,
            style: AppTextStyles.sectionTitle,
          ),

          const SizedBox(height: 16),

          // منتقي اليوم
          SizedBox(
            height: 200,
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: _selectedDay - 1,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedDay = index + 1;
                });
              },
              children: List.generate(28, (index) {
                final day = index + 1;
                final isSelected = day == _selectedDay;
                return Container(
                  alignment: Alignment.center,
                  decoration: isSelected
                      ? BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: isSelected ? 24 : 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),

          // ملاحظة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              ArabicStrings.editDayNote,
              style: AppTextStyles.secondaryLabel,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          // زر الحفظ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await widget.onSave(_selectedDay);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  ArabicStrings.save,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
