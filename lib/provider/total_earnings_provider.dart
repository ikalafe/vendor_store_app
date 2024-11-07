import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store_app/models/vendor_order_model.dart';

// A class that extends StateNotifier to manage the state of total earnings
class TotalEarningsProvider extends StateNotifier<double> {
  // Constructor that initializes the state with 0.0(total earnings)
  TotalEarningsProvider() : super(0.0);

  // Method to caculate the total earnings based on the delivery status
  void calculateEarnings(List<OrderModel> orders) {
    // Initialize a local variable to accumulate earnings
    double earnings = 0.0;

    // Loop through each orders in the list of orders
    for (OrderModel order in orders) {
      // Check if the orders has been delivered
      if (order.delivered) {
        earnings += order.productPrice * order.quantity;
      }
    }
    // Update the state with the calculated earnings, which will notify listeners of the state
    state = earnings;
  }
}

final totalEarningsProvider =
    StateNotifierProvider<TotalEarningsProvider, double>(
  (ref) => TotalEarningsProvider(),
);
