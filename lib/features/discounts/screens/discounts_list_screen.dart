import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/discounts_cubit.dart';
import '../../profile/data/user_cubit.dart';
import '../models/discount.dart';
import '../widgets/discounts_list.dart';

class DiscountsListScreen extends StatelessWidget {
  const DiscountsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Скидки'),
          actions: [
            IconButton(
              onPressed: () => context.push('/discounts/add'),
              icon: const Icon(Icons.add),
            )
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                icon: Icon(Icons.local_fire_department),
                text: 'Горячее',
              ),
              Tab(
                icon: Icon(Icons.fiber_new),
                text: 'Новое',
              ),
            ],
          ),
        ),
        body: BlocBuilder<DiscountsCubit, List<Discount>>(
          builder: (context, discounts) {
            final currentUserId = context.read<UserCubit>().state.id;
            final cubit = context.read<DiscountsCubit>();

            return TabBarView(
              children: [
                DiscountsList(
                  discounts: cubit.getHotDiscounts(),
                  currentUserId: currentUserId,
                  onDiscountTap: (discount) => context.push('/discounts/${discount.id}'),
                  onToggleFavourite: (id) {
                    cubit.toggleFavourite(id);
                  },
                  onDelete: (id) {
                    cubit.deleteDiscount(id);
                  },
                  onUpvote: (id) {
                    cubit.upvoteDiscount(id);
                  },
                  onDownvote: (id) {
                    cubit.downvoteDiscount(id);
                  },
                ),
                DiscountsList(
                  discounts: cubit.getNewDiscounts(),
                  currentUserId: currentUserId,
                  onDiscountTap: (discount) => context.push('/discounts/${discount.id}'),
                  onToggleFavourite: (id) {
                    cubit.toggleFavourite(id);
                  },
                  onDelete: (id) {
                    cubit.deleteDiscount(id);
                  },
                  onUpvote: (id) {
                    cubit.upvoteDiscount(id);
                  },
                  onDownvote: (id) {
                    cubit.downvoteDiscount(id);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}