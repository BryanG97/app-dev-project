import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app_dev_project/presentation/widgets/custom_bottom_navigation_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: CustomBottomNavigationBar.name,
      builder: (BuildContext context, GoRouterState state) => const CustomBottomNavigationBar(),
    ),
  ],
);