import 'package:fl_prac_5/app_dependencies.dart';
import 'package:fl_prac_5/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'features/discounts/screens/add_discount_screen.dart';
import 'features/discounts/screens/discount_details_screen.dart';
import 'features/discounts/screens/discounts_list_screen.dart';
import 'features/login/screens/login_screen.dart';
import 'features/profile/screens/edit_profile_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => ScaffoldWithNavBar(child: child),
          routes: [
            GoRoute(
              path: '/discounts',
              builder: (context, state) {
                final repo = DependenciesProvider.of(context).discountsRepository;
                return DiscountsListScreen(
                  discounts: repo.demoDiscounts,
                  onDiscountTap: (discount) => context.push('/discounts/${discount.id}'),
                  onToggleFavourite: repo.toggleFavourite,
                  onDelete: repo.deleteDiscount,
                  onAdd: () => context.push('/discounts/add'),
                );
              },
              routes: [
                GoRoute(
                  path: 'add',
                  builder: (context, state) {
                    final repo = DependenciesProvider.of(context).discountsRepository;
                    return AddDiscountScreen(
                      onSave: repo.addDiscount,
                      onBack: () => context.pop(),
                    );
                  },
                ),
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final repo = DependenciesProvider.of(context).discountsRepository;
                    final id = state.pathParameters['id']!;
                    final discount = repo.demoDiscounts.firstWhere((d) => d.id == id);
                    return DiscountDetailsScreen(
                      discount: discount,
                      onBack: () => context.pop(),
                      onToggleFavourite: repo.toggleFavourite,
                      onDelete: repo.deleteDiscount,
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) {
                final repo = DependenciesProvider.of(context).discountsRepository;
                return ProfileScreen(
                  discounts: repo.demoDiscounts,
                  onToggleFavourite: repo.toggleFavourite,
                );
              },
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const EditProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
    );
  }
}