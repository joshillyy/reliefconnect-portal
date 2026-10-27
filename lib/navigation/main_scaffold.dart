import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/widgets/app_logo.dart';
import '../core/widgets/demo_mode_banner.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../screens/activity/activity_feed_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/manage_requests_screen.dart';
import '../screens/admin/manage_tasks_screen.dart';
import '../screens/admin/manage_volunteers_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/impact/emergency_preparedness_screen.dart';
import '../screens/impact/sdg_impact_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/requests/my_requests_screen.dart';
import '../screens/requests/submit_request_screen.dart';
import '../screens/tasks/browse_tasks_screen.dart';
import '../screens/volunteer/volunteer_dashboard_screen.dart';
import '../screens/volunteer/volunteer_my_tasks_screen.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProv = Provider.of<AuthProvider>(context);
    final user = authProv.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    final role = user.role;

    // Build role-specific tabs and destinations
    List<Widget> screens;
    List<NavigationDestination> destinations;
    String screenTitle;

    switch (role) {
      case UserRole.admin:
        screens = const [
          AdminDashboardScreen(),
          ManageRequestsScreen(),
          ManageTasksScreen(),
          ManageVolunteersScreen(),
          ActivityFeedScreen(),
        ];
        destinations = const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.engineering_outlined),
            selectedIcon: Icon(Icons.engineering_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_rounded),
            label: 'Volunteers',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_active_outlined),
            selectedIcon: Icon(Icons.notifications_active_rounded),
            label: 'Activity',
          ),
        ];
        screenTitle = 'Relief Command Center';
        break;

      case UserRole.requester:
        screens = const [
          SubmitRequestScreen(),
          MyRequestsScreen(),
          BrowseTasksScreen(),
          EmergencyPreparednessScreen(),
          ProfileScreen(),
        ];
        destinations = const [
          NavigationDestination(
            icon: Icon(Icons.add_alert_outlined),
            selectedIcon: Icon(Icons.add_alert_rounded),
            label: 'New Request',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'My Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism_outlined),
            selectedIcon: Icon(Icons.volunteer_activism_rounded),
            label: 'Relief Hub',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield_rounded),
            label: 'Emergency',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ];
        screenTitle = 'Relief Request Portal';
        break;

      case UserRole.volunteer:
        screens = const [
          VolunteerDashboardScreen(),
          BrowseTasksScreen(),
          VolunteerMyTasksScreen(),
          MyRequestsScreen(),
          ProfileScreen(),
        ];
        destinations = const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.saved_search_rounded),
            label: 'Browse Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt_rounded),
            label: 'My Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_rounded),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ];
        screenTitle = AppStrings.appName;
        break;
    }

    if (_currentIndex >= screens.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const AppLogo(size: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(screenTitle),
                  Text(
                    '${user.name} • ${user.role.displayName}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'UN SDG & Social Impact',
            icon: const Icon(Icons.public_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SdgImpactScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Emergency Preparedness',
            icon: const Icon(
              Icons.emergency_rounded,
              color: Colors.orangeAccent,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmergencyPreparednessScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              accountName: Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.dashboard_rounded,
                color: AppColors.primary,
              ),
              title: const Text('Portal Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.public_rounded, color: AppColors.teal),
              title: const Text('UN SDG & Social Impact'),
              subtitle: const Text('SDG 11, SDG 13, SDG 3'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SdgImpactScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.medical_services_outlined,
                color: AppColors.emergency,
              ),
              title: const Text('Disaster Preparedness'),
              subtitle: const Text('Emergency kit & safety checklist'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmergencyPreparednessScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
              ),
              title: const Text('Activity & Alert Feed'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ActivityFeedScreen()),
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Switch Demo Role for Viva:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            ListTile(
              dense: true,
              leading: const Icon(
                Icons.volunteer_activism,
                size: 20,
                color: AppColors.teal,
              ),
              title: const Text('Switch to Demo Volunteer'),
              onTap: () {
                authProv.loginAsDemoRole(UserRole.volunteer);
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(
                Icons.help_center_rounded,
                size: 20,
                color: AppColors.emergency,
              ),
              title: const Text('Switch to Demo Requester'),
              onTap: () {
                authProv.loginAsDemoRole(UserRole.requester);
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(
                Icons.admin_panel_settings_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              title: const Text('Switch to Demo Admin'),
              onTap: () {
                authProv.loginAsDemoRole(UserRole.admin);
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: AppColors.emergency,
              ),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: AppColors.emergency),
              ),
              onTap: () async {
                await authProv.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      body: Column(
        children: [
          const DemoModeBanner(),
          Expanded(child: screens[_currentIndex]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: destinations,
      ),
    );
  }
}
