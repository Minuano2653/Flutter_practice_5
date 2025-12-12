import 'package:go_router/go_router.dart';

import '../../features/discounts/screens/add_edit_discount_screen.dart';
import '../../features/discounts/screens/discount_details_screen.dart';
import '../../features/discounts/screens/discounts_list_screen.dart';
import '../../features/discounts/screens/filtered_discounts_list_screen.dart';
import '../../features/discussions/screens/add_edit_discussion_screen.dart';
import '../../features/discussions/screens/discussion_details_screen.dart';
import '../../features/discussions/screens/discussions_list_screen.dart';
import '../../features/discussions/screens/filtered_discussions_list_screen.dart';
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
                builder: (context, state) => const AddEditDiscountScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return AddEditDiscountScreen(discountId: id);
                },
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
            path: '/discussions',
            builder: (context, state) => const DiscussionsListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddEditDiscussionScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return AddEditDiscussionScreen(discussionId: id);
                },
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return DiscussionDetailsScreen(discussionId: id);
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
              GoRoute(
                path: 'favourites',
                builder: (context, state) => const FilteredDiscountsScreen(
                  filterType: DiscountFilterType.favourites,
                ),
              ),
              GoRoute(
                path: 'favourite-discussions',
                builder: (context, state) => const FilteredDiscussionsScreen(
                  filterType: DiscussionFilterType.favourites,
                ),
              ),
              GoRoute(
                path: 'my-discounts',
                builder: (context, state) => const FilteredDiscountsScreen(
                  filterType: DiscountFilterType.myDiscounts,
                ),
              ),
              GoRoute(
                path: 'my-discussions',
                builder: (context, state) => const FilteredDiscussionsScreen(
                  filterType: DiscussionFilterType.myDiscussions,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
