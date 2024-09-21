import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vendor_store_app/global_variables.dart';
import 'package:vendor_store_app/models/product_model.dart';
import 'package:vendor_store_app/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<void> uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
    required context,
  }) async {
    if (pickedImages != null) {
      final cloudinary = CloudinaryPublic(
        dotenv.env['CLOUD_NAME']!,
        dotenv.env['PRESET_NAME']!,
      );
      final List<String> images = [];
      // Loop through each image in the picked Images List
      for (var i = 0; i < pickedImages.length; i++) {
        // Await the upload of the current image to cloudinary
        CloudinaryResponse cloudinaryResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            pickedImages[i].path,
            folder: productName,
          ),
        );
        // Add the secure Url to the images List
        images.add(cloudinaryResponse.secureUrl);
        debugPrint('عکس محصول: $images');
      }
      if (category.isNotEmpty && subCategory.isNotEmpty) {
        final ProductModel productModel = ProductModel(
          id: '',
          productName: productName,
          productPrice: productPrice,
          quantity: quantity,
          description: description,
          category: category,
          vendorId: vendorId,
          fullName: fullName,
          subCategory: subCategory,
          images: images,
        );
        http.Response response = await http.post(
          Uri.parse('$uri/api/add-product'),
          body: productModel.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );
        manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(
              context,
              'محصول با موفقیت بارگزاری شد.',
              background: Colors.green,
            );
          },
        );
      } else {
        showSnackBar(
          context,
          'دیته بندی یا زیر دسته بندی خالی است',
          background: Colors.red,
        );
      }
    } else {
      showSnackBar(
        context,
        'عکس محصول را انتخواب کنید',
        background: Colors.yellow.shade700,
      );
    }
  }
}
