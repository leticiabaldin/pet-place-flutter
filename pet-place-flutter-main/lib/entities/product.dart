
import 'package:intl/intl.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.image,
  });

  final String id;
  final String name;
  final double price;
  final String description;
  final String? image;

  String getFormattedPrice() {
    final formatPrice = NumberFormat('###,##0.00', 'pt-BR');
    return 'R\$ ${formatPrice.format(price)}';
  }
}