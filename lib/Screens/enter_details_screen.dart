import 'package:balanced_meal/Helper/order_calculator.dart';
import 'package:balanced_meal/Widgets/custom_button.dart';
import 'package:balanced_meal/const.dart';
import 'package:flutter/material.dart';

class EnterDetailsScreen extends StatefulWidget {
  @override
  EnterDetailsScreenState createState() => EnterDetailsScreenState();
}

class EnterDetailsScreenState extends State<EnterDetailsScreen> {
  final formKey = GlobalKey<FormState>();
  String? gender;
  bool isInRange = false;
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  late OrderCalculator orderCalculator;

  @override
  void initState() {
    super.initState();
    orderCalculator = OrderCalculator(
      weightController: weightController,
      heightController: heightController,
      ageController: ageController,
    );
  }

  void checkFields() {
    setState(() {
      isInRange = gender != null &&
          weightController.text.isNotEmpty &&
          heightController.text.isNotEmpty &&
          ageController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_sharp)),
        title: Text('Enter Your Details'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              // Gender Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    isExpanded: false,
                    value: gender,
                    dropdownColor: Colors.orange.shade200,
                    decoration: const InputDecoration(
                      hintText: 'Choose your gender',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kGreyColor)),
                    ),
                    items: ['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                      checkFields();
                    },
                    validator: (value) => value == null ? 'Required' : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weight',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your weight',
                      suffixText: 'Kg',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kGreyColor)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    onChanged: (_) => checkFields(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Height',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: heightController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your height',
                      suffixText: 'Cm',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kGreyColor)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    onChanged: (_) => checkFields(),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Age TextField with label above
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Age',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your age',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kGreyColor)),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    onChanged: (_) => checkFields(),
                  ),
                ],
              ),
              SizedBox(height: 50),
              CustomButton(
                  text: 'Calculate Calories',
                  onTap: isInRange
                      ? () {
                          if (formKey.currentState!.validate()) {
                            Navigator.pushNamed(
                              context,
                              '/screen3',
                              arguments: orderCalculator.calculateCalories(),
                            );
                          }
                        }
                      : null,
                  color: isInRange ? kPrimaryColor : kGreyColor),
            ],
          ),
        ),
      ),
    );
  }
}
