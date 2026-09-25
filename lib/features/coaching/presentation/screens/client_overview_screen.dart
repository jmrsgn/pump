import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/enums/client_overview_tab.dart';
import 'package:pump/features/coaching/presentation/provider/training_block_providers.dart';
import 'package:pump/features/coaching/presentation/screens/client_info_screen.dart';
import 'package:pump/features/coaching/presentation/screens/progress_and_analytics_screen.dart';
import 'package:pump/features/coaching/presentation/screens/training_block_screen.dart';

class ClientOverviewScreen extends ConsumerStatefulWidget {
  final ClientUser client;

  const ClientOverviewScreen({super.key, required this.client});

  @override
  ConsumerState<ClientOverviewScreen> createState() =>
      _ClientOverviewScreenState();
}

extension ClientOverviewTabExtension on ClientOverviewTab {
  String get title => switch (this) {
    ClientOverviewTab.clientInfo => AppStrings.clientInfo,
    ClientOverviewTab.progress => AppStrings.progressAndAnalytics,
    ClientOverviewTab.trainingBlock => AppStrings.trainingBlock,
  };
}

class _ClientOverviewScreenState extends ConsumerState<ClientOverviewScreen> {
  ClientOverviewTab _selectedTab = ClientOverviewTab.clientInfo;

  List<ClientOverviewTab> get _visibleTabs {
    if (ref
            .read(clientInfoScreenViewModelProvider(widget.client.id))
            .trainingBlock ==
        null) {
      return [ClientOverviewTab.clientInfo];
    }

    return [
      ClientOverviewTab.clientInfo,
      ClientOverviewTab.progress,
      ClientOverviewTab.trainingBlock,
    ];
  }

  List<BottomNavigationBarItem> get _navigationItems {
    return _visibleTabs.map((tab) {
      return BottomNavigationBarItem(
        icon: Icon(_getTabIcon(tab)),
        label: tab.title,
      );
    }).toList();
  }

  IconData _getTabIcon(ClientOverviewTab tab) {
    return switch (tab) {
      ClientOverviewTab.clientInfo => Icons.person,
      ClientOverviewTab.progress => Icons.show_chart,
      ClientOverviewTab.trainingBlock => Icons.fitness_center,
    };
  }

  void _onTabSelected(ClientOverviewTab tab) {
    if (!_visibleTabs.contains(tab)) {
      return;
    }

    setState(() {
      _selectedTab = tab;
    });
  }

  void _onBottomNavTapped(int index) {
    if (index < 0 || index >= _visibleTabs.length) {
      return;
    }

    setState(() {
      _selectedTab = _visibleTabs[index];
    });
  }

  Widget _buildCurrentScreen() {
    return switch (_selectedTab) {
      ClientOverviewTab.clientInfo => ClientInfoScreen(
        client: widget.client,
        onNavigateToTab: _onTabSelected,
      ),
      ClientOverviewTab.progress => const ProgressAndAnalyticsScreen(),
      ClientOverviewTab.trainingBlock => TrainingBlockScreen(
        trainingBlock: ref
            .read(clientInfoScreenViewModelProvider(widget.client.id))
            .trainingBlock!,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(clientInfoScreenViewModelProvider(widget.client.id));
    final showBottomNavigation = _visibleTabs.length >= 2;

    return CustomScaffold(
      appBarTitle: _selectedTab.title,
      body: _buildCurrentScreen(),
      bottomNavigationBar: showBottomNavigation
          ? CustomBottomNavigationBar(
              items: _navigationItems,
              selectedIndex: _visibleTabs.indexOf(_selectedTab),
              onItemTapped: _onBottomNavTapped,
            )
          : null,
    );
  }
}
