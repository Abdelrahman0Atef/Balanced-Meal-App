import 'package:balanced_meal/Model/ingredient_model.dart';
import 'package:balanced_meal/Widgets/product_list_with_section_title.dart';
import 'package:balanced_meal/Widgets/bottom_summary.dart';
import 'package:balanced_meal/Helper/order_calculator.dart';
import 'package:balanced_meal/const.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateOrderScreen extends StatefulWidget {
  @override
  CreateOrderScreenState createState() => CreateOrderScreenState();
}

class CreateOrderScreenState extends State<CreateOrderScreen> {
  Map<Ingredient, int> selectedIngredients = {};
  double currentCalories = 0.0;
  late double targetCalories;
  late bool isInRange;

  List<Ingredient> ingredients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchIngredients();
  }

  Future<void> fetchIngredients() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Fetch vegetables
      QuerySnapshot vegetableSnapshot = await firestore.collection('Vegetable').get();
      List<Ingredient> vegetables = vegetableSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Ingredient(
          name: data['food_name'] ?? '',
          category: 'vegetables',
          calories: double.parse((data['calories'] ?? 0).toString()),
          imageUrl: data['image_url'] ?? '',
        );
      }).toList();

      // Fetch meats
      QuerySnapshot meatSnapshot = await firestore.collection('Meat').get();
      List<Ingredient> meats = meatSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Ingredient(
          name: data['food_name'] ?? '',
          category: 'meat',
          calories: double.parse((data['calories'] ?? 0).toString()),
          imageUrl: data['image_url'] ?? '',
        );
      }).toList();

      // Fetch carbs
      QuerySnapshot carbSnapshot = await firestore.collection('Carb').get();
      List<Ingredient> carbs = carbSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Ingredient(
          name: data['food_name'] ?? '',
          category: 'carbs',
          calories: double.parse((data['calories'] ?? 0).toString()),
          imageUrl: data['image_url'] ?? '',
        );
      }).toList();

      setState(() {
        ingredients = [...vegetables, ...meats, ...carbs];
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching ingredients: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    targetCalories = ModalRoute.of(context)!.settings.arguments as double;
    currentCalories = selectedIngredients.entries
        .fold(0.0, (sum, entry) => sum + (entry.key.calories * entry.value));
    isInRange = OrderCalculator.isCaloriesInRange(currentCalories, targetCalories);


    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
        title: Text('Create your Order'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductHorizontalListWithSectionTitle(
              title: 'Vegetables',
              products: ingredients
                  .where((ingredient) => ingredient.category == 'vegetables')
                  .toList(),
              onQuantityChanged: (ingredient, quantity) {
                setState(() {
                  if (quantity == 0) {
                    selectedIngredients.remove(ingredient);
                  } else {
                    selectedIngredients[ingredient] = quantity;
                  }
                });
              },
            ),
            ProductHorizontalListWithSectionTitle(
              title: 'Meats',
              products: ingredients
                  .where((ingredient) => ingredient.category == 'meat')
                  .toList(),
              onQuantityChanged: (ingredient, quantity) {
                setState(() {
                  if (quantity == 0) {
                    selectedIngredients.remove(ingredient);
                  } else {
                    selectedIngredients[ingredient] = quantity;
                  }
                });
              },
            ),
            ProductHorizontalListWithSectionTitle(
              title: 'Carbs',
              products: ingredients
                  .where((ingredient) => ingredient.category == 'carbs')
                  .toList(),
              onQuantityChanged: (ingredient, quantity) {
                setState(() {
                  if (quantity == 0) {
                    selectedIngredients.remove(ingredient);
                  } else {
                    selectedIngredients[ingredient] = quantity;
                  }
                });
              },
            ),
            SizedBox(height: 24),
            BottomSummary(
              text: 'Place Order',
              Price: OrderCalculator.calculateTotalPrice(selectedIngredients),
              onTap: isInRange
                  ? () {
                Navigator.pushNamed(
                  context,
                  '/screen4',
                  arguments: {
                    'ingredients': selectedIngredients,
                    'total': currentCalories,
                    'target': targetCalories,
                    'imageUrls': selectedIngredients.keys.map((ingredient) => ingredient.imageUrl).toList(),
                  },
                );
              }
                  : null,
              currentCalories: currentCalories,
              targetCalories: targetCalories,
              isInRange: isInRange,
              selectedIngredients: selectedIngredients,
            ),
          ],
        ),
      ),
    );
  }
}
