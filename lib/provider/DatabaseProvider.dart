import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vortez_supermarket_app/model/productmodel.dart';

class DatabaseProvider with ChangeNotifier {
  List<ProductModel> flashSaleList = [];
  void getFlashSaleList() async {
    List<ProductModel> newflashSaleList = [];
    ProductModel model;

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("FlashSaleList").get();

    querySnapshot.docs.forEach((element) {
      model = ProductModel.fromJson(element);
      newflashSaleList.add(model);
    });
    flashSaleList = newflashSaleList;
    notifyListeners();
  }

  List<ProductModel> topSellersList = [];
  void getTopSellersList() async {
    List<ProductModel> newTopSellersList = [];
    ProductModel model;

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("TopSellers").get();
    querySnapshot.docs.forEach((element) {
      model = ProductModel.fromJson(element);
      newTopSellersList.add(model);
    });
    topSellersList = newTopSellersList;
    notifyListeners();
  }

  List<ProductModel> peopleAlsoSearchList = [];
  void getPeopleAlsoSearchList() async {
    List<ProductModel> newPeopleAlsoSearchList = [];
    ProductModel model;

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("BestDeals").get();
    querySnapshot.docs.forEach((element) {
      model = ProductModel.fromJson(element);
      newPeopleAlsoSearchList.add(model);
    });
    peopleAlsoSearchList = newPeopleAlsoSearchList;
    notifyListeners();
  }
}
