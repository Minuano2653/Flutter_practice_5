import 'package:flutter/material.dart';
import '../../../app.dart';
import '../models/discount.dart';

class AddDiscountScreen extends StatefulWidget {
  final void Function(Discount newDiscount) onSave;
  final VoidCallback onBack;

  const AddDiscountScreen({
    super.key,
    required this.onSave,
    required this.onBack,
  });

  @override
  State<AddDiscountScreen> createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends State<AddDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _newPriceController = TextEditingController();
  final _oldPriceController = TextEditingController();
  final _storeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  void _save() {
    if (_formKey.currentState!.validate()) {
      final imageUrl = _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : '';

      final newDiscount = Discount(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        newPrice: _newPriceController.text,
        oldPrice: _oldPriceController.text,
        imageUrl: imageUrl,
        storeName: _storeController.text,
        author: currentUser,
        description: _descriptionController.text,
        isInFavourites: false,
        createdAt: DateTime.now(),
      );

      widget.onSave(newDiscount);
      widget.onBack();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _newPriceController.dispose();
    _oldPriceController.dispose();
    _storeController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить скидку'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_titleController, 'Название публикации'),
              const SizedBox(height: 12),
              _buildTextField(_newPriceController, 'Новая цена', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField(_oldPriceController, 'Старая цена', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildTextField(_storeController, 'Магазин'),
              const SizedBox(height: 12),
              _buildTextField(_descriptionController, 'Описание', maxLines: 4),
              const SizedBox(height: 12),
              _buildOptionalField(_imageUrlController, 'Ссылка на изображение'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
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

  // 🆕 Поле без валидации (необязательное)
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
