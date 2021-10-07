import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vortez_supermarket_app/model/categoryproductmodel.dart';
import 'package:vortez_supermarket_app/screens/item_view_screen.dart';
import 'package:vortez_supermarket_app/widgets/single_product.dart';

class CategoryScreen extends StatefulWidget {
  final String id;
  final String colloection;
  CategoryScreen({required this.id, required this.colloection});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<CategoryProductModel> categoryProduct = [], categorySearch = [];
  void searchShow(String query) {
    print(categorySearch.length);
    // flashSaleSnapshot.data!.docs.where((element) => false)
    setState(() {
      categorySearch = categoryProduct.where((element) {
        return element.productName.toUpperCase().contains(query) ||
            element.productName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  color: Colors.yellowAccent.shade700,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.expand_more,
                    ),
                  ),
                  title: TextField(
                    onChanged: (text) {
                      searchShow(text);
                    },
                    decoration: InputDecoration(
                        hintText: 'search', border: InputBorder.none),
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('categories')
                  .doc(widget.id)
                  .collection(widget.colloection)
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshort) {
                if (!snapshort.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<CategoryProductModel> list = [];
                snapshort.data!.docs.forEach((element) {
                  list.add(CategoryProductModel(
                    prodectImage: element.get('productImage'),
                    productCategory: element.get('productCategory'),
                    productId: element.get('productId'),
                    productName: element.get('productName'),
                    productOffer: element.get('productOffer'),
                    productPrice: element.get('ProductPrice'),
                    productQuantity: 1,
                    productsubtitle: element.get('productsubtitle'),
                  ));
                });

                categoryProduct = list;

                return categorySearch.length < 1
                    ? GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categoryProduct.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 3.0,
                            crossAxisCount: 1,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20),
                        itemBuilder: (context, index) {
                          CategoryProductModel data = categoryProduct[index];
                          return SingleProduct(
                            image: data.prodectImage,
                            price: data.productPrice,
                            offer: data.productOffer,
                            title: data.productName,
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ItemViewScreen(
                                          prodectImage: data.prodectImage,
                                          productName: data.productName,
                                          productPrice: data.productPrice,
                                          productsubtitle:
                                              data.productsubtitle)));
                            },
                          );
                        },
                      )
                    : GridView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categorySearch.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 3.0,
                            crossAxisCount: 1,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20),
                        itemBuilder: (context, index) {
                          CategoryProductModel data = categorySearch[index];
                          return SingleProduct(
                            image: data.prodectImage,
                            price: data.productPrice,
                            offer: data.productOffer,
                            title: data.productName,
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ItemViewScreen(
                                          prodectImage: data.prodectImage,
                                          productName: data.productName,
                                          productPrice: data.productPrice,
                                          productsubtitle: 'productsubtitle')));
                            },
                          );
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
