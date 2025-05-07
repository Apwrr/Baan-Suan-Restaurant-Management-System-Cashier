
import 'package:animation_2/api_services.dart';
import 'package:animation_2/screens/home/components/Receipt.dart';
import 'package:animation_2/screens/home/components/cart_order_list.dart';
import 'package:flutter/material.dart';
import 'package:animation_2/models/Menu.dart';
import 'package:animation_2/models/ProductItem.dart';


enum HomeState {
  normal,
  cart,
}

class HomeController extends ChangeNotifier {

  HomeState _homeState = HomeState.normal;
  List<ProductItem> _menuCart = [];
  Order orders = Order(
    id: 0,
    table: 0,
    orderNo: '',
    status: '',
    orderItems: [],
  ); // Initialize with default values
  final ApiService _apiService = ApiService();
  Future<List<Receipt>> submit(int? orderId, int? table) async {
    return await _apiService.submit(orderId, table, this);
  }

  HomeState get homeState => _homeState;

  List<ProductItem> get menuCart => _menuCart;

  Order get orderItems => orders;

  void changeHomeState(HomeState state) {
    _homeState = state;
    notifyListeners();
  }

  void addProductToCart(Menu menu, int quantity, String remark) {
    for (var item in _menuCart) {
      if (item.menu == menu && item.remark == remark) {
        item.quantity += quantity;
        notifyListeners();
        return;
      }
    }
    _menuCart.add(ProductItem(menu: menu, quantity: quantity, remark: remark));
    notifyListeners();
  }

  void incrementItem(ProductItem item) {
    item.increment();
    notifyListeners();
  }

  void decrementItem(ProductItem item) {
    item.decrement();
    if (item.quantity <= 0) {
      _menuCart.remove(item);
    }
    notifyListeners();
  }

  void removeProductFromCart(ProductItem productItem) {
    _menuCart.remove(productItem);
    notifyListeners();
  }

  void moveCartToOrder() {
    _menuCart.clear();
    notifyListeners();
  }

  int totalCartItems() {
    int total = 0;
    for (var item in _menuCart) {
      total += item.quantity;
    }
    return total;
  }

  Future<List<Order>> fetchOrdersList() async {
    return await _apiService.fetchOrdersList();
  }

}
