import 'package:flutter/material.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/features/coaching/domain/entity/client_user.dart';
import 'package:pump/features/coaching/enums/client_overview_tab.dart';
import 'package:pump/features/coaching/presentation/screens/client_info_screen.dart';
import 'package:pump/features/coaching/presentation/screens/progress_and_analytics_screen.dart';
import 'package:pump/features/coaching/presentation/screens/training_block_screen.dart';

class ClientOverviewScreen extends StatefulWidget {
  final ClientUser client;

  const ClientOverviewScreen({super.key, required this.client});

  @override
  State<ClientOverviewScreen> createState() => _ClientOverviewScreenState();
}

extension ClientOverviewTabExtension on ClientOverviewTab {
  String get title => switch (this) {
    ClientOverviewTab.clientInfo => AppStrings.clientInfo,
    ClientOverviewTab.progress => AppStrings.progressAndAnalytics,
    ClientOverviewTab.trainingBlock => AppStrings.trainingBlock,
  };
}

class _ClientOverviewScreenState extends State<ClientOverviewScreen> {
  ClientOverviewTab _selectedTab = ClientOverviewTab.clientInfo;
  late final bool _hasTrainingBlock = widget.client.hasActiveTrainingBlock;

  List<ClientOverviewTab> get _visibleTabs {
    if (!_hasTrainingBlock) {
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
        hasTrainingBlock: _hasTrainingBlock,
        onNavigateToTab: _onTabSelected,
      ),
      ClientOverviewTab.progress => const ProgressAndAnalyticsScreen(),
      ClientOverviewTab.trainingBlock => const TrainingBlockScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
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
