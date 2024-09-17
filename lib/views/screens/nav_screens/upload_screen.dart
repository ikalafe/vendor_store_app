import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // Create an instance of ImagePicker to handle image selection
  final ImagePicker picker = ImagePicker();

  // Initialize an empty lsit to store the selected images
  List<File> images = [];

  // Define a function to choose image from the gallery
  chooseImage() async {
    // Use the picker to select an image from the gallery
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // Check if no image was picked
    if (pickedFile == null) {
      debugPrint('No Image Picked');
    } else {
      // If an Image was Picked, Update the state and add the image to the list
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true, // Allow the GridView to shrink to fit the content
          itemCount: images.length +
              1, // The number of items in the grid (+1 for the add button)
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            // If the index is 0, display an iconButton to add a new image
            return index == 0
                ? Center(
                    child: IconButton(
                      onPressed: () {
                        chooseImage();
                      },
                      icon: const Icon(Iconsax.add_square_copy),
                    ),
                  )
                : SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.file(images[index - 1]),
                  );
          },
        )
      ],
    );
  }
}
