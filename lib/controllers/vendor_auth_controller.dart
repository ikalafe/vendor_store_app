import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor_store_app/global_variables.dart';
import 'package:vendor_store_app/models/vendor_model.dart';
import 'package:vendor_store_app/provider/vendor_provider.dart';
import 'package:vendor_store_app/services/manage_http_response.dart';
import 'package:vendor_store_app/views/screens/main_vendor_screen.dart';

final providerContainer = ProviderContainer();

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
    } catch (e) {
      showSnackBar(
        context,
        'مشکلی در ثبت نام پیش آمد',
        background: Colors.red.shade500,
      );
      debugPrint('Error Vendor Sign Up: $e');
    }
  }

  // Function to consume the backend vendor signin api
  Future<void> signInVendor({
    required String email,
    required String password,
    required context,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$uri/api/vendor/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          // Set the headers for the request
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          // Extract the authentication token from the response body
          String token = jsonDecode(response.body)['token'];
          // Store the authentication token securely in SharedPreferences
          preferences.setString('auth_token', token);
          // Encode the user data recived from backend as json
          final vendorJson = jsonEncode(jsonDecode(response.body)['vendor']);
          // Update the application state with the vendor user data using riverpod
          providerContainer.read(vendorProvider.notifier).setVendor(vendorJson);
          // Store the data in SharedPreferences
          await preferences.setString('vendor', vendorJson);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainVendorScreen(),
              ),
              (route) => false);
          showSnackBar(
            context,
            'شما با موفقیت وارد شدید',
            background: Colors.green,
          );
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        'مشکلی در ورود شما به وجود آمد',
        background: Colors.red.shade500,
      );
      debugPrint('Error Vendor Sign In: $e');
    }
  }
}
