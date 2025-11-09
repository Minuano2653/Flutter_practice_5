import 'package:flutter/material.dart';
import 'features/discounts/data/discounts_repository.dart';

class AppDependencies {
  final DiscountsRepository discountsRepository;

  AppDependencies({
    required this.discountsRepository,
  });
}

class DependenciesProvider extends InheritedWidget {
  final AppDependencies dependencies;

  const DependenciesProvider({
    super.key,
    required this.dependencies,
    required super.child,
  });

  static AppDependencies of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<DependenciesProvider>();

    if (provider == null) {
      throw Exception('DependenciesProvider not found in context');
    }

    return provider.dependencies;
  }

  @override
  bool updateShouldNotify(DependenciesProvider oldWidget) {
    return dependencies != oldWidget.dependencies;
  }
}