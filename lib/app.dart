import 'package:fl_prac_5/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'core/di/di_container.dart';
import 'core/router/app_router.dart';
import 'features/discounts/screens/add_discount_screen.dart';
import 'features/discounts/screens/discount_details_screen.dart';
import 'features/discounts/screens/discounts_list_screen.dart';
import 'features/discounts/data/discounts_repository.dart';
import 'features/login/screens/login_screen.dart';
import 'features/profile/screens/edit_profile_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
    );
  }
}