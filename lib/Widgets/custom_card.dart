import 'package:balanced_meal/Widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard(
      {required this.text,
      required this.cal,
      required this.price,
      required this.quantity,required this.imageUrl,required this.onTapAdd,required this.onTapRemove});

  String? text;
  String? cal;
  int? price;
  int? quantity;
  String? imageUrl;
  VoidCallback? onTapAdd;
  VoidCallback? onTapRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              ),
              borderRadius:
              BorderRadius.circular(20),
            ),
          ),
          SizedBox(width: 16.0),
          // Item details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      text!,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Text(
                      '\$$price',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      cal!,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    RoundedIconButton(
                      onTap: onTapRemove,
                      icon: Icons.remove,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '$quantity',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    RoundedIconButton(
                      onTap: onTapAdd,
                      icon: Icons.add,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
