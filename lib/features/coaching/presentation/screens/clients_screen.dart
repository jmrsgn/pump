import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pump/core/app_routes.dart';
import 'package:pump/core/constants/app/app_dimens.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/constants/app/ui_constants.dart';
import 'package:pump/core/presentation/theme/app_colors.dart';
import 'package:pump/core/presentation/theme/app_text_styles.dart';
import 'package:pump/core/presentation/widgets/custom_button.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/core/presentation/widgets/custom_text_field.dart';
import 'package:pump/core/utils/navigation_utils.dart';
import 'package:pump/core/utils/ui_utils.dart';
import 'package:pump/features/coaching/data/enums/coaching_status.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/presentation/provider/client_user_providers.dart';
import 'package:pump/features/coaching/presentation/viewmodels/clients_viewmodel.dart';

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
      // TODO: FOR NOW, always page is 0, implement scrolling.
      _clientsViewModel.getClientUsers(0);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
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
        body: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: _refreshClients,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
            children: [
              UiUtils.addVerticalSpaceS(),

              _buildSearchField(),

              UiUtils.addVerticalSpaceL(),

              _buildOverviewSection(clients),

              UiUtils.addVerticalSpaceL(),

              if (clients.isEmpty)
                _buildEmptyState()
              else
                ..._buildClientList(context, clients),

              // Prevent the floating action button from covering
              // the last client card.
              UiUtils.addVerticalSpaceXXL(),
              UiUtils.addVerticalSpaceXXL(),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.dimen8),
          child: CustomButton(
            prefixIcon: Icons.add_rounded,
            label: AppStrings.enroll,
            onPressed: () async {
              _searchController.clear();

              final result = await NavigationUtils.navigateTo(
                context,
                AppRoutes.enrollClient,
              );

              if (result == true && mounted) {
                await _refreshClients();
              }
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen16),
      ),
      child: CustomTextField(
        controller: _searchController,
        hint: AppStrings.searchClients,
        prefixIcon: const Icon(Icons.search_rounded),
        onChanged: (value) {
          _clientsViewModel.searchClients(value);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Overview
  // ---------------------------------------------------------------------------

  Widget _buildOverviewSection(List<ClientUser> clients) {
    final activeClients = clients.where(
      (client) => client.coachingStatus == CoachingStatus.active,
    );

    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            title: 'Total Clients',
            value: clients.length.toString(),
            icon: const Icon(
              Icons.people_outline,
              size: AppDimens.dimen20,
              color: AppColors.primary,
            ),
          ),
        ),

        UiUtils.addHorizontalSpaceM(),

        Expanded(
          child: _buildOverviewCard(
            title: 'Active',
            value: activeClients.length.toString(),
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              size: AppDimens.dimen20,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required Widget icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.dimen16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.dimen20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.dimen10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimens.dimen14),
            ),
            child: icon,
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

  // ---------------------------------------------------------------------------
  // Client List
  // ---------------------------------------------------------------------------

  List<Widget> _buildClientList(
    BuildContext context,
    List<ClientUser> clients,
  ) {
    return [
      for (int index = 0; index < clients.length; index++) ...[
        _buildClientCard(context, client: clients[index]),

        if (index != clients.length - 1) UiUtils.addVerticalSpaceM(),
      ],
    ];
  }

  Widget _buildClientCard(BuildContext context, {required ClientUser client}) {
    final name = '${client.firstName} ${client.lastName}';
    final profileImageUrl = client.profileImageUrl;
    final goal = client.fitnessGoal.value;
    final weight = '${client.currentWeight.toStringAsFixed(0)} kg';

    const lastCheckIn = '--';

    final isActive = client.coachingStatus == CoachingStatus.active;

    return GestureDetector(
      onTap: () {
        NavigationUtils.navigateTo(
          context,
          AppRoutes.clientOverview,
          arguments: client,
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: UIConstants.milliseconds180),
        padding: const EdgeInsets.all(AppDimens.dimen16),
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
                        padding: const EdgeInsets.symmetric(
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
                          client.coachingStatus.value,
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
                        icon: const Icon(
                          Icons.monitor_weight_outlined,
                          size: AppDimens.dimen12,
                          color: AppColors.textSecondary,
                        ),
                        label: weight,
                      ),

                      UiUtils.addHorizontalSpaceS(),

                      _buildInfoChip(
                        icon: const FaIcon(
                          FontAwesomeIcons.clock,
                          size: AppDimens.dimen12,
                          color: AppColors.textSecondary,
                        ),
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

  // ---------------------------------------------------------------------------
  // Empty State
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.dimen40),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: AppDimens.dimen40,
            color: AppColors.textHint,
          ),

          UiUtils.addVerticalSpaceM(),

          Text(
            'No clients yet',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),

          UiUtils.addVerticalSpaceXS(),

          Text(
            'Pull down to refresh or enroll a new client.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  Widget _buildProfileAvatar({
    required String name,
    required String profileImageUrl,
  }) {
    if (profileImageUrl.isEmpty) {
      return CircleAvatar(
        radius: AppDimens.dimen36,
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        child: Text(
          name.isEmpty ? '?' : name[0],
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: AppDimens.dimen36,
      backgroundImage: NetworkImage(profileImageUrl),
    );
  }

  Widget _buildInfoChip({required Widget icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.dimen10,
        vertical: AppDimens.dimen6,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.dimen50),
      ),
      child: Row(
        children: [
          icon,

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

  // ---------------------------------------------------------------------------
  // Methods
  // ---------------------------------------------------------------------------

  Future<void> _refreshClients() async {
    FocusScope.of(context).unfocus();

    _searchController.clear();

    await _clientsViewModel.getClientUsers(0);
  }
}
