import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../login/controllers/auth_controller.dart';
import '../models/discount.dart';
import '../controllers/discounts_list_controller.dart';

class AddDiscountScreen extends ConsumerStatefulWidget {
  const AddDiscountScreen({super.key});

  @override
  ConsumerState<AddDiscountScreen> createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends ConsumerState<AddDiscountScreen> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final newPriceController = TextEditingController();
  final oldPriceController = TextEditingController();
  final storeController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    newPriceController.dispose();
    oldPriceController.dispose();
    storeController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void save() {
      final currentUser = ref.read(authControllerProvider).value;

      if (formKey.currentState?.validate() != true || currentUser == null) return;

      final newDiscount = Discount(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.trim(),
        newPrice: newPriceController.text.trim(),
        oldPrice: oldPriceController.text.trim(),
        imageUrl: imageUrlController.text.trim(),
        storeName: storeController.text.trim(),
        author: currentUser,
        description: descriptionController.text.trim(),
        isInFavourites: false,
        createdAt: DateTime.now(),
      );

      ref.read(discountsListControllerProvider.notifier).addDiscount(newDiscount);

      context.pop();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Добавить скидку')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildTextField(titleController, 'Название публикации'),
              const SizedBox(height: 12),
              _buildTextField(newPriceController, 'Новая цена', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField(oldPriceController, 'Старая цена', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField(storeController, 'Магазин'),
              const SizedBox(height: 12),
              _buildTextField(descriptionController, 'Описание', maxLines: 4),
              const SizedBox(height: 12),
              _buildOptionalField(imageUrlController, 'Ссылка на изображение'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: save,
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Поле обязательно для заполнения';
        }
        return null;
      },
    );
  }

  Widget _buildOptionalField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: '$label (необязательно)',
        border: const OutlineInputBorder(),
      ),
    );
  }
}
