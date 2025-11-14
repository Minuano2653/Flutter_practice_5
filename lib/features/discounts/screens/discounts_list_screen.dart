import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/di_container.dart';
import '../data/discounts_repository.dart';
import '../models/discount.dart';
import '../widgets/discounts_list.dart';

class DiscountsListScreen extends StatefulWidget {
  const DiscountsListScreen({super.key});

  @override
  State<DiscountsListScreen> createState() => _DiscountsListScreenState();
}

class _DiscountsListScreenState extends State<DiscountsListScreen> {
  late final DiscountsRepository _discountsRepository;

  @override
  void initState() {
    super.initState();
    if (getIt.isRegistered<DiscountsRepository>()) {
      _discountsRepository = getIt<DiscountsRepository>();
    } else {
      print('Ошибка DiscountsRepository не зарегистрирован в GetIt!');
    }
  }

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
      body: DiscountsList(
        discounts: _discountsRepository.demoDiscounts,
        onToggleFavourite: (id) {
          setState(() {
            _discountsRepository.toggleFavourite(id);
          });
        },
        onDiscountTap: (discount) => context.push('/discounts/${discount.id}'),
        onDelete: (id) {
          setState(() {
            _discountsRepository.deleteDiscount(id);
          });
        },
      ),
    );
  }
}