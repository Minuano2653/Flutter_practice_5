import '../models/user.dart';

class UserRepository {
  User _currentUser = User(
    id: 'u1',
    name: 'Minuano',
    avatarUrl: 'https://i.pravatar.cc/150?img=4',
  );

  User get currentUser => _currentUser;

  void updateUser(User user) {
    _currentUser = user;
  }
}