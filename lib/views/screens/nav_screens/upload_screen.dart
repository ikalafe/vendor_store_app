import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendor_store_app/views/screens/nav_screens/widgets/custom_input_widget.dart';

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

  late FocusNode focusNodeName;
  late FocusNode focusNodePrice;
  late FocusNode focusNodeQuantity;
  late FocusNode focusNodeDescription;

  @override
  void initState() {
    super.initState();
    focusNodeName = FocusNode();
    focusNodePrice = FocusNode();
    focusNodeQuantity = FocusNode();
    focusNodeDescription = FocusNode();
  }

  @override
  void dispose() {
    focusNodeName.dispose();
    focusNodePrice.dispose();
    focusNodeQuantity.dispose();
    focusNodeDescription.dispose();
    super.dispose();
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
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 50,
                      height: 50,
                      child: Image.file(
                        images[index - 1],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
          },
        ),
        InkWell(
          onTap: () => chooseImage(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xff5796E4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'عکس محصول',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Icon(
                    Iconsax.gallery_add_copy,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            CustomInputWidget(
              focusNode: focusNodeName,
              inputLabel: 'نام محصول',
            ),
            const SizedBox(
              height: 10,
            ),
            CustomInputWidget(
              focusNode: focusNodePrice,
              inputLabel: 'قیمت محصول',
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomInputWidget(
              focusNode: focusNodeQuantity,
              inputLabel: 'تعداد محصول',
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomInputWidget(
              focusNode: focusNodeDescription,
              inputLabel: 'توضیحات محصول',
              inputFormatter: FilteringTextInputFormatter.digitsOnly,
              maxLengthInput: 1000,
              maxLinesInput: 3,
            ),
          ],
        )
      ],
    );
  }
}
