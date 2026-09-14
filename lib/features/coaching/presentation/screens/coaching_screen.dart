import 'package:flutter/material.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/core/app_routes.dart';

class CoachingScreen extends StatelessWidget {
  const CoachingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary hardcoded role.
    // This will eventually come from the authenticated user.
    const bool isCoach = true;

    return CustomScaffold(
      appBarTitle: 'Coaching',
      backgroundColor: AppColors.background,
      body: _buildBody(context, isCoach),
    );
  }

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  Widget _buildBody(BuildContext context, bool isCoach) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        top: AppDimens.padding16,
        left: AppDimens.padding16,
        right: AppDimens.padding16,
        bottom: AppDimens.padding16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isCoach),
          UiUtils.addVerticalSpaceL(),
          if (isCoach)
            _buildCoachContent(context)
          else
            _buildClientContent(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(bool isCoach) {
    return Text(
      isCoach
          ? 'Manage your clients and coaching.'
          : 'Manage your coaching experience.',
      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
    );
  }

  // ---------------------------------------------------------------------------
  // Coach
  // ---------------------------------------------------------------------------

  Widget _buildCoachContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Coach'),
        UiUtils.addVerticalSpaceM(),

        _buildActionCard(
          icon: Icons.people_outline,
          title: 'My Clients',
          description: 'View and manage your clients.',
          onTap: () {
            NavigationUtils.navigateTo(context, AppRoutes.clients);
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Client
  // ---------------------------------------------------------------------------

  Widget _buildClientContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('My Coaching'),
        UiUtils.addVerticalSpaceM(),

        _buildActionCard(
          icon: Icons.fitness_center_outlined,
          title: 'Training',
          description: 'View your training information and block.',
          onTap: () {
            // TODO:
            // Navigate to the client's own training screen.
          },
        ),

        UiUtils.addVerticalSpaceM(),

        _buildActionCard(
          icon: Icons.badge_outlined,
          title: 'My Coach',
          description: 'View information about your coach.',
          onTap: () {
            NavigationUtils.navigateTo(context, AppRoutes.myCoach);
          },
        ),

        UiUtils.addVerticalSpaceM(),

        _buildActionCard(
          icon: Icons.credit_card_outlined,
          title: 'Payment Method',
          description: 'Manage your coaching payment method.',
          onTap: () {
            NavigationUtils.navigateTo(context, AppRoutes.paymentMethod);
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Section Title
  // ---------------------------------------------------------------------------

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(fontSize: AppDimens.textSize16),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Card
  // ---------------------------------------------------------------------------

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimens.dimen16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.padding16),
          child: Row(
            children: [
              _buildActionIcon(icon),

              UiUtils.addHorizontalSpaceM(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    UiUtils.addVerticalSpaceXS(),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),

              UiUtils.addHorizontalSpaceS(),

              Icon(
                Icons.chevron_right,
                size: AppDimens.dimen22,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Icon
  // ---------------------------------------------------------------------------

  Widget _buildActionIcon(IconData icon) {
    return Container(
      width: AppDimens.dimen44,
      height: AppDimens.dimen44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimens.dimen12),
      ),
      child: Icon(icon, size: AppDimens.dimen22, color: AppColors.primary),
    );
  }
}
