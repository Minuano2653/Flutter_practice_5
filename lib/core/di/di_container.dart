import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../features/discounts/data/discounts_repository.dart';
import '../../features/profile/data/user_repository.dart';
import '../router/app_router.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<UserRepository>(() => UserRepository());
  getIt.registerLazySingleton<DiscountsRepository>(() => DiscountsRepository());

  getIt.registerSingleton<AppRouter>(AppRouter());
}

final discountsRepositoryProvider = Provider((ref) => DiscountsRepository());

final userRepositoryProvider = Provider((ref) => UserRepository());