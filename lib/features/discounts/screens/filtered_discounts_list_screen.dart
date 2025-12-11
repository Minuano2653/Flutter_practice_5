import 'package:fl_prac_5/features/profile/data/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../discounts/data/discounts_cubit.dart';
import '../../discounts/models/discount.dart';
import '../../discounts/widgets/discounts_list.dart';

enum DiscountFilterType {
  favourites,
  myDiscounts,
}

class FilteredDiscountsScreen extends StatelessWidget {
  final DiscountFilterType filterType;

  const FilteredDiscountsScreen({
    super.key,
    required this.filterType,
  });

  String get _title {
    switch (filterType) {
      case DiscountFilterType.favourites:
        return 'Избранное';
      case DiscountFilterType.myDiscounts:
        return 'Мои скидки';
    }
  }

  String get _emptyMessage {
    switch (filterType) {
      case DiscountFilterType.favourites:
        return 'Список избранного пуст';
      case DiscountFilterType.myDiscounts:
        return 'Вы еще не создали ни одной скидки';
    }
  }

  List<Discount> _filterDiscounts(List<Discount> discounts, String currentUserId) {
    switch (filterType) {
      case DiscountFilterType.favourites:
        return discounts.where((d) => d.isInFavourites).toList();
      case DiscountFilterType.myDiscounts:
        return discounts.where((d) => d.author.id == currentUserId).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: BlocBuilder<DiscountsCubit, List<Discount>>(
        builder: (context, discounts) {
          final currentUserId = context.read<UserCubit>().state.id;
          final filteredDiscounts = _filterDiscounts(discounts, currentUserId);

          if (filteredDiscounts.isEmpty) {
            return Center(
              child: Text(
                _emptyMessage,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return DiscountsList(
            discounts: filteredDiscounts,
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