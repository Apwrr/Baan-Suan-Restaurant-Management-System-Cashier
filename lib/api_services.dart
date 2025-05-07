import 'dart:convert';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/models/ProductItem.dart';
import 'package:animation_2/screens/home/components/Receipt.dart';
import 'package:animation_2/screens/home/components/cart_order_list.dart';
import 'package:animation_2/screens/home/components/test.dart';

import 'package:http/http.dart' as http;
import 'models/Menu.dart';

class ApiService {
  final String baseUrl = "https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/menu-list/0";

  Future<List<Menu>> fetchMenus() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse.length);
      print('Menu ok!');
      return jsonResponse.map((menu) => Menu.fromJson(menu)).toList();
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<List<Order>> fetchOrdersList() async {
    final response = await http.get(Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/orders/list/awaiting-payment'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(responseBody);
      print('orderList ok!');
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<List<Receipt>> submit(int? orderId, int? table, HomeController controller) async {
    final url = Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/receipt/submit');
    final headers = {"Content-Type": "application/json"};
    final List<Map<String, dynamic>> orderItems = controller.menuCart.map((item) {
      return {
        'menuId': item.menu.id,
        'price': item.menu.price,
        'quantity': item.quantity,
      };
    }).toList();
    final body = json.encode({
      'orderId': orderId,
      'table': table,
      'orderItems': orderItems,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> responseData = json.decode(responseBody);
      return responseData.map((json) => Receipt.fromJson(json)).toList();
    } else {
      throw Exception('Failed to submit order');
    }
  }
}
