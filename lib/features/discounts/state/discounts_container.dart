import 'package:flutter/material.dart';
import '../screens/add_discount_screen.dart';
import '../screens/discount_details_screen.dart';
import '../models/discount.dart';
import '../screens/discounts_list_screen.dart';

class DiscountsContainer extends StatefulWidget {
  final List<Discount> discounts;

  const DiscountsContainer({required this.discounts, super.key});

  @override
  State<DiscountsContainer> createState() => _DiscountsContainerState();
}

class _DiscountsContainerState extends State<DiscountsContainer> {

  void _showAddForm() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => AddDiscountScreen(
          onSave: (newDiscount) {
            _addDiscount(newDiscount);
            _onBack();
          },
          onBack: _onBack,
        ),
      ),
    );
  }

  void _openDiscountDetails(Discount discount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscountDetailsScreen(
          discount: discount,
          onBack: () {
            Navigator.pop(context);
          },
          onToggleFavourite: (id) {
            _onToggleFavourite(id);
          },
          onDelete: (id) {
            _onDeleteFromDetails(id);
            _onBack();
          },
        ),
      ),
    );
  }

  void _onBack() {
    Navigator.pop(context);
  }

  void _addDiscount(Discount newDiscount) {
    setState(() {
      widget.discounts.add(newDiscount);
    });
  }

  void _onToggleFavourite(String id) {
    setState(() {
      final index = widget.discounts.indexWhere((d) => d.id == id);
      if (index != -1) {
        widget.discounts[index] = widget.discounts[index].copyWith(
          isInFavourites: !widget.discounts[index].isInFavourites,
        );
      }
    });
  }

  void _onDeleteFromDetails(String id) {
    final index = widget.discounts.indexWhere((d) => d.id == id);
    if (index == -1) return;

    setState(() {
      widget.discounts.removeAt(index);
    });
  }

  void _onDeleteDiscount(String id) {
    final index = widget.discounts.indexWhere((d) => d.id == id);
    if (index == -1) return;

    final removedDiscount = widget.discounts[index];

    setState(() {
      widget.discounts.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Публикация удалена'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() {
              widget.discounts.insert(index, removedDiscount);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DiscountsListScreen(
      discounts: widget.discounts,
      onAdd: _showAddForm,
      onToggleFavourite: _onToggleFavourite,
      onDiscountTap: _openDiscountDetails,
      onDelete: _onDeleteDiscount,
    );
  }
}
