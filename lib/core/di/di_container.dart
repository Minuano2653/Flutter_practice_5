import 'package:get_it/get_it.dart';
import '../router/app_router.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerSingleton<AppRouter>(AppRouter());
}