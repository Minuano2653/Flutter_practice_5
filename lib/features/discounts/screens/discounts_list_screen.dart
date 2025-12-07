import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/discounts_cubit.dart';
import '../data/user_cubit.dart';
import '../models/discount.dart';
import '../widgets/discounts_list.dart';

class DiscountsListScreen extends StatelessWidget {
  const DiscountsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Скидки'),
        actions: [
          IconButton(
            onPressed: () => context.push('/discounts/add'),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: BlocBuilder<DiscountsCubit, List<Discount>>(
        builder: (context, discounts) {
          final currentUserId = context.read<UserCubit>().state.id;

          return DiscountsList(
            discounts: discounts,
            currentUserId: currentUserId,
            onDiscountTap: (discount) => context.push('/discounts/${discount.id}'),
            onToggleFavourite: (id) {
              context.read<DiscountsCubit>().toggleFavourite(id);
            },
            onDelete: (id) {
              context.read<DiscountsCubit>().deleteDiscount(id);
            },
          );
        },
      ),
    );
  }
}