import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/commitment.dart';
import '../providers/commitments_provider.dart';
import '../widgets/add_commitment_sheet.dart';
import '../widgets/commitment_row.dart';

/// شاشة الإلتزامات المالية - Commitments Screen
///
/// شاشة لعرض وإدارة الإلتزامات المالية مثل:
/// - الفواتير والخدمات
/// - القروض والأقساط
/// - الإيجارات

/// شاشة الإلتزامات
/// Commitments Screen
class CommitmentsScreen extends StatelessWidget {
  const CommitmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ArabicStrings.financialCommitments),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _showAddCommitmentSheet(context),
        ),
        actions: [
          Consumer<CommitmentsProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: Icon(
                  provider.sortAscending
                      ? Icons.swap_vert
                      : Icons.swap_vert,
                ),
                onPressed: provider.toggleSort,
              );
            },
          ),
        ],
      ),
      body: Consumer<CommitmentsProvider>(
        builder: (context, provider, _) {
          final activeCommitments = provider.activeCommitments;
          final disabledCommitments = provider.disabledCommitments;
          final hasCommitments = activeCommitments.isNotEmpty ||
              disabledCommitments.isNotEmpty;

          if (!hasCommitments) {
            return _buildEmptyState(context);
          }

          return Column(
            children: [
              // قائمة الإلتزامات
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // الإلتزامات الشهرية المفعّلة
                      if (activeCommitments.isNotEmpty) ...[
                        _buildSectionHeader(ArabicStrings.monthlyCommitments),
                        _buildCommitmentsList(
                          context,
                          activeCommitments,
                          provider,
                        ),
                      ],

                      // الإلتزامات المعطّلة
                      if (disabledCommitments.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildSectionHeader(ArabicStrings.disabledCommitments),
                        _buildCommitmentsList(
                          context,
                          disabledCommitments,
                          provider,
                          isDisabled: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // شريط المجموع
              if (activeCommitments.isNotEmpty)
                CommitmentsTotalBar(
                  totalMonthly: provider.totalMonthlyCommitments,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد إلتزامات مالية',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'اضغط على + لإضافة إلتزام جديد',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddCommitmentSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('إضافة إلتزام'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.inputBackground,
                foregroundColor: AppColors.textGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: AppTextStyles.sectionTitle,
      ),
    );
  }

  Widget _buildCommitmentsList(
    BuildContext context,
    List<Commitment> commitments,
    CommitmentsProvider provider, {
    bool isDisabled = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(commitments.length, (index) {
          final commitment = commitments[index];
          return CommitmentRow(
            commitment: commitment,
            showBorder: index < commitments.length - 1,
            onTap: () => _showEditCommitmentSheet(context, commitment),
            onToggle: () => provider.toggleCommitmentStatus(commitment.id),
            onDelete: () => provider.deleteCommitment(commitment.id),
          );
        }),
      ),
    );
  }

  void _showAddCommitmentSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCommitmentSheet(),
    );

    if (result != null && context.mounted) {
      final provider = context.read<CommitmentsProvider>();
      await provider.addCommitment(
        name: result['name'] as String,
        type: result['type'] as CommitmentType,
        cycle: result['cycle'] as CommitmentCycle,
        amount: result['amount'] as double,
      );
    }
  }

  void _showEditCommitmentSheet(
    BuildContext context,
    Commitment commitment,
  ) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCommitmentSheet(editCommitment: commitment),
    );

    if (result != null && context.mounted) {
      final provider = context.read<CommitmentsProvider>();
      await provider.updateCommitment(
        commitment.copyWith(
          name: result['name'] as String,
          type: result['type'] as CommitmentType,
          cycle: result['cycle'] as CommitmentCycle,
          amount: result['amount'] as double,
        ),
      );
    }
  }
}
