import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductController {
  void uploadProduct({
    required String productName,
    required int productPrice,
    required int quantity,
    required String description,
    required String category,
    required String vendorId,
    required String fullName,
    required String subCategory,
    required List<File>? pickedImages,
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
    }
  }
}
