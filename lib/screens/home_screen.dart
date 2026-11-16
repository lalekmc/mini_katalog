import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/cart_button.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  final Cart cart;

  const HomeScreen({super.key, required this.cart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _allCategories = 'Tümü';

  late final Future<List<Product>> _productsFuture;
  String _query = '';
  String _selectedCategory = _allCategories;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService().fetchProducts();
  }

  List<Product> _filter(List<Product> products) {
    final query = _query.trim().toLowerCase();
    return products.where((p) {
      final matchesCategory = _selectedCategory == _allCategories ||
          p.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  Future<void> _openDetail(Product product) async {
    await Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
    if (mounted) setState(() {});
  }

  Future<void> _openCart() async {
    await Navigator.pushNamed(context, CartScreen.routeName);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keşfet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          CartButton(count: widget.cart.itemCount, onPressed: _openCart),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Ürünler yüklenemedi.'));
          }
          final products = snapshot.data ?? [];
          final categories = [
            _allCategories,
            ...{for (final p in products) p.category},
          ];
          final visible = _filter(products);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(categories)),
              if (visible.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child:
                      Center(child: Text('Aramanıza uygun ürün bulunamadı.')),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  sliver: SliverGrid.builder(
                    itemCount: visible.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.66,
                    ),
                    itemBuilder: (context, index) {
                      final product = visible[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _openDetail(product),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) => setState(() => _query = value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Ürün ara',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 12 / 5,
              child: Image.asset('assets/images/banner.png', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: category == _selectedCategory,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
