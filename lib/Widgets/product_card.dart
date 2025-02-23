import 'package:balanced_meal/Model/ingredient_model.dart';
import 'package:balanced_meal/const.dart';
import 'package:balanced_meal/Widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Ingredient ingredient;
  final void Function(Ingredient ingredient, int quantity) onQuantityChanged;

  ProductCard({required this.ingredient, required this.onQuantityChanged});

  @override
  ProductCardState createState() => ProductCardState();
}

class ProductCardState extends State<ProductCard> {
  int quantity = 0;

  void increaseQuantity() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChanged(widget.ingredient, quantity);
  }

  void decreaseQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged(widget.ingredient, quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.network(
                widget.ingredient.imageUrl,
                height: 125,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.ingredient.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${widget.ingredient.calories.toInt()} Cal',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            quantity == 0
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$$kFixedPrice'),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
                    widget.onQuantityChanged(widget.ingredient, quantity);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$$kFixedPrice'),
                RoundedIconButton(
                    icon: Icons.remove, onTap: decreaseQuantity),
                Text('$quantity'),
                RoundedIconButton(icon: Icons.add, onTap: increaseQuantity),
              ],
            ),
          ],
        ),
      ),
    );
  }
}