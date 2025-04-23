import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/screens/delivery_detail/delivery_detail_screen.dart';
import 'package:app_dev_project/presentation/screens/delivery_product/delivery_product_screen.dart';
import 'package:app_dev_project/presentation/screens/multiple_delivery/multiple_delivery_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app_dev_project/presentation/widgets/custom_bottom_navigation_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: CustomBottomNavigationBar.name,
      builder: (BuildContext context, GoRouterState state) {
        return const CustomBottomNavigationBar();
      },
    ),
    
    GoRoute(
      path: '/${MultipleDeliveryScreen.name}',
      name: MultipleDeliveryScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return const MultipleDeliveryScreen();
      },
    ),
    
    GoRoute(
      path: '/${DeliveryDetailScreen.name}',
      name: DeliveryDetailScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        final delivery = state.extra as DeliveryEntity;
        return DeliveryDetailScreen(
          delivery: delivery,
        );
      },
    ),
    
    GoRoute(
      path: '/${DeliveryProductScreen.name}',
      name: DeliveryProductScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        final delivery = state.extra as DeliveryEntity;
        return DeliveryProductScreen(
          delivery: delivery,
        );
      },
    ),
  ],
);