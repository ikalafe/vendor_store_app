import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vendor_store_app/global_variables.dart';
import 'package:vendor_store_app/models/subcateogry_model.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  Future<List<SubcateogryModel>> getSubCategoryByCategoryName(
    String categoryName,
  ) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/category//subcategories'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return data
              .map((subcategory) => SubcateogryModel.fromJson(subcategory))
              .toList();
        } else {
          debugPrint('subcategory Not Found');
          return [];
        }
      } else if (response.statusCode == 404) {
        debugPrint('Sub Category Not Found');
        return [];
      } else {
        debugPrint('failed to fetch sub category');
        return [];
      }
    } catch (e) {
      debugPrint('error fetching categories: $e');
      return [];
    }
  }
}
