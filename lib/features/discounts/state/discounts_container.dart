import 'package:flutter/material.dart';
import '../screens/add_discount_screen.dart';
import '../screens/discount_details_screen.dart';
import '../models/discount.dart';
import '../screens/discounts_list_screen.dart';

enum Screen { list, addForm, viewForm }

class DiscountsContainer extends StatefulWidget {
  final List<Discount> discounts;

  const DiscountsContainer({required this.discounts, super.key});

  @override
  State<DiscountsContainer> createState() => _DiscountsContainerState();
}

class _DiscountsContainerState extends State<DiscountsContainer> {
  Screen _currentScreen = Screen.list;
  Discount? _selectedDiscount;

  void _showAddForm() {
    setState(() {
      _currentScreen = Screen.addForm;
    });
  }

  void _addDiscount(Discount newDiscount) {
    setState(() => widget.discounts.add(newDiscount));
  }

  void _onDiscountTap(Discount discount) {
    setState(() {
      _selectedDiscount = discount;
      _currentScreen = Screen.viewForm;
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
      _currentScreen = Screen.list;
      _selectedDiscount = null;
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

  void _onBack() {
    setState(() {
      _currentScreen = Screen.list;
      _selectedDiscount = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (_currentScreen) {
      case Screen.list:
        body = DiscountsListScreen(
          discounts: widget.discounts,
          onAdd: _showAddForm,
          onToggleFavourite: _onToggleFavourite,
          onDiscountTap: _onDiscountTap,
          onDelete: _onDeleteDiscount,
        );
        break;
      case Screen.addForm:
        body = AddDiscountScreen(
          onSave: (newDiscount) {
            _addDiscount(newDiscount);
          },
          onBack: _onBack,
        );
        break;
      case Screen.viewForm:
        body = DiscountDetailsScreen(
          discount: _selectedDiscount!,
          onBack: _onBack,
          onToggleFavourite: _onToggleFavourite,
          onDelete: _onDeleteFromDetails,
        );
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: body,
    );
  }
}
