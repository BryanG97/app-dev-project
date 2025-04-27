import 'package:app_dev_project/domain/entities/delivery_entity.dart';
import 'package:app_dev_project/presentation/screens/delivery_detail/delivery_detail_screen.dart';
import 'package:app_dev_project/presentation/screens/delivery_product/delivery_product_screen.dart';
import 'package:app_dev_project/presentation/screens/driver_information/driver_information_screen.dart';
import 'package:app_dev_project/presentation/screens/login_screen/login_screen.dart';
import 'package:app_dev_project/presentation/screens/multiple_delivery/multiple_delivery_screen.dart';
import 'package:app_dev_project/presentation/screens/view_delivery/view_delivery_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app_dev_project/presentation/widgets/custom_bottom_navigation_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return const CustomBottomNavigationBar();
            } else {
              return const LoginScreen();
            }
          },
        );
      },
    ),


    GoRoute(
      path: '/',
      name: CustomBottomNavigationBar.name,
      builder: (BuildContext context, GoRouterState state) {
        return const CustomBottomNavigationBar();
      },
    ),
    
    GoRoute(
      path: '/${LoginScreen.name}',
      name: LoginScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    
    GoRoute(
      path: '/${MultipleDeliveryScreen.name}',
      name: MultipleDeliveryScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        final isOnlyView = state.extra as bool;
        return MultipleDeliveryScreen(
          isOnlyView: isOnlyView
        );
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
    
    GoRoute(
      path: '/${ViewDeliveryScreen.name}',
      name: ViewDeliveryScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        final delivery = state.extra as DeliveryEntity;
        return ViewDeliveryScreen(
          delivery: delivery,
        );
      },
    ),
    
    GoRoute(
      path: '/${DriverInformationScreen.name}',
      name: DriverInformationScreen.name,
      builder: (BuildContext context, GoRouterState state) {
        return const DriverInformationScreen();
      },
    ),

  ],
);