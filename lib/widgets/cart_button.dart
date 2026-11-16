import 'package:flutter/material.dart';

class CartButton extends StatelessWidget {
  final int count;
  final VoidCallback onPressed;

  const CartButton({super.key, required this.count, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Sepet',
      onPressed: onPressed,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
    );
  }
}
