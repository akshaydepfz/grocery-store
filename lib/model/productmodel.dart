import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductModel {
  final String prodectImage;
  final String productName;
  final double productPrice;
  final String productsubtitle;
  final String productoldprice;
  int productQuantity;
  ProductModel({
    required this.productoldprice,
    required this.prodectImage,
    required this.productName,
    required this.productQuantity,
    required this.productPrice,
    required this.productsubtitle,
  });

  List<ProductModel> productList = [];
  pref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartList = await prefs.getString('list');
    productList = ProductModel.decode(cartList!);
    productList.forEach((element) {
      element.productQuantity;
    });
  }

  factory ProductModel.fromJson(dynamic jsonData) {
    return ProductModel(
      productoldprice: jsonData['productoldprice'],
      prodectImage: jsonData['productImage'],
      productName: jsonData['productName'],
      productQuantity: 1,
      productPrice: jsonData['productPrice'],
      productsubtitle: jsonData['productsubtitle'],
    );
  }

  static Map<String, dynamic> toMap(ProductModel data) => {
        'productImage': data.prodectImage,
        'productName': data.productName,
        'productQuantity': data.productQuantity,
        'productPrice': data.productPrice,
        'productsubtitle': data.productsubtitle,
        'productoldprice': data.productoldprice
      };
  static String encode(List<ProductModel> restauranList) => json.encode(
        restauranList
            .map<Map<String, dynamic>>(
                (listData) => ProductModel.toMap(listData))
            .toList(),
      );

  static List<ProductModel> decode(String restauranList) =>
      (json.decode(restauranList) as List<dynamic>)
          .map<ProductModel>((item) => ProductModel.fromJson(item))
          .toList();
}
