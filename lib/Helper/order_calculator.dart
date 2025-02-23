import 'package:balanced_meal/Model/ingredient_model.dart';
import 'package:balanced_meal/const.dart';
import 'package:flutter/material.dart';

class OrderCalculator {

  String? gender;
  TextEditingController weightController;
  TextEditingController heightController;
  TextEditingController ageController;

  OrderCalculator({
    required this.weightController,
    required this.heightController,
    required this.ageController,
  });

  double calculateCalories() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text);
    int age = int.parse(ageController.text);

    return gender == 'Female'
        ? (655.1 + (9.56 * weight) + (1.85 * height) - (4.67 * age))
        : (666.47 + (13.75 * weight) + (5 * height) - (6.75 * age));
  }
  // Method to calculate total calories based on current quantities
  static double calculateTotalCalories(Map<Ingredient, int> ingredients) {
    double newTotal = 0.0;
    ingredients.forEach((ingredient, quantity) {
      newTotal += ingredient.calories * quantity;
    });
    return newTotal;
  }

  // Method to calculate total price based on quantity of each ingredient and kFixedPrice
  static double calculateTotalPrice(Map<Ingredient, int> ingredients) {
    double newTotalPrice = 0.0;
    ingredients.forEach((ingredient, quantity) {
      newTotalPrice += quantity * kFixedPrice;
    });
    return newTotalPrice;
  }

  // Method to check if the total calories are in range
  static bool isCaloriesInRange(double total, double target) {
    return total >= target * 0.9 && total <= target * 1.1;
  }
}