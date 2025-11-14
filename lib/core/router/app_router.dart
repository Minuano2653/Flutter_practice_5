import 'package:go_router/go_router.dart';

import '../../features/discounts/screens/add_discount_screen.dart';
import '../../features/discounts/screens/discount_details_screen.dart';
import '../../features/discounts/screens/discounts_list_screen.dart';
import '../../features/login/screens/login_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../scaffold_with_navbar.dart';

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/discounts',
            builder: (context, state) => const DiscountsListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddDiscountScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return DiscountDetailsScreen(discountId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
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
