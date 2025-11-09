import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/di_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(const MyApp());
}
