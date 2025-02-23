class OrderItem {
  final String name;
  final double totalPrice;
  final int quantity;

  OrderItem({
    required this.name,
    required this.totalPrice,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "total_price": totalPrice,
      "quantity": quantity,
    };
  }
}
