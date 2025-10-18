import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Список скидок пуст :(',
        style: TextStyle(fontSize: 18, color: Colors.brown),
      ),
    );
  }
}
