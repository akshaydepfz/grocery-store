import 'dart:convert';

import 'package:flutter/services.dart';

class CategoryProductModel {
  final String prodectImage;
  final String productName;
  final String productId;
  final String productOffer;
  final double productPrice;
  final String productCategory;
  final String productsubtitle;
  final int productQuantity;
  CategoryProductModel({
    required this.productsubtitle,
    required this.prodectImage,
    required this.productName,
    required this.productQuantity,
    required this.productPrice,
    required this.productOffer,
    required this.productCategory,
    required this.productId,
  });

  factory CategoryProductModel.fromJson(dynamic jsonData) {
    return CategoryProductModel(
      prodectImage: jsonData['productImage'],
      productName: jsonData['productName'],
      productQuantity: 1,
      productPrice: jsonData['ProductPrice'],
      productCategory: jsonData['productCategory'],
      productId: jsonData['productId'],
      productOffer: jsonData['productOffer'],
      productsubtitle: jsonData['productsubtitle'],
    );
  }

  static Map<String, dynamic> toMap(CategoryProductModel data) => {
        'productImage': data.prodectImage,
        'productName': data.productName,
        'productQuantity': data.productQuantity,
        'productPrice': data.productPrice,
        'productCategory': data.productCategory,
        'productId': data.productId,
        'productOffer': data.productOffer,
        'productsubtitle': data.productsubtitle
      };
  static String encode(List<CategoryProductModel> restauranList) => json.encode(
        restauranList
            .map<Map<String, dynamic>>(
                (listData) => CategoryProductModel.toMap(listData))
            .toList(),
      );

  static List<CategoryProductModel> decode(String restauranList) => (json
          .decode(restauranList) as List<dynamic>)
      .map<CategoryProductModel>((item) => CategoryProductModel.fromJson(item))
      .toList();
}
