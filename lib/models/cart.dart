import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, {this.quantity = 1});

  double get total => product.price * quantity;
}

class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.total);

  bool get isEmpty => _items.isEmpty;

  int quantityOf(Product product) {
    for (final item in _items) {
      if (item.product.id == product.id) return item.quantity;
    }
    return 0;
  }

  void add(Product product) {
    for (final item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        return;
      }
    }
    _items.add(CartItem(product));
  }

  void decrease(Product product) {
    for (final item in _items) {
      if (item.product.id == product.id) {
        item.quantity--;
        if (item.quantity <= 0) _items.remove(item);
        return;
      }
    }
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void clear() => _items.clear();
}
