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
import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/enums/coaching_status.dart';
import 'package:pump/features/coaching/presentation/provider/client_user_providers.dart';
import 'package:pump/features/coaching/presentation/viewmodels/clients_viewmodel.dart';

import '../../../../core/constants/app/ui_constants.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  final _searchController = TextEditingController();

  ClientsViewModel get _clientsViewModel =>
      ref.read(clientsViewModelProvider.notifier);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // TODO: FOR NOW, always page is 0, implement scrolling
      _clientsViewModel.getClientUsers(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(clientsViewModelProvider);
    final clients = clientsState.clients;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        isLoading: clientsState.isLoading,
        backgroundColor: AppColors.background,
        appBarTitle: AppStrings.clients,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
          child: Column(
            children: [
              UiUtils.addVerticalSpaceS(),

              _buildSearchField(),

              UiUtils.addVerticalSpaceL(),

              _buildOverviewSection(clients),

              UiUtils.addVerticalSpaceL(),

              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: clients.length,
                  separatorBuilder: (_, __) => UiUtils.addVerticalSpaceM(),
                  itemBuilder: (context, index) {
                    final client = clients[index];

                    return _buildClientCard(context, client: client);
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
            onPressed: () async {
              final result = await NavigationUtils.navigateTo(
                context,
                AppRoutes.enrollClient,
              );

              if (result == true) {
                _clientsViewModel.getClientUsers(0);
              }
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
        onChanged: (value) {
          ref.read(clientsViewModelProvider.notifier).searchClients(value);
        },
      ),
    );
  }

  Widget _buildOverviewSection(List<ClientUser> clients) {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            title: 'Total Clients',
            value: clients.length.toString(),
            icon: FontAwesomeIcons.users,
          ),
        ),

        UiUtils.addHorizontalSpaceM(),

        Expanded(
          child: _buildOverviewCard(
            title: 'Active',
            value: clients.length.toString(),
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

  Widget _buildClientCard(BuildContext context, {required ClientUser client}) {
    final name = '${client.firstName} ${client.lastName}';
    final profileImageUrl = client.profileImageUrl;
    final goal = client.fitnessGoal.value;
    final weight = '${client.currentWeight.toStringAsFixed(0)} kg';

    const lastCheckIn = '--';

    final bool isActive = client.status == CoachingStatus.active;

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
          crossAxisAlignment: CrossAxisAlignment.center,
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

                      UiUtils.addHorizontalSpaceM(),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.dimen10,
                          vertical: AppDimens.dimen4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.success.withValues(
                                  alpha: AppDimens.alpha0_12,
                                )
                              : AppColors.error.withValues(
                                  alpha: AppDimens.alpha0_12,
                                ),
                          borderRadius: BorderRadius.circular(
                            AppDimens.dimen50,
                          ),
                        ),
                        child: Text(
                          client.status.toString(),
                          style: AppTextStyles.caption.copyWith(
                            color: isActive
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w600,
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

                  UiUtils.addVerticalSpaceM(),

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
        radius: AppDimens.dimen36,
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        child: Text(
          name.isEmpty ? "?" : name[0],
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    return CircleAvatar(
      backgroundImage: profileImageUrl.isEmpty
          ? null
          : NetworkImage(profileImageUrl),
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
