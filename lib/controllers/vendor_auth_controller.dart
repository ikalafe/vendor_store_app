import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor_store_app/global_variables.dart';
import 'package:vendor_store_app/models/vendor_model.dart';
import 'package:vendor_store_app/services/manage_http_response.dart';

class VendorAuthController {
  Future<void> signUpVendor({
    required String fullName,
    required String email,
    required String password,
    required context,
  }) async {
    try {
      VendorModel vendor = VendorModel(
        id: '',
        fullName: fullName,
        email: email,
        state: '',
        city: '',
        locality: '',
        role: '',
        password: password,
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signup'),
        body: vendor
            .toJson(), // Convert the Vendor user object to json for the request body
        headers: <String, String>{
          // Set the headers for the request
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // Mange http response to handle http response base on their status code
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(
              context,
              'حساب کاربری فروشنده با موفقیت ایجاد شد.',
              background: Colors.green,
            );
          });
    } catch (e) {}
  }
}
