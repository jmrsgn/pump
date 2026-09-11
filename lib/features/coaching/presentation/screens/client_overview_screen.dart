import 'package:flutter/material.dart';
import 'package:pump/core/constants/app/app_strings.dart';
import 'package:pump/core/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:pump/core/presentation/widgets/custom_scaffold.dart';
import 'package:pump/features/coaching/presentation/screens/client_info_screen.dart';
import 'package:pump/features/coaching/presentation/screens/progress_and_analytics_screen.dart';
import 'package:pump/features/coaching/presentation/screens/training_block_screen.dart';
import 'package:pump/features/coaching/enums/client_overview_tab.dart';

class ClientOverviewScreen extends StatefulWidget {
  const ClientOverviewScreen({super.key});

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

  static const List<BottomNavigationBarItem> _navigationItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: AppStrings.clientInfo,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.show_chart),
      label: AppStrings.progressAndAnalytics,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.fitness_center),
      label: AppStrings.trainingBlock,
    ),
  ];

  void _onTabSelected(ClientOverviewTab tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedTab = ClientOverviewTab.values[index];
    });
  }

  Widget _buildCurrentScreen() {
    return switch (_selectedTab) {
      ClientOverviewTab.clientInfo => ClientInfoScreen(
        onNavigateToTab: _onTabSelected,
      ),
      ClientOverviewTab.progress => const ProgressAndAnalyticsScreen(),
      ClientOverviewTab.trainingBlock => const TrainingBlockScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: _selectedTab.title,
      body: _buildCurrentScreen(),
      bottomNavigationBar: CustomBottomNavigationBar(
        items: _navigationItems,
        selectedIndex: _selectedTab.index,
        onItemTapped: _onBottomNavTapped,
      ),
    );
  }
}
