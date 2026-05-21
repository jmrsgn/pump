import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/presentation/widgets/custom_text_field.dart';
import 'package:pump/core/routes.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';

import '../../../../core/constants/app/ui_constants.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> clients = const [
    {
      'name': 'John Martin I. Marasigan',
      'status': 'Active',
      'image': 'assets/images/jm.jpg',
      'goal': 'Fat Loss',
      'weight': '63 kg',
      'lastCheckIn': '2h ago',
    },
    {
      'name': 'Romeo Jaranilla',
      'status': 'Inactive',
      'image': '',
      'goal': 'Muscle Gain',
      'weight': '71 kg',
      'lastCheckIn': '3 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        backgroundColor: AppColors.background,
        appBarTitle: AppStrings.clients,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
          child: Column(
            children: [
              UiUtils.addVerticalSpaceS(),

              _buildSearchField(),

              UiUtils.addVerticalSpaceL(),

              _buildOverviewSection(),

              UiUtils.addVerticalSpaceL(),

              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: clients.length,
                  separatorBuilder: (_, __) => UiUtils.addVerticalSpaceM(),
                  itemBuilder: (context, index) {
                    final client = clients[index];

                    return _buildClientCard(
                      context,
                      name: client['name'] as String? ?? '',
                      status: client['status'] as String? ?? '',
                      profileImageUrl: client['image'] as String? ?? '',
                      goal: client['goal'] as String? ?? '',
                      weight: client['weight'] as String? ?? '',
                      lastCheckIn: client['lastCheckIn'] as String? ?? '',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: AppDimens.dimen8),
          child: CustomButton(
            prefixIcon: Icons.add_rounded,
            label: AppStrings.enroll,
            onPressed: () {
              NavigationUtils.navigateTo(context, AppRoutes.enrollClient);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: CustomTextField(
        controller: _searchController,
        hint: AppStrings.searchClients,
        prefixIcon: Icons.search_rounded,
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            title: 'Total Clients',
            value: '${clients.length}',
            icon: FontAwesomeIcons.users,
          ),
        ),

        UiUtils.addHorizontalSpaceM(),

        Expanded(
          child: _buildOverviewCard(
            title: 'Active',
            value: clients
                .where((client) => client['status'] == 'Active')
                .length
                .toString(),
            icon: FontAwesomeIcons.fire,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimens.dimen16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.dimen10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimens.dimen14),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppDimens.dimen18,
            ),
          ),

          UiUtils.addVerticalSpaceM(),

          Text(
            value,
            style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.w700),
          ),

          UiUtils.addVerticalSpaceXS(),

          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(
    BuildContext context, {
    required String name,
    required String status,
    required String goal,
    required String weight,
    required String lastCheckIn,
    String profileImageUrl = '',
  }) {
    final bool isActive = status == 'Active';

    return GestureDetector(
      onTap: () {
        NavigationUtils.navigateTo(context, AppRoutes.clientOverview);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: UIConstants.milliseconds180),
        padding: EdgeInsets.all(AppDimens.dimen16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.dimen24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileAvatar(name: name, profileImageUrl: profileImageUrl),

            UiUtils.addHorizontalSpaceM(),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    goal,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  UiUtils.addVerticalSpaceXS(),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.dimen10,
                      vertical: AppDimens.dimen4,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.success.withValues(alpha: 0.12)
                          : AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppDimens.dimen50),
                    ),
                    child: Text(
                      status,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isActive ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  UiUtils.addVerticalSpaceXL(),

                  Row(
                    children: [
                      _buildInfoChip(
                        icon: FontAwesomeIcons.weightScale,
                        label: weight,
                      ),

                      UiUtils.addHorizontalSpaceS(),

                      _buildInfoChip(
                        icon: FontAwesomeIcons.clock,
                        label: lastCheckIn,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            UiUtils.addHorizontalSpaceS(),

            Icon(
              FontAwesomeIcons.chevronRight,
              size: AppDimens.dimen14,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar({
    required String name,
    required String profileImageUrl,
  }) {
    if (profileImageUrl.isEmpty) {
      return CircleAvatar(
        radius: AppDimens.dimen28,
        backgroundColor: AppColors.primary,
        child: Text(
          name[0],
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: AppDimens.dimen28,
      backgroundImage: AssetImage(profileImageUrl),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.dimen10,
        vertical: AppDimens.dimen6,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.dimen50),
      ),
      child: Row(
        children: [
          Icon(icon, size: AppDimens.dimen12, color: AppColors.textSecondary),

          UiUtils.addHorizontalSpaceS(),

          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
