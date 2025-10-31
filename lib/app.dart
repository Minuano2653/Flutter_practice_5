import 'package:fl_prac_5/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'features/discounts/screens/add_discount_screen.dart';
import 'features/discounts/screens/discount_details_screen.dart';
import 'features/discounts/screens/discounts_list_screen.dart';
import 'features/discounts/data/discounts_repository.dart';
import 'features/profile/screens/edit_profile_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DiscountsRepository discountsState = DiscountsRepository();

  late final GoRouter _router = GoRouter(
    initialLocation: '/discounts',
    routes: [
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/discounts',
            builder: (context, state) => DiscountsListScreen(
              discounts: discountsState.demoDiscounts,
              onDiscountTap: (discount) =>
                  context.push('/discounts/${discount.id}'),
              onToggleFavourite: discountsState.toggleFavourite,
              onDelete: discountsState.deleteDiscount,
              onAdd: () => context.push('/discounts/add'),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => AddDiscountScreen(
                  onSave: discountsState.addDiscount,
                  onBack: () => context.pop(),
                ),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  final discount = discountsState.demoDiscounts.firstWhere(
                    (d) => d.id == id,
                  );
                  return DiscountDetailsScreen(
                    discount: discount,
                    onBack: () => context.pop(),
                    onToggleFavourite: discountsState.toggleFavourite,
                    onDelete: discountsState.deleteDiscount,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfileScreen(
              discounts: discountsState.demoDiscounts,
              onToggleFavourite: discountsState.toggleFavourite,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  return EditProfileScreen(
                    user: currentUser,
                    onBack: () => context.pop(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

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
