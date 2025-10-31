/*
import 'package:flutter/material.dart';
import '../../../app.dart';
import '../models/user.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _avatarController = TextEditingController(text: widget.user.avatarUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final name = _nameController.text.trim();
    final avatar = _avatarController.text.trim();

    // Проверка на пустые поля
    if (name.isEmpty || avatar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Поля "Имя" и "Ссылка на аватар" не могут быть пустыми'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final updatedUser = widget.user.copyWith(
      name: name,
      avatarUrl: avatar,
    );

    currentUserNotifier.value = updatedUser;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование профиля'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _avatarController,
              decoration: const InputDecoration(
                labelText: 'Ссылка на аватар',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
*/
