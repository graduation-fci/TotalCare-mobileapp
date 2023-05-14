import 'dart:developer';
import 'package:flutter/cupertino.dart';

import '../infrastructure/user/orders_service.dart';
import '../app_state.dart';

class OrdersProvider with ChangeNotifier {
  AppState appState = AppState.init;
  OrdersService ordersService = OrdersService();
  int currentPage = 1;
  String? errorMsg;
  Map<String, dynamic> _placeOrderResponse = {};

  Map<String, dynamic> get placeOrderResponse {
    return {..._placeOrderResponse};
  }

  List<dynamic> _getOrdersData = [];

  List<dynamic> get getOrdersData {
    return [..._getOrdersData];
  }

  Map<String, dynamic> _getSingleOrderData = {};

  Map<String, dynamic> get getSingleOrderData {
    return {..._getSingleOrderData};
  }

  String? _nextPageEndPoint;
  String? _previousPageEndPoint;

  String? get nextPageEndPoint {
    return _nextPageEndPoint;
  }

  String? get previousPageEndPoint {
    return _previousPageEndPoint;
  }

  Future<void> placeOrder(int addressId, String cartId) async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await ordersService.placeOrder(addressId, cartId);
    _placeOrderResponse = responseData;
    appState = AppState.done;
    log("$_placeOrderResponse");
    notifyListeners();
  }

  Future<void> getOrders() async {
    appState = AppState.loading;
    notifyListeners();
    final responseData = await ordersService.getOrdersList();
    if (ordersService.error.isEmpty) {
      _getOrdersData = responseData['results'];
      _nextPageEndPoint = responseData['next'];
      _previousPageEndPoint = responseData['previous'];
      appState = AppState.done;
      notifyListeners();
    } else {
      errorMsg = responseData['errorMsg'];
      appState = AppState.error;
      notifyListeners();
    }
  }

  Future<void> getSingleOrder(int id) async {
    appState = AppState.loading;
    notifyListeners();
    _getSingleOrderData = await ordersService.getSingleOrder(id);
    log(_getSingleOrderData.toString());
    appState = AppState.done;
    notifyListeners();
  }
}
