import 'dart:convert';
import 'package:balanced_meal/Model/item_model.dart';
import 'package:balanced_meal/const.dart';
import 'package:dio/dio.dart';

class Order {
  final List<OrderItem> items;

  Order({required this.items});

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      contentType: 'application/json',
    ),
  );

  static Future<bool> placeOrder(Order order) async {
    try {
      final jsonData = jsonEncode(order.toJson());

      final response = await dio.post(
        kEndPoint,
        data: jsonData,
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.statusCode == 200;

    } on DioException catch (e) {
      print('Dio error type: ${e.type}');
      print('Dio error message: ${e.message}');
      print('Dio error response: ${e.response?.data}');
      throw Exception('Failed to place order: ${e.message}');

    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Failed to place order: $e');
    }
  }
}
