import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/discounts_cubit.dart';
import '../../profile/data/user_cubit.dart';
import '../models/discount.dart';

class AddEditDiscountScreen extends StatefulWidget {
  final String? discountId;

  const AddEditDiscountScreen({super.key, this.discountId});

  @override
  State<AddEditDiscountScreen> createState() => _AddEditDiscountScreenState();
}

class _AddEditDiscountScreenState extends State<AddEditDiscountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _newPriceController = TextEditingController();
  final _oldPriceController = TextEditingController();
  final _storeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool get _isEditMode => widget.discountId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadDiscount();
    }
  }

  void _loadDiscount() {
    final discount = context.read<DiscountsCubit>().getDiscountById(
      widget.discountId!,
    );
    if (discount != null) {
      _titleController.text = discount.title;
      _newPriceController.text = discount.newPrice;
      _oldPriceController.text = discount.oldPrice;
      _storeController.text = discount.storeName;
      _descriptionController.text = discount.description;
      _imageUrlController.text = discount.imageUrl;
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final imageUrl = _imageUrlController.text.trim().isNotEmpty
          ? _imageUrlController.text.trim()
          : '';

      if (_isEditMode) {
        // Режим редактирования
        final oldDiscount = context.read<DiscountsCubit>().getDiscountById(
          widget.discountId!,
        );
        if (oldDiscount != null) {
          final updatedDiscount = oldDiscount.copyWith(
            title: _titleController.text,
            newPrice: _newPriceController.text,
            oldPrice: _oldPriceController.text,
            storeName: _storeController.text,
            description: _descriptionController.text,
            imageUrl: imageUrl,
          );
          context.read<DiscountsCubit>().updateDiscount(updatedDiscount);
        }
      } else {
        // Режим создания
        final currentUser = context.read<UserCubit>().state;

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

        context.read<DiscountsCubit>().addDiscount(newDiscount);
      }

      Navigator.pop(context);
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
        title: Text(_isEditMode ? 'Редактировать скидку' : 'Добавить скидку'),
        actions: [

        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_titleController, 'Название публикации'),
              const SizedBox(height: 12),
              _buildTextField(
                _newPriceController,
                'Новая цена',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                _oldPriceController,
                'Старая цена',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildTextField(_storeController, 'Магазин'),
              const SizedBox(height: 12),
              _buildTextField(_descriptionController, 'Описание', maxLines: 4),
              const SizedBox(height: 12),
              _buildOptionalField(_imageUrlController, 'Ссылка на изображение'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: Text(_isEditMode ? 'Сохранить изменения' : 'Сохранить'),
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