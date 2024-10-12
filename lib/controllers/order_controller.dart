import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_store_app/global_variables.dart';
import 'package:vendor_store_app/models/vendor_order_model.dart';
import 'package:vendor_store_app/services/manage_http_response.dart';

class OrderController {
  // Method to GET orders by vendorId
  Future<List<OrderModel>> loadOrders({required String vendorId}) async {
    try {
      // Send an HTTP GET request to get the orders by the buyerId
      final http.Response response = await http.get(
        Uri.parse('$uri/api/orders/vendors/$vendorId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      // Check if the response status code is 200.
      if (response.statusCode == 200) {
        // Parse the Json response body into dynamic List
        // This convers the json data into a format that can be further processed in Dart.
        List<dynamic> data = jsonDecode(response.body);
        // Map the dynamic list to list of OrderModel object using the from json factory method
        //This step convert the raw data into list of the orders instanse, witch are easier to work with
        List<OrderModel> orders =
            data.map((order) => OrderModel.fromJson(order)).toList();
        return orders;
      } else {
        // Throw an exception if the server responded with an error status code
        throw Exception('Faild to load Orders');
      }
    } catch (e) {
      throw Exception('Errorr loading orders');
    }
  }

  // Delete order by ID
  Future<void> deleteOrder({required String id, required context}) async {
    try {
      // Send an HTTP request to delete the order by _id
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      // Handle the http Response
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'سفارش با موفقیت حذف شد',
            background: Colors.amber.shade700,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, 'مشکلی در حذف سفارش رخ داد');
      debugPrint('***** مشکل در حذف سفارش: $e *****');
    }
  }
}
