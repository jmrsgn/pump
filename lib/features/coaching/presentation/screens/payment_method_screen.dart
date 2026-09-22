import 'package:flutter/material.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/utils/ui_utils.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Payment Method',
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.padding16,
          AppDimens.padding16,
          AppDimens.padding16,
          AppDimens.padding24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlanHeader(),

            UiUtils.addVerticalSpaceL(),

            _buildSectionLabel('Payment Method'),

            UiUtils.addVerticalSpaceS(),

            _buildPaymentCard(),

            UiUtils.addVerticalSpaceM(),

            _buildAddPaymentMethodButton(context),

            UiUtils.addVerticalSpaceL(),

            _buildSectionLabel('Billing'),

            UiUtils.addVerticalSpaceS(),

            _buildBillingSection(),

            UiUtils.addVerticalSpaceL(),

            _buildSectionLabel('Payment History'),

            UiUtils.addVerticalSpaceS(),

            _buildPaymentHistory(),

            UiUtils.addVerticalSpaceL(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Plan Header
  // ---------------------------------------------------------------------------

  Widget _buildPlanHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: AppDimens.dimen48,
          height: AppDimens.dimen48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimens.dimen14),
          ),
          child: Icon(
            Icons.fitness_center_outlined,
            size: AppDimens.dimen24,
            color: AppColors.primary,
          ),
        ),

        UiUtils.addHorizontalSpaceM(),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Premium Coaching',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              UiUtils.addVerticalSpaceXS(),

              Text(
                'Monthly coaching plan',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),

        _buildStatusBadge(label: 'Active', color: AppColors.success),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Payment Method
  // ---------------------------------------------------------------------------

  Widget _buildPaymentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.padding16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'VISA',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),

              const Spacer(),

              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_horiz, color: AppColors.textHint),
                onSelected: (value) {
                  // TODO: Handle payment method actions.
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'remove', child: Text('Remove')),
                ],
              ),
            ],
          ),

          UiUtils.addVerticalSpaceL(),

          Text(
            '••••  ••••  ••••  4242',
            style: AppTextStyles.heading3.copyWith(letterSpacing: 2),
          ),

          UiUtils.addVerticalSpaceL(),

          Row(
            children: [
              Expanded(
                child: _buildCardDetail(
                  label: 'Cardholder',
                  value: 'John Martin',
                ),
              ),

              Expanded(
                child: _buildCardDetail(label: 'Expires', value: '08/28'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetail({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
            fontSize: AppDimens.dimen10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),

        UiUtils.addVerticalSpaceXS(),

        Text(
          value,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildAddPaymentMethodButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        prefixIcon: Icons.add,
        isOutlineButton: true,
        onPressed: () {
          UiUtils.showSnackBarSuccess(
            context,
            message: 'Add payment method will be available later.',
          );
        },
        label: 'Add Payment Method',
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Billing
  // ---------------------------------------------------------------------------

  Widget _buildBillingSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: Column(
        children: [
          _buildBillingRow(label: 'Next Payment', value: 'October 15, 2026'),

          _buildDivider(),

          _buildBillingRow(label: 'Billing Cycle', value: 'Monthly'),

          _buildDivider(),

          _buildBillingRow(label: 'Member Since', value: 'January 2026'),

          _buildDivider(),

          _buildBillingRow(
            label: 'Status',
            value: 'Active',
            valueColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.padding16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ),

          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Payment History
  // ---------------------------------------------------------------------------

  Widget _buildPaymentHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.padding16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: Column(
        children: [
          _buildPaymentHistoryItem(
            date: 'September 15, 2026',
            description: 'Premium Coaching',
            amount: 'Monthly',
            status: 'Paid',
          ),

          _buildDivider(),

          _buildPaymentHistoryItem(
            date: 'August 15, 2026',
            description: 'Premium Coaching',
            amount: 'Monthly',
            status: 'Paid',
          ),

          _buildDivider(),

          _buildPaymentHistoryItem(
            date: 'July 15, 2026',
            description: 'Premium Coaching',
            amount: 'Monthly',
            status: 'Paid',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistoryItem({
    required String date,
    required String description,
    required String amount,
    required String status,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.padding16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppDimens.dimen40,
            height: AppDimens.dimen40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimens.dimen12),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: AppDimens.dimen20,
              color: AppColors.primary,
            ),
          ),

          UiUtils.addHorizontalSpaceM(),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                UiUtils.addVerticalSpaceXS(),

                Text(
                  '$date • $amount',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),

          _buildStatusBadge(label: status, color: AppColors.success),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Shared Components
  // ---------------------------------------------------------------------------

  Widget _buildSectionLabel(String title) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textHint,
        fontSize: AppDimens.dimen10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildStatusBadge({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.padding8,
        vertical: AppDimens.padding4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.dimen50),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: AppColors.textHint.withValues(alpha: 0.12),
    );
  }
}
