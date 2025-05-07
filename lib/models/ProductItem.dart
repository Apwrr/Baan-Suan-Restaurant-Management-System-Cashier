import 'package:flutter/material.dart';
import 'Menu.dart';

class ProductItem {
  int quantity;
  final Menu menu;
  final String remark;

  ProductItem({this.quantity = 1, required this.menu,required this.remark});

  Map<String, dynamic> toJson() {
    return {
      'id': menu.id,
      'quantity': quantity,
    };
  }

  void increment() {
    quantity++;
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }

  int getQuantity() {
    return quantity;
  }

  String get status => getStatusText();

  Color get statusColor => _getStatusColor(getStatusText());

  String getStatusText() {
    // Replace with your logic to determine status text based on product or other criteria
    return 'กำลังเตรียม'; // Example status text
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'กำลังเตรียม':
        return Colors.orange;
      case 'กำลังทำ':
        return Colors.blue;
      case 'สำเร็จ':
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
