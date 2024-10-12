import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store_app/models/vendor_order_model.dart';

class OrderProvider extends StateNotifier<List<OrderModel>> {
  OrderProvider() : super([]);

  // Set the list of Orders
  void setOrders(List<OrderModel> orders) {
    state = orders;
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<OrderModel>>(
  (ref) {
    return OrderProvider();
  },
);
