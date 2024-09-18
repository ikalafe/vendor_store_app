import 'dart:convert';

class SubcateogryModel {
  final String id;
  final String cateogryId;
  final String categoryName;
  final String image;
  final String subCategoryName;

  SubcateogryModel({
    required this.id,
    required this.cateogryId,
    required this.categoryName,
    required this.image,
    required this.subCategoryName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryId': cateogryId,
      'categoryName': categoryName,
      'image': image,
      'subCategoryName': subCategoryName,
    };
  }

  String toJson() => json.encode(toMap());

  factory SubcateogryModel.fromJson(Map<String, dynamic> map) {
    return SubcateogryModel(
      id: map['_id'] as String,
      cateogryId: map['cateogryId'] as String,
      categoryName: map['categoryName'] as String,
      image: map['image'] as String,
      subCategoryName: map['subCategoryName'] as String,
    );
  }
}
