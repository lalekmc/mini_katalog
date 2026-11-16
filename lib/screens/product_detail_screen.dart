import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../utils/formatters.dart';
import '../widgets/cart_button.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/detail';

  final Cart cart;

  const ProductDetailScreen({super.key, required this.cart});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  void _addToCart(Product product) {
    setState(() => widget.cart.add(product));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} sepete eklendi'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: 'Sepete git', onPressed: _openCart),
        ),
      );
  }

  Future<void> _openCart() async {
    await Navigator.pushNamed(context, CartScreen.routeName);
    if (mounted) setState(() {});
  }

  double _sidePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width > 600 ? (width - 600) / 2 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final theme = Theme.of(context);
    final inCart = widget.cart.quantityOf(product);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.category),
        actions: [
          CartButton(count: widget.cart.itemCount, onPressed: _openCart),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16 + _sidePadding(context),
          8,
          16 + _sidePadding(context),
          24,
        ),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: 'product-${product.id}',
                child: Image.asset(product.image, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            product.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.tagline,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Text('Açıklama', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(product.description, style: theme.textTheme.bodyMedium),
          if (product.specs.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Özellikler', style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerLow,
              child: Column(
                children: [
                  for (final entry in product.specs.entries)
                    ListTile(
                      dense: true,
                      title: Text(entry.key),
                      trailing: Text(
                        entry.value,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fiyat', style: theme.textTheme.bodySmall),
                    Text(
                      formatPrice(product.price),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _addToCart(product),
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(inCart > 0 ? 'Sepette ($inCart)' : 'Sepete Ekle'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
