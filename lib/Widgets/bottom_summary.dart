import 'package:balanced_meal/Model/ingredient_model.dart';
import 'package:balanced_meal/const.dart';
import 'package:balanced_meal/Widgets/custom_button.dart';
import 'package:flutter/material.dart';

class BottomSummary extends StatelessWidget {
  BottomSummary({
    super.key,
    required this.text,
    required this.onTap,
    required this.currentCalories,
    required this.targetCalories,
    required this.isInRange,
    required this.Price,
    Map<Ingredient, int>? selectedIngredients,
  }) : selectedIngredients = selectedIngredients;

  final String text;
  VoidCallback? onTap;
  final double currentCalories;
  final double targetCalories;
  final bool isInRange;
  final double Price;
  Map<Ingredient, int>? selectedIngredients;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${currentCalories.round()} Cal out of ${targetCalories.round()} Cal',
                style: TextStyle(fontSize: 18, color: kGreyColor),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$$Price',
                style: TextStyle(fontSize: 18, color: kPrimaryColor),
              ),
            ],
          ),
          SizedBox(height: 16),
          CustomButton(
            text: text,
            onTap: onTap,
            color: isInRange ? kPrimaryColor : kGreyColor,
          ),
        ],
      ),
    );
  }
}