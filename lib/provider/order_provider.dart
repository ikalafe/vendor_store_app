import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_store_app/models/vendor_order_model.dart';

class OrderProvider extends StateNotifier<List<OrderModel>> {
  OrderProvider() : super([]);

  // Set the list of Orders
  void setOrders(List<OrderModel> orders) {
    state = orders;
  }

  void updateOrderStatus(String orderId, {bool? processing, bool? delivered}) {
    // Update the state of the provider with a new list of orders
    state = [
      // Iterate through the existing orders
      for (final order in state)
        // Check if the current order's Id matches the ID we want to update
        if (order.id == orderId)
          // Create new Order object with the updated status
          OrderModel(
            id: order.id,
            fullName: order.fullName,
            email: order.email,
            state: order.state,
            city: order.city,
            locality: order.locality,
            productName: order.productName,
            productPrice: order.productPrice,
            quantity: order.quantity,
            category: order.category,
            image: order.image,
            buyerId: order.buyerId,
            vendorId: order.vendorId,
            // User the new processing status if provided, other wise keep the current state
            processing: processing ?? order.processing,
            // User the new delivered status if provided, other wise keep the current state
            delivered: delivered ?? order.delivered,
          )
        // if the current order's id does not match, keep the order unchange
        else
          order,
    ];
  }
}

final orderProvider = StateNotifierProvider<OrderProvider, List<OrderModel>>(
  (ref) {
    return OrderProvider();
  },
);
