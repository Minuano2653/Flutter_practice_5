import 'package:flutter/material.dart';

import 'app.dart';
import 'app_dependencies.dart';
import 'features/discounts/data/discounts_repository.dart';

void main() {
  final dependencies = AppDependencies(
    discountsRepository: DiscountsRepository(),
  );

  runApp(
    DependenciesProvider(
      dependencies: dependencies,
      child: const MyApp(),
    ),
  );
}