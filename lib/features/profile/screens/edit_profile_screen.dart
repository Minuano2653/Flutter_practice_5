import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../login/controllers/auth_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    final currentUser = ref.read(authControllerProvider).value;
    _nameController = TextEditingController(text: currentUser?.name ?? '');
    _avatarController = TextEditingController(text: currentUser?.avatarUrl ?? '');
  }

  void _saveChanges() {
    final name = _nameController.text.trim();
    final avatar = _avatarController.text.trim();

    if (name.isEmpty || avatar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Поля "Имя" и "Ссылка на аватар" не могут быть пустыми',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final currentUser = ref.read(authControllerProvider).value;
    if (currentUser == null) return;

    final updatedUser = currentUser.copyWith(
      name: name,
      avatarUrl: avatar,
    );
    ref.read(authControllerProvider.notifier).updateUser(updatedUser);
    context.pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    super.dispose();
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
