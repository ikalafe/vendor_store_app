import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vendor_store_app/controllers/cateogry_controller.dart';
import 'package:vendor_store_app/controllers/product_controller.dart';
import 'package:vendor_store_app/controllers/subcategory_controller.dart';
import 'package:vendor_store_app/models/category_model.dart';
import 'package:vendor_store_app/models/subcateogry_model.dart';
import 'package:vendor_store_app/provider/vendor_provider.dart';
import 'package:vendor_store_app/services/manage_http_response.dart';
import 'package:vendor_store_app/views/screens/nav_screens/widgets/custom_input_widget.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  late Future<List<CategoryModel>> futureCategory;
  CategoryModel? selectedCategory;
  Future<List<SubcateogryModel>>? futureSubCategories;
  SubcateogryModel? selectedSubcategory;
  // Create an instance of ImagePicker to handle image selection
  final ImagePicker picker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();

  late String productName;
  late int productPrice;
  late int productQuantity;
  late String productDescription;

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
    futureCategory = CateogryController().loadCategories();
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

  getSubcategoryByCategory(value) {
    // Fetch Subcategories base on the selected Category
    futureSubCategories =
        SubcategoryController().getSubCategoryByCategoryName(value.name);
    // Reset the selected subcategory
    selectedSubcategory = null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap:
                  true, // Allow the GridView to shrink to fit the content
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
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
                  onChange: (value) => productName = value,
                  validatorForm: (value) {
                    if (value!.isEmpty) {
                      return "نام محصول خالی است";
                    } else {
                      return null;
                    }
                  },
                  focusNode: focusNodeName,
                  inputLabel: 'نام محصول',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomInputWidget(
                  onChange: (value) {
                    String englishValue = convertToEnglishNumbers(value);
                    productPrice = int.tryParse(englishValue) ?? 0;
                  },
                  validatorForm: (value) {
                    if (value!.isEmpty) {
                      return "قیمت محصول خالی است";
                    } else {
                      return null;
                    }
                  },
                  focusNode: focusNodePrice,
                  inputLabel: 'قیمت محصول',
                  inputFormatter: FilteringTextInputFormatter.allow(
                    RegExp(r'[\u06F0-\u06F9\u0660-\u06690-9]+'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomInputWidget(
                  onChange: (value) {
                    String englishValue = convertToEnglishNumbers(value);
                    productQuantity = int.tryParse(englishValue) ?? 0;
                  },
                  validatorForm: (value) {
                    if (value!.isEmpty) {
                      return "تعداد محصول خالی است";
                    } else {
                      return null;
                    }
                  },
                  focusNode: focusNodeQuantity,
                  inputLabel: 'تعداد',
                  inputFormatter: FilteringTextInputFormatter.allow(
                      RegExp(r'[\u06F0-\u06F9\u0660-\u06690-9]+')),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: SizedBox(
                          child: FutureBuilder<List<CategoryModel>>(
                            future: futureCategory,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text(
                                    'مشکلی در دریافت دسته بندی رخ داد: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('دسته بندی یافت نشد'));
                              } else {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff5796E4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 20,
                                  ),
                                  child: DropdownButton<CategoryModel>(
                                    value: selectedCategory,
                                    hint: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      child: const Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        'انتخواب دسته بندی',
                                        style: TextStyle(
                                          fontFamily: 'Dana',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    dropdownColor: const Color(0xff5796E4),
                                    underline: const SizedBox(),
                                    items: snapshot.data!
                                        .map((CategoryModel category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                          category.name,
                                          style: const TextStyle(
                                              fontFamily: 'Dana'),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategory = value;
                                      });
                                      getSubcategoryByCategory(
                                          selectedCategory);
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: FutureBuilder<List<SubcateogryModel>>(
                            future: futureSubCategories,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text(
                                  'مشکلی در دریافت زیر مجموعه دسته بندی رخ داد: ${snapshot.error}',
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('دسته بندی را انتخواب کنید'));
                              } else {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff5796E4),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  child: DropdownButton<SubcateogryModel>(
                                    value: selectedSubcategory,
                                    hint: const SizedBox(
                                      width: 100,
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        'زیرمجموعه دسته بندی',
                                        style: TextStyle(
                                          fontFamily: 'Dana',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    dropdownColor: const Color(0xff5796E4),
                                    underline: const SizedBox(),
                                    items: snapshot.data!
                                        .map((SubcateogryModel category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: SizedBox(
                                          width: 50,
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                            category.subCategoryName,
                                            style: const TextStyle(
                                                fontFamily: 'Dana'),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedSubcategory = value;
                                      });
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomInputWidget(
                  onChange: (value) => productDescription = value,
                  validatorForm: (value) {
                    if (value!.isEmpty) {
                      return "توضیحات محصول خالی است";
                    } else {
                      return null;
                    }
                  },
                  focusNode: focusNodeDescription,
                  inputLabel: 'توضیحات محصول',
                  maxLengthInput: 1000,
                  maxLinesInput: 3,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: InkWell(
                onTap: () async {
                  final fullName = ref.read(vendorProvider)!.fullName;
                  final vendorId = ref.read(vendorProvider)!.id;
                  if (_formKey.currentState!.validate()) {
                    _productController.uploadProduct(
                      productName: productName,
                      productPrice: productPrice,
                      quantity: productQuantity,
                      description: productDescription,
                      category: selectedCategory!.name,
                      vendorId: vendorId,
                      fullName: fullName,
                      subCategory: selectedSubcategory!.subCategoryName,
                      pickedImages: images,
                      context: context,
                    );
                  } else {
                    showSnackBar(
                      context,
                      'لطفا تمام فیلد ها را پر کنید',
                      background: Colors.red.shade500,
                    );
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xff355B8A),
                  ),
                  child: const Center(
                    child: Text(
                      'بارگزاری محصول',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

String convertToEnglishNumbers(String input) {
  final persianToEnglishDigits = {
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9'
  };

  input = input.replaceAllMapped(RegExp(r'[۰-۹]'), (match) {
    return persianToEnglishDigits[match.group(0)]!;
  });

  return input;
}

String formatPrice(String value) {
  final formatter = NumberFormat('#,###');
  // تبدیل عدد فارسی به انگلیسی (اختیاری، در صورت نیاز)
  String englishValue = convertToEnglishNumbers(value);
  
  // تبدیل رشته به عدد
  int number = int.tryParse(englishValue) ?? 0;
  
  // فرمت کردن عدد
  return formatter.format(number);
}
