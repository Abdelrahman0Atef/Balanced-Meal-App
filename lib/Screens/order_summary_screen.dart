import 'dart:convert';
import 'package:balanced_meal/Model/ingredient_model.dart';
import 'package:balanced_meal/Model/item_model.dart';
import 'package:balanced_meal/Widgets/bottom_summary.dart';
import 'package:balanced_meal/const.dart';
import 'package:balanced_meal/Widgets/custom_card.dart';
import 'package:balanced_meal/Helper/order_calculator.dart';
import 'package:balanced_meal/service/order_service.dart';
import 'package:flutter/material.dart';

class OrderSummaryScreen extends StatefulWidget {
  @override
  OrderSummaryScreenState createState() => OrderSummaryScreenState();
}

class OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late Map<Ingredient, int> ingredients;
  late double total;
  late double target;
  late bool isInRange;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    ingredients = args['ingredients'] as Map<Ingredient, int>;
    total = args['total'] as double;
    target = args['target'] as double;
    isInRange = OrderCalculator.isCaloriesInRange(total, target);
  }

  Future<void> handleConfirmOrder() async {
    setState(() {
      isLoading = true;
    });

    try {
      final orderItems = ingredients.entries
          .where((entry) => entry.value > 0)
          .map((entry) => OrderItem(
        name: entry.key.name,
        totalPrice: (kFixedPrice * entry.value).toDouble(),
        quantity: entry.value,
      ))
          .toList();
      print('OrderItems before sending: ${orderItems.map((item) => item.toJson()).toList()}');

      final order = Order(items: orderItems);
      final jsonString = jsonEncode(order.toJson());

      print('Final JSON: $jsonString ------------------------------------------------------');

      // Make API call
      final success = await OrderService.placeOrder(order);

      if (success) {
        if (!mounted) return;

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('There Was An Error Try Again Later'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void increaseQuantity(Ingredient ingredient) {
    setState(() {
      ingredients[ingredient] = (ingredients[ingredient] ?? 0) + 1;
      total = OrderCalculator.calculateTotalCalories(ingredients);
      isInRange = OrderCalculator.isCaloriesInRange(total, target);
    });
  }

  void decreaseQuantity(Ingredient ingredient) {
    setState(() {
      if (ingredients[ingredient]! > 0) {
        ingredients[ingredient] = ingredients[ingredient]! - 1;
        total = OrderCalculator.calculateTotalCalories(ingredients);
        isInRange = OrderCalculator.isCaloriesInRange(total, target);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
        title: Text('Order Summary'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: ingredients.entries
                      .where((entry) => entry.value > 0)
                      .length,
                  itemBuilder: (context, index) {
                    final entry = ingredients.entries
                        .where((entry) => entry.value > 0)
                        .elementAt(index);

                    return CustomCard(
                      imageUrl: entry.key.imageUrl,
                      onTapRemove: () => decreaseQuantity(entry.key),
                      onTapAdd: () => increaseQuantity(entry.key),
                      cal: '${entry.key.calories.toInt()} cal',
                      price: (kFixedPrice * entry.value).toInt(),
                      quantity: entry.value,
                      text: entry.key.name,
                    );
                  },
                ),
              ),
              BottomSummary(
                text: 'Confirm',
                selectedIngredients: ingredients,
                onTap: isInRange && !isLoading ? handleConfirmOrder : null,
                currentCalories: total,
                targetCalories: target,
                isInRange: isInRange,
                Price: OrderCalculator.calculateTotalPrice(ingredients),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}