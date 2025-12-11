import 'package:fl_prac_5/shared/widgets/universal_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:io';
import '../data/discussions_cubit.dart';
import '../models/discussion.dart';
import '../../profile/data/user_cubit.dart';

class AddEditDiscussionScreen extends StatefulWidget {
  final String? discussionId;

  const AddEditDiscussionScreen({super.key, this.discussionId});

  @override
  State<AddEditDiscussionScreen> createState() => _AddEditDiscussionScreenState();
}

class _AddEditDiscussionScreenState extends State<AddEditDiscussionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _imageUrls = [];
  final List<XFile> _selectedFiles = [];

  bool get _isEditMode => widget.discussionId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadDiscussion();
    }
  }

  void _loadDiscussion() {
    final discussion = context.read<DiscussionsCubit>().getDiscussionById(
      widget.discussionId!,
    );
    if (discussion != null) {
      _titleController.text = discussion.title;
      _descriptionController.text = discussion.description;
      _imageUrls.addAll(discussion.imageUrls);
    }
  }

  Future<void> _pickImages() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'jpeg', 'png'],
    );

    final List<XFile> files = await openFiles(acceptedTypeGroups: [typeGroup]);

    if (files.isNotEmpty) {
      setState(() {
        final remaining = 3 - _selectedFiles.length - _imageUrls.length;
        _selectedFiles.addAll(files.take(remaining));
      });
    }
  }

  void _removeImage(int index, bool isFile) {
    setState(() {
      if (isFile) {
        _selectedFiles.removeAt(index);
      } else {
        _imageUrls.removeAt(index);
      }
    });
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final currentUser = context.read<UserCubit>().state;

      // В реальном приложении здесь был бы загрузка файлов на сервер
      final allImageUrls = [
        ..._imageUrls,
        ..._selectedFiles.map((f) => f.path),
      ];

      if (_isEditMode) {
        final oldDiscussion = context.read<DiscussionsCubit>().getDiscussionById(
          widget.discussionId!,
        );
        if (oldDiscussion != null) {
          final updatedDiscussion = oldDiscussion.copyWith(
            title: _titleController.text,
            description: _descriptionController.text,
            imageUrls: allImageUrls,
          );
          context.read<DiscussionsCubit>().updateDiscussion(updatedDiscussion);
        }
      } else {
        final newDiscussion = Discussion(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text,
          description: _descriptionController.text,
          imageUrls: allImageUrls,
          author: currentUser,
          createdAt: DateTime.now(),
        );
        context.read<DiscussionsCubit>().addDiscussion(newDiscussion);
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalImages = _imageUrls.length + _selectedFiles.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Редактировать обсуждение' : 'Новое обсуждение'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Область выбора изображений
              Container(
                height: 500,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: totalImages == 0
                    ? InkWell(
                  onTap: _pickImages,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate,
                            size: 48, color: Colors.grey[600]),
                        const SizedBox(height: 8),
                        Text(
                          'Добавить изображения (до 3)',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
                    : Stack(
                  children: [
                    PageView.builder(
                      itemCount: totalImages,
                      itemBuilder: (context, index) {
                        final isUrlImage = index < _imageUrls.length;
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                                child: UniversalImage(
                                  source: isUrlImage
                                      ? _imageUrls[index]
                                      : _selectedFiles[index - _imageUrls.length].path,
                                  fit: BoxFit.cover,
                                )
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                ),
                                onPressed: () => _removeImage(
                                  isUrlImage ? index : index - _imageUrls.length,
                                  !isUrlImage,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if (totalImages < 3)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: FloatingActionButton.small(
                          onPressed: _pickImages,
                          child: const Icon(Icons.add),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Поле названия
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название',
                  hintText: 'Введите название обсуждения',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Поле описания
              TextFormField(
                controller: _descriptionController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Опишите тему обсуждения',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введите описание';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Кнопка сохранения
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    _isEditMode ? 'Сохранить изменения' : 'Создать обсуждение',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}