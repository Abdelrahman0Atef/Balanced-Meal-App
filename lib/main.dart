import 'package:balanced_meal/Screens/welcome_screen.dart';
import 'package:balanced_meal/Screens/enter_details_screen.dart';
import 'package:balanced_meal/Screens/create_order_screen.dart';
import 'package:balanced_meal/Screens/order_summary_screen.dart';
import 'package:balanced_meal/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(BalancedMeal());
}

class BalancedMeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Order App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/screen2': (context) => EnterDetailsScreen(),
        '/screen3': (context) => CreateOrderScreen(),
        '/screen4': (context) => OrderSummaryScreen(),
      },
    );
  }
}
