import 'package:flutter/material.dart';

class DiscountRatingWidget extends StatelessWidget {
  final int rating;
  final VoidCallback? onUpvote;
  final VoidCallback? onDownvote;
  final bool isCompact;

  const DiscountRatingWidget({
    super.key,
    required this.rating,
    this.onUpvote,
    this.onDownvote,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    if (isCompact) {
      // Компактная версия для карточки списка
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButton(
              icon: Icons.arrow_drop_up,
              onPressed: onUpvote,
              color: primaryColor,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                rating.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getRatingColor(rating),
                ),
              ),
            ),
            _buildButton(
              icon: Icons.arrow_drop_down,
              onPressed: onDownvote,
              color: Colors.grey[600]!,
            ),
          ],
        ),
      );
    }

    // Расширенная версия для экрана деталей
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onUpvote,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Icon(
                  Icons.arrow_drop_up,
                  size: 32,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              rating.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getRatingColor(rating),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDownvote,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Icon(
                  Icons.arrow_drop_down,
                  size: 32,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 24,
            color: color,
          ),
        ),
      ),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating > 15) return Colors.red[700]!;
    if (rating > 5) return Colors.orange[700]!;
    if (rating > 0) return Colors.grey[700]!;
    if (rating == 0) return Colors.grey[600]!;
    return Colors.blue[700]!;
  }
}