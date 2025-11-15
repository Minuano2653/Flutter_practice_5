import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/di_container.dart';
import '../models/discount.dart';

part 'discounts_list_controller.g.dart';

@riverpod
class DiscountsListController extends _$DiscountsListController {
  @override
  List<Discount> build() {
    final repository = ref.read(discountsRepositoryProvider);
    return repository.demoDiscounts;
  }

  void toggleFavourite(String id) {
    final repository = ref.read(discountsRepositoryProvider);
    repository.toggleFavourite(id);
    state = [...state];
  }

  void deleteDiscount(String id) {
    final repository = ref.read(discountsRepositoryProvider);
    repository.deleteDiscount(id);
    state = state.where((d) => d.id != id).toList();
  }

  void addDiscount(Discount newDiscount) {
    final repository = ref.read(discountsRepositoryProvider);
    repository.addDiscount(newDiscount);
    state = [...state, newDiscount];
  }
}