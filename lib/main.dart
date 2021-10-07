import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:vortez_supermarket_app/model/productmodel.dart';
import 'package:vortez_supermarket_app/provider/DatabaseProvider.dart';
import 'package:vortez_supermarket_app/screens/cart_screen.dart';
import 'package:vortez_supermarket_app/screens/category_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vortez_supermarket_app/screens/item_view_screen.dart';
import 'package:vortez_supermarket_app/widgets/category_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

// import 'provde';
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Safwana store',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.orange,
        ),
        home: ChangeNotifierProvider<DatabaseProvider>(
          create: (ctx) => DatabaseProvider(),
          child: Homescreen(),
        ),
      ),
      designSize: Size(414, 896),
    );
  }
}

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late DatabaseProvider databaseProvider;

  late AsyncSnapshot<QuerySnapshot> flashSaleSnapshot,
      bestDealsSnapshot,
      topSellerSnapshot,
      searchforSnapshot;
  List<ProductModel> flashSaleList = [],
      topSellersList = [],
      peopleAlsoSearchList = [];
  void searchShow(String query) {
    // flashSaleSnapshot.data!.docs.where((element) => false)
    setState(() {
      flashSaleList = databaseProvider.flashSaleList.where((element) {
        return element.productName.toUpperCase().contains(query) ||
            element.productName.toLowerCase().contains(query);
      }).toList();
      topSellersList = databaseProvider.topSellersList.where((element) {
        return element.productName.toUpperCase().contains(query) ||
            element.productName.toLowerCase().contains(query);
      }).toList();
      peopleAlsoSearchList =
          databaseProvider.peopleAlsoSearchList.where((element) {
        return element.productName.toUpperCase().contains(query) ||
            element.productName.toLowerCase().contains(query);
      }).toList();
    });
  }

  bool isRight = false;
  @override
  void initState() {
    DatabaseProvider provider =
        Provider.of<DatabaseProvider>(context, listen: false);
    provider.getFlashSaleList();
    provider.getPeopleAlsoSearchList();
    provider.getTopSellersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    databaseProvider = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 42.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30.w,
                            height: 30.h,
                            child:
                                Image.asset("assets/images/LOGO_SAFWANA.png"),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Safwana',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 28,
                                wordSpacing: 0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(
                                  quantity: 1,
                                  image: "widget.prodectImage",
                                  productname: "yes",
                                  productsubtitle: "widget.productsubtitle",
                                  price: 1212),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.yellow.shade700,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Box
                Container(
                  margin: EdgeInsets.only(
                      left: 35.w, right: 35.w, top: 29.h, bottom: 26.h),
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
                          border: InputBorder.none,
                          hintText: 'Search anything.'),
                    ),
                  ),
                ),

                //Imaage Slider

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  height: 180.h,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("slider")
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> stramSnapshot) {
                      if (!stramSnapshot.hasData) {
                        return Center(
                          child:
                              CircularProgressIndicator(color: Colors.orange),
                        );
                      }

                      return CarouselSlider.builder(
                        itemCount: stramSnapshot.data!.docs.length,
                        itemBuilder: (context, index, ind) {
                          DocumentSnapshot sliderImage =
                              stramSnapshot.data!.docs[index];
                          Object? getImage = sliderImage.data();
                          return Image.network(
                            stramSnapshot.data!.docs[index]['image'],
                            fit: BoxFit.fill,
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          initialPage: 0,
                        ),
                      );
                    },
                  ),
                ),

                // flash sale title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Flash Sale',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SlideCountdown(
                        duration: Duration(days: 0, hours: 23, minutes: 30),
                        slideDirection: SlideDirection.up,
                        fade: true,
                        icon: Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.alarm,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Flash sale list
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  height: 240.h,
                  child: flashSaleList.isEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: databaseProvider.flashSaleList.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel =
                                databaseProvider.flashSaleList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemViewScreen(
                                      prodectImage: productModel.prodectImage,
                                      productName: productModel.productName,
                                      productPrice: productModel.productPrice,
                                      productsubtitle:
                                          productModel.productsubtitle,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: productModel.prodectImage,
                                    child: Container(
                                      margin: EdgeInsets.all(10.0),
                                      alignment: Alignment.topRight,
                                      height: 134.h,
                                      width: 127.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              productModel.prodectImage),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productModel.productName,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productPrice}'
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.yellow.shade800,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productoldprice}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: flashSaleList.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel = flashSaleList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemViewScreen(
                                      prodectImage: productModel.prodectImage,
                                      productName: productModel.productName,
                                      productPrice: productModel.productPrice,
                                      productsubtitle:
                                          productModel.productsubtitle,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    alignment: Alignment.topRight,
                                    height: 134.h,
                                    width: 127.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            productModel.prodectImage),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productModel.productName,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productPrice}'
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Category title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'categories',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // Category List
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  height: 80.h,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("categories")
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> stramSnapshot) {
                      if (!stramSnapshot.hasData) {
                        return Center(
                          child:
                              CircularProgressIndicator(color: Colors.orange),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: stramSnapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return CategoryList(
                            image: stramSnapshot.data!.docs[index]
                                ['categoryImage'],
                            categoryName: stramSnapshot.data!.docs[index]
                                ['categoryName'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryScreen(
                                    colloection: stramSnapshot.data!.docs[index]
                                        ['categoryName'],
                                    id: stramSnapshot.data!.docs[index].id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                //Best deal title

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'Best Deals',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                //Best deal list
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  height: 240.h,
                  child: flashSaleList.isEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: databaseProvider.flashSaleList.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel =
                                databaseProvider.flashSaleList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemViewScreen(
                                      prodectImage: productModel.prodectImage,
                                      productName: productModel.productName,
                                      productPrice: productModel.productPrice,
                                      productsubtitle:
                                          productModel.productsubtitle,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    alignment: Alignment.topRight,
                                    height: 134.h,
                                    width: 127.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            productModel.prodectImage),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productModel.productName,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productPrice}'
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.yellow.shade800,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productoldprice}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: flashSaleList.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel = flashSaleList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemViewScreen(
                                      prodectImage: productModel.prodectImage,
                                      productName: productModel.productName,
                                      productPrice: productModel.productPrice,
                                      productsubtitle:
                                          productModel.productsubtitle,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    alignment: Alignment.topRight,
                                    height: 134.h,
                                    width: 127.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            productModel.prodectImage),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productModel.productName,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productPrice}'
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.yellow.shade800,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),

                // Image slider
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  height: 180.h,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("slider")
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> stramSnapshot) {
                      if (!stramSnapshot.hasData) {
                        return Center(
                          child:
                              CircularProgressIndicator(color: Colors.purple),
                        );
                      }

                      return CarouselSlider.builder(
                        itemCount: stramSnapshot.data!.docs.length,
                        itemBuilder: (context, index, ind) {
                          DocumentSnapshot sliderImage =
                              stramSnapshot.data!.docs[index];
                          Object? getImage = sliderImage.data();
                          return Image.network(
                            stramSnapshot.data!.docs[index]['image'],
                            fit: BoxFit.fill,
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          initialPage: 0,
                        ),
                      );
                    },
                  ),
                ),
                //Top sellers title

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'Top Sellers',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Top Sellers List

                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  height: 240.h,
                  child: topSellersList.isEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: databaseProvider.topSellersList.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel =
                                databaseProvider.topSellersList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemViewScreen(
                                      prodectImage: productModel.prodectImage,
                                      productName: productModel.productName,
                                      productPrice: productModel.productPrice,
                                      productsubtitle:
                                          productModel.productsubtitle,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: productModel.prodectImage,
                                    child: Container(
                                      margin: EdgeInsets.all(10.0),
                                      alignment: Alignment.topRight,
                                      height: 134.h,
                                      width: 127.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              productModel.prodectImage),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productModel.productName,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productPrice}'
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.yellow.shade800,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productoldprice}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: topSellersList.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel = topSellersList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemViewScreen(
                                      prodectImage: productModel.prodectImage,
                                      productName: productModel.productName,
                                      productPrice: productModel.productPrice,
                                      productsubtitle:
                                          productModel.productsubtitle,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    alignment: Alignment.topRight,
                                    height: 134.h,
                                    width: 127.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            productModel.prodectImage),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productModel.productName,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productPrice}'
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),

                // Pepole  also Search titlr

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'People also search for',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                //  Pepole aslo serch list
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10.h,
                  ),
                  height: 240.h,
                  child: peopleAlsoSearchList.isEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount:
                              databaseProvider.peopleAlsoSearchList.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel =
                                databaseProvider.peopleAlsoSearchList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemViewScreen(
                                      prodectImage: productModel.prodectImage,
                                      productName: productModel.productName,
                                      productPrice: productModel.productPrice,
                                      productsubtitle:
                                          productModel.productsubtitle,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: productModel.prodectImage,
                                    child: Container(
                                      margin: EdgeInsets.all(10.0),
                                      alignment: Alignment.topRight,
                                      height: 134.h,
                                      width: 127.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              productModel.prodectImage),
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productModel.productName,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productPrice}'
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.yellow.shade800,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productoldprice}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: peopleAlsoSearchList.length,
                          itemBuilder: (context, index) {
                            ProductModel productModel =
                                peopleAlsoSearchList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemViewScreen(
                                      prodectImage: productModel.prodectImage,
                                      productName: productModel.productName,
                                      productPrice: productModel.productPrice,
                                      productsubtitle:
                                          productModel.productsubtitle,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    alignment: Alignment.topRight,
                                    height: 134.h,
                                    width: 127.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            productModel.prodectImage),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productModel.productName,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          'AED ${productModel.productPrice}'
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
