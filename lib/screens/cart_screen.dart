import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vortez_supermarket_app/model/productmodel.dart';

List<ProductModel> newList = [];

class CartScreen extends StatefulWidget {
  final String image;
  final int quantity;
  final String productname;
  final String productsubtitle;

  final double price;

  const CartScreen(
      {required this.image,
      required this.productname,
      required this.quantity,
      required this.productsubtitle,
      required this.price});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<ProductModel> productList = [];

  void addListSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartList = await prefs.getString('list');
    print(cartList);
    if (cartList != null) {
      if (widget.productname == "yes") {
        // prefs.remove("list");
        String? cartList = await prefs.getString('list');

        setState(() {
          productList = ProductModel.decode(cartList!);
        });
      } else {
        String? cartList = await prefs.getString('list');

        setState(() {
          productList = ProductModel.decode(cartList!);
        });
        productList.add(ProductModel(
          prodectImage: widget.image,
          productQuantity: widget.quantity,
          productName: widget.productname,
          productPrice: widget.price,
          productsubtitle: widget.productsubtitle,
          productoldprice: '',
        ));
        await prefs.setString('list', ProductModel.encode(productList));
      }
    } else {
      if (widget.productname == "yes") {
      } else {
        newList.add(ProductModel(
          prodectImage: widget.image,
          productQuantity: widget.quantity,
          productName: widget.productname,
          productPrice: widget.price,
          productsubtitle: widget.productsubtitle,
          productoldprice: '',
        ));
        await prefs.setString('list', ProductModel.encode(newList));
        String? cartList = await prefs.getString('list');

        setState(() {
          productList = ProductModel.decode(cartList!);
        });
      }
    }
  }

  @override
  void initState() {
    addListSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // int quantity = 1;

    void launchWhatsapp({required number, required message}) async {
      String url = 'whatsapp://send?phone=$number&text=$message';
      await canLaunch(url) ? launch(url) : print('cant  open Whatsapp');
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 1,
        onPressed: () async {
          print("object");
          final sampleData = productList
              .map((h) => {
                    "\n ": '*Product*',
                    "\n *Name*": h.productName.replaceAll("&", " "),
                    "\n *Price* ": h.productPrice,
                    "\n *Quantity*": h.productQuantity,
                    '\n': '*______________________________*',
                  })
              .toList();

          launchWhatsapp(number: '+919946152058', message: sampleData);
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          setState(() {
            productList.clear();
          });
          await prefs.setString('list', ProductModel.encode(productList));
        },
        backgroundColor: Color(0xFF240046),
        label: Text(
          'Go Checkout',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('My cart'),
      ),
      body: Stack(
        children: [
          kIsWeb
              ? Positioned(
                  bottom: 15,
                  left: 15,
                  child: FloatingActionButton.extended(
                      heroTag: 2,
                      onPressed: () {},
                      label: Text('Download the app now')),
                )
              : SizedBox(),
          ListView.builder(
              itemCount: productList.length,
              itemBuilder: (ctx, index) {
                double price = productList[index].productQuantity *
                    productList[index].productPrice;
                return Container(
                  padding: EdgeInsets.all(10.0),
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.shade100,
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage(productList[index].prodectImage),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    productList[index].productName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      setState(() {
                                        productList.removeAt(index);
                                      });
                                      await prefs.setString('list',
                                          ProductModel.encode(productList));
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    if (productList[index].productQuantity >
                                        1) {
                                      setState(() {
                                        productList[index].productQuantity--;
                                      });
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString('list',
                                          ProductModel.encode(productList));
                                    }
                                  },
                                  child: Icon(Icons.remove),
                                ),
                                Text(
                                  productList[index].productQuantity.toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      productList[index].productQuantity++;
                                    });
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('list',
                                        ProductModel.encode(productList));
                                  },
                                  child: Icon(Icons.add),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 120.w,
                                ),
                                Text(
                                  'AED ${price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
