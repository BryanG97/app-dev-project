import 'package:app_dev_project/presentation/screens/delivery_list/delivery_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  static const name = 'custom-navigation-bar';
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _child = const DeliveryListScreen();

  // Method to show the selected screen
  void _handleNavigationChange(int index) {
    // Implement your navigation logic here
    setState(() {
      switch (index) {
        case 0:
          _child = const DeliveryListScreen();
          break;
        case 1:
          //_child = const ProductAnalyticsScreen();
          break;

        /* case 2:
          //_scaffoldKey.currentState?.openDrawer();
          _child = const DrawerWidget2();
          break; */
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        duration: const Duration(milliseconds: 40),
        child: _child,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //endDrawer: const ProductChecklistScreen(),
      body: _child,
      bottomNavigationBar: FluidNavBar(
        itemBuilder: (icon, item) => Semantics(
          label: icon.extras!["label"],
          child: item,
        ),
        onChange: _handleNavigationChange,
        style: FluidNavBarStyle(iconUnselectedForegroundColor: Colors.white, barBackgroundColor: Theme.of(context).primaryColor),
        scaleFactor: 1.5,
        defaultIndex: 0,
        icons: [
          FluidNavBarIcon(icon: Icons.list, selectedForegroundColor: Colors.white, extras: {"label": "list"}),
          FluidNavBarIcon(icon: Icons.analytics_outlined, selectedForegroundColor: Colors.white, extras: {"label": "calendar"}),
          FluidNavBarIcon(icon: Icons.account_circle_outlined, selectedForegroundColor: Colors.white, extras: {"label": "userInfo"}),
        ],
      ),
    );
  }
}