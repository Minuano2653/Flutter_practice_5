import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/models/user.dart';

class UserCubit extends Cubit<User> {
  UserCubit()
      : super(
    User(
      id: 'u1',
      name: 'Minuano',
      avatarUrl: 'https://i.pravatar.cc/150?img=4',
    ),
  );

  void updateUser(User user) {
    emit(user);
  }
}