import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/di_container.dart';
import '../../profile/models/user.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<User?> build() {
    ref.keepAlive();
    return const AsyncValue.data(null);
  }

  Future<void> login(String login, String password) async {
    final userRepository = ref.read(userRepositoryProvider);

    state = const AsyncValue.loading();

    await Future.delayed(const Duration(milliseconds: 800));

    if (login.trim() == 'minuano' && password.trim() == '1234') {
      final user = userRepository.currentUser;
      state = AsyncValue.data(user);
    } else {
      state = const AsyncValue.error('Неверный логин или пароль', StackTrace.empty);
    }
  }

  void updateUser(User user) {
    state = AsyncValue.data(user);
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}