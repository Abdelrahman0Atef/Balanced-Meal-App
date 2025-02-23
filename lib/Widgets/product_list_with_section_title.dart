import 'package:balanced_meal/Model/ingredient_model.dart';
import 'package:balanced_meal/Widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductHorizontalListWithSectionTitle extends StatelessWidget {
  final String title;
  final List<Ingredient> products;
  final void Function(Ingredient ingredient, int quantity) onQuantityChanged;

  ProductHorizontalListWithSectionTitle({
    required this.title,
    required this.products,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 180,
                    child: ProductCard(
                      ingredient: products[index],
                      onQuantityChanged: onQuantityChanged,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}