import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:nottacafe/classes/food_items.dart';
import 'package:nottacafe/main.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/shared_components/homepage_card.dart';
import 'package:nottacafe/shared_components/homepage_card_vendor.dart';
import 'package:nottacafe/shared_components/rounded_rectangle.dart';
import 'package:nottacafe/shared_components/vendor_dishes_card.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/auth/login_register/login_register.dart';
import 'package:nottacafe/src/screens/cart/cart.dart';
import 'package:nottacafe/src/screens/edit_profile/edit_profile_vendor.dart';
import 'package:nottacafe/src/screens/food/add_dish.dart';
import 'package:nottacafe/src/screens/restaurant/restaurant.dart';
import 'package:nottacafe/src/screens/welcome/welcome.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:nottacafe/shared_components/category_card.dart';
import 'package:provider/provider.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({Key? key}) : super(key: key);

  static const routeName = '/vendorhome';
  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  late MyFirebaseAuth _myFirebaseAuth;
  late int _selectedCategory;
  late DarkThemeProvider themeChange;
  bool theme = false;
  //late Future categoriesData;
  late Future getAllData;

  @override
  void initState() {
    themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    super.initState();
    _myFirebaseAuth = MyFirebaseAuth();
    _selectedCategory = 0;
    //categoriesData = getCategories();
    getAllData = getData();
  }

  //List<CuisineItem> _cuisineItems = [];
  List<PendingOrderItems> _pendingOrderItems = [];
  List<FulfilledOrderItems> _fulfilledOrderItems = [];
  List<FoodItem> _foodItems = [];

  Future getPendingOrders() async {
    _pendingOrderItems.clear();
    QuerySnapshot querySnapshotPendingOrders = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(_myFirebaseAuth.getCurrentUser!.uid)
        .collection('pendingOrders')
        .get();
    for (int i = 0; i < querySnapshotPendingOrders.docs.length; i++) {
      DocumentSnapshot documentSnapshotRelevantFood = await FirebaseFirestore
          .instance
          .collection('food')
          .doc(querySnapshotPendingOrders.docs[i]['foodID'])
          .get();
      _pendingOrderItems.add(PendingOrderItems(
          orderID: querySnapshotPendingOrders.docs[i].id,
          foodID: querySnapshotPendingOrders.docs[i]['foodID'],
          foodName: documentSnapshotRelevantFood['name'],
          quantity: querySnapshotPendingOrders.docs[i]['quantity'],
          deliveryTime: querySnapshotPendingOrders.docs[i]['deliveryTime'],
          image: documentSnapshotRelevantFood['image'],
          address: querySnapshotPendingOrders.docs[i]['address'],
          relevantID: documentSnapshotRelevantFood['restaurantID'],
          cName: querySnapshotPendingOrders.docs[i]['cName'],
          cPhone: querySnapshotPendingOrders.docs[i]['cPhone']));
    }
  }

  Future getFulfilledOrders() async {
    _fulfilledOrderItems.clear();
    QuerySnapshot querySnapshotFulfilledOrders = await FirebaseFirestore
        .instance
        .collection('restaurants')
        .doc(_myFirebaseAuth.getCurrentUser!.uid)
        .collection('fulfilledOrders')
        .get();

    for (int i = 0; i < querySnapshotFulfilledOrders.docs.length; i++) {
      DocumentSnapshot documentSnapshotRelevantFood = await FirebaseFirestore
          .instance
          .collection('food')
          .doc(querySnapshotFulfilledOrders.docs[i]['foodID'])
          .get();
      if (documentSnapshotRelevantFood.exists) {
        _fulfilledOrderItems.add(FulfilledOrderItems(
          foodID: querySnapshotFulfilledOrders.docs[i]['foodID'],
          foodName: documentSnapshotRelevantFood['name'],
          quantity: querySnapshotFulfilledOrders.docs[i]['quantity'],
          image: documentSnapshotRelevantFood['image'],
        ));
      } else {
        _fulfilledOrderItems.add(FulfilledOrderItems(
            foodID: 'xxx',
            foodName: "Deleted Item",
            quantity: 0,
            image: 'assets/images/error_image.png'));
      }
    }
    print(_fulfilledOrderItems.length);
  }

  Future getRelevantFood() async {
    _foodItems.clear();
    print('get relevant food called');
    QuerySnapshot querySnapshotRFood =
        await FirebaseFirestore.instance.collection('food').get();
    DocumentSnapshot documentSnapshotRestaurant = await FirebaseFirestore
        .instance
        .collection('restaurants')
        .doc(_myFirebaseAuth.getCurrentUser!.uid)
        .get();
    //print(documentSnapshotRestaurant['name']);
    //print(querySnapshotRFood.docs.length);
    for (int i = 0; i < querySnapshotRFood.docs.length; i++) {
      // print(querySnapshotRFood.docs[i]['restaurantID']);
      // print(_myFirebaseAuth.getCurrentUser!.uid);
      // print("_-----------------------");
      if (querySnapshotRFood.docs[i]['restaurantID'] ==
          _myFirebaseAuth.getCurrentUser!.uid) {
        print("equal found");
        DocumentSnapshot documentSnapshotCuisine = await FirebaseFirestore
            .instance
            .collection('cuisines')
            .doc(querySnapshotRFood.docs[i]['cuisineID'])
            .get();
        // print(documentSnapshotCuisine['name']);
        // print(querySnapshotRFood.docs[i].id);
        // print(querySnapshotRFood.docs[i]['name']);
        // print(querySnapshotRFood.docs[i]['restaurantID']);
        // print(documentSnapshotRestaurant['name']);
        // print(querySnapshotRFood.docs[i]['calorieCount']);
        // print(querySnapshotRFood.docs[i]['cuisineID']);
        // print(documentSnapshotCuisine['name']);
        // print(querySnapshotRFood.docs[i]['image']);
        // print(querySnapshotRFood.docs[i]['price']);

        _foodItems.add(FoodItem(
            foodID: querySnapshotRFood.docs[i].id,
            name: querySnapshotRFood.docs[i]['name'],
            restaurantID: querySnapshotRFood.docs[i]['restaurantID'],
            restaurantName: documentSnapshotRestaurant['name'],
            calorieCount: querySnapshotRFood.docs[i]['calorieCount'],
            cuisineID: querySnapshotRFood.docs[i]['cuisineID'],
            cuisineName: documentSnapshotCuisine['name'],
            image: querySnapshotRFood.docs[i]['image'],
            price: querySnapshotRFood.docs[i]['price'],
            description: querySnapshotRFood.docs[i]['description']));
        print("added food item");
      }
    }
    print(_foodItems.length);
  }

  Future getData() async {
    print("get data called");
    await getRelevantFood();
    await getPendingOrders();
    await getFulfilledOrders();
  }

  // Future getCategories() async {
  //   QuerySnapshot querySnapshotCategory = await FirebaseFirestore.instance.collection('cuisines').get();
  //   for (int i = 0; i < querySnapshotCategory.docs.length; i++) {
  //     _cuisineItems.add(CuisineItem(id: querySnapshotCategory.docs[i].id, title: querySnapshotCategory.docs[i]['name'], image: querySnapshotCategory.docs[i]['image']));
  //   }

  // }

  @override
  void didChangeDependencies() {
    themeChange = Provider.of<DarkThemeProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = themeChange.darkTheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
          title: const Text(
            'NottACafe Vendor',
            style: AppTextStyles.secondaryHeadingWhite,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(20))),
          actions: [
            IconButton(
                // onPressed: () async {
                //   await _myFirebaseAuth.signOutUser().then((response) {
                //     if (response == null) {
                //       Navigator.popUntil(context, (route) => route.isFirst);
                //       Navigator.restorablePopAndPushNamed(context, LoginRegister.routeName);
                //     }
                //     else {
                //       // UNSUCCESSFUL CASE
                //     }
                //   });
                // },
                onPressed: () {
                  showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return (Wrap(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30))),
                                child: Column(
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: RoundedRectangle()),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                40,
                                            horizontal: 20),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Dark Theme',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .tertiary,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Poppins'),
                                                ),
                                                // FlutterSwitch(
                                                //   width: MediaQuery.of(context).size.width / 7,
                                                //   height: 30,
                                                //   value: theme,
                                                //   // toggleSize: 20,
                                                //   onToggle: (val) {
                                                //     setState(() {
                                                //       theme = val;
                                                //     });
                                                //   }
                                                // )
                                                BottomSheetSwitch(
                                                    switchValue:
                                                        themeChange.darkTheme,
                                                    valueChanged: (value) {
                                                      setState(() => themeChange
                                                          .darkTheme = value);
                                                    })
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                        text: 'Edit Profile',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .tertiary,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                'Poppins'),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                justPush(
                                                                    context,
                                                                    EditProfileVendor());
                                                              })),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                  textAlign: TextAlign.left,
                                                  text: TextSpan(
                                                      text: 'Sign Out',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .tertiary,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              'Poppins'),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () async {
                                                              await _myFirebaseAuth
                                                                  .signOutUser()
                                                                  .then(
                                                                      (response) {
                                                                if (response ==
                                                                    null) {
                                                                  Navigator.popUntil(
                                                                      context,
                                                                      (route) =>
                                                                          route
                                                                              .isFirst);
                                                                  Navigator.restorablePopAndPushNamed(
                                                                      context,
                                                                      Welcome
                                                                          .routeName);
                                                                } else {
                                                                  // UNSUCCESSFUL CASE
                                                                }
                                                              });
                                                            })),
                                            )
                                          ],
                                        ))
                                  ],
                                ))
                          ],
                        ));
                      });
                },
                icon: const Icon(
                  Icons.settings_outlined,
                  color: AppColors.white,
                ))
          ]),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(children: [
            Image.asset(
                !themeChange.darkTheme
                    ? 'assets/images/bg.png'
                    : 'assets/images/bgdark.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover),
            FutureBuilder(
                future: getAllData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return RefreshIndicator(
                      onRefresh: () {
                        setState(() {
                          getAllData = getData();
                        });
                        //getAllData = getData();
                        return getAllData;
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          //itemCount: _selectedCategory == 0 ? _cuisineItems.length + 2 : _restaurantItems.length + 2,
                          itemCount: _selectedCategory == 0
                              ? _pendingOrderItems.length + 2
                              : _selectedCategory == 1
                                  ? _fulfilledOrderItems.length + 2
                                  : _foodItems.length + 3,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        30),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width * 0.035, right: MediaQuery.of(context).size.width * 0.035),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                3.25),
                                        child: CategoryCard(
                                          title: 'Pending Orders',
                                          icon: Icons.pending_actions_outlined,
                                          active: _selectedCategory == 0,
                                          onTap: () {
                                            setState(() {
                                              _selectedCategory = 0;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.25,
                                        child: CategoryCard(
                                          title: 'Fulfilled Orders',
                                          icon: Icons.task_outlined,
                                          active: _selectedCategory == 1,
                                          onTap: () {
                                            setState(() {
                                              _selectedCategory = 1;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width /
                                                3.25),
                                        child: CategoryCard(
                                          title: '\nDishes',
                                          icon: Icons.pending_actions_outlined,
                                          active: _selectedCategory == 2,
                                          onTap: () {
                                            setState(() {
                                              _selectedCategory = 2;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            if (index == 1) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical:
                                          MediaQuery.of(context).size.height /
                                              40),
                                  child: Text(
                                    _selectedCategory == 0
                                        ? 'Pending Orders'
                                        : _selectedCategory == 1
                                            ? 'Fulfilled Orders'
                                            : 'Dishes',
                                    style: isDark
                                        ? AppTextStyles.secondaryHeadingWhite
                                        : AppTextStyles.secondaryHeadingBlack,
                                  ));
                              //return SizedBox(height: 20);
                            }
                            if (index > 1) {
                              if (_selectedCategory == 0) {
                                // return HomepageCard(
                                //   title: _cuisineItems[index - 2].title,
                                //   image: _cuisineItems[index - 2].image,
                                //   category: 0,
                                //   index: index,
                                //   relevantID: _cuisineItems[index - 2].id,
                                // );
                                print('hello');
                                return HomepageCardVendor(
                                    orderID:
                                        _pendingOrderItems[index - 2].orderID,
                                    foodID:
                                        _pendingOrderItems[index - 2].foodID,
                                    foodName:
                                        _pendingOrderItems[index - 2].foodName,
                                    image: _pendingOrderItems[index - 2].image,
                                    quantity:
                                        _pendingOrderItems[index - 2].quantity,
                                    deliveryTime: _pendingOrderItems[index - 2]
                                        .deliveryTime,
                                    address:
                                        _pendingOrderItems[index - 2].address,
                                    relevantID: _pendingOrderItems[index - 2]
                                        .relevantID,
                                    category: 0,
                                    index: index,
                                    cName: _pendingOrderItems[index - 2].cName,
                                    cPhone:
                                        _pendingOrderItems[index - 2].cPhone);
                              } else if (_selectedCategory == 1) {
                                return HomepageCardVendor(
                                  image: _fulfilledOrderItems[index - 2].image,
                                  category: 1,
                                  foodID:
                                      _fulfilledOrderItems[index - 2].foodID,
                                  foodName:
                                      _fulfilledOrderItems[index - 2].foodName,
                                  quantity:
                                      _fulfilledOrderItems[index - 2].quantity,
                                );
                                // return HomepageCard(
                                //   title: _restaurantItems[index - 2].name,
                                //   image: _restaurantItems[index - 2].image,
                                //   description:
                                //       _restaurantItems[index - 2].description,
                                //   category: 1,
                                //   index: index,
                                //   relevantID: _restaurantItems[index - 2].id,
                                // );
                              } else if (_selectedCategory == 2) {
                                print('hello');
                                if (index == 2) {
                                  return Card(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      margin: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 3)),
                                      elevation: 10,
                                      shadowColor:
                                          Theme.of(context).colorScheme.shadow,
                                      child: InkWell(
                                          onTap: () {
                                            justPush(context, const AddDish());
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.add,
                                                size: 50,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Text(
                                                  "Add new dish",
                                                  style: AppTextStyles
                                                      .descriptionBlue,
                                                ),
                                              )
                                            ],
                                          )));
                                } else {
                                  return VendorDishesCard(
                                      foodID: _foodItems[index - 3].foodID,
                                      image: _foodItems[index - 3].image,
                                      foodName: _foodItems[index - 3].name,
                                      index: index - 1,
                                      price: _foodItems[index - 3].price,
                                      relevantID:
                                          _foodItems[index - 3].restaurantID,
                                      description:
                                          _foodItems[index - 3].description,
                                      calorieCount:
                                          _foodItems[index - 3].calorieCount);
                                }
                              }
                            }
                            return Container();
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                            child: Text('The app encountered some error :(')));
                  } else {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 30),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width /
                                      3.25),
                                  child: CategoryCard(
                                    title: 'Pending Orders',
                                    icon: Icons.pending_actions_outlined,
                                    active: _selectedCategory == 0,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = 0;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.25,
                                  child: CategoryCard(
                                    title: 'Fulfilled Orders',
                                    icon: Icons.task_outlined,
                                    active: _selectedCategory == 1,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = 1;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width /
                                      3.25),
                                  child: CategoryCard(
                                    title: '\nDishes',
                                    icon: Icons.pending_actions_outlined,
                                    active: _selectedCategory == 2,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = 2;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Center(
                              child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator()),
                            ))
                      ],
                    );
                    // return Container(
                    //     height: MediaQuery.of(context).size.height,
                    //     child: Center(
                    //       child: SizedBox(
                    //           width: 60,
                    //           height: 60,
                    //           child: CircularProgressIndicator()),
                    //     ));
                  }
                }),
          ])),
    );
  }
}

class CategoryItem {
  final String title;
  final IconData icon;
  final bool active;

  CategoryItem({required this.title, required this.icon, required this.active});
}

class PendingOrderItems {
  final String orderID;
  final String foodID;
  final String foodName;
  final String cPhone;
  final String cName;
  final int quantity;
  final String deliveryTime;
  final String image;
  final String address;
  final String relevantID;

  PendingOrderItems(
      {required this.orderID,
      required this.foodID,
      required this.foodName,
      required this.quantity,
      required this.deliveryTime,
      required this.image,
      required this.address,
      required this.relevantID,
      required this.cName,
      required this.cPhone});
}

class FulfilledOrderItems {
  final String foodID;
  final String foodName;
  final int quantity;
  final String image;

  FulfilledOrderItems({
    required this.foodID,
    required this.foodName,
    required this.quantity,
    required this.image,
  });
}

// List _cuisineItems = [
//   CuisineItem(
//     title: 'Chinese',
//     image: 'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=768,574',
//   ),
//   CuisineItem(
//     title: 'Mexican',
//     image: 'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=768,574',
//   ),
//   CuisineItem(
//     title: 'Italian',
//     image: 'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=768,574',
//   ),
//   CuisineItem(
//     title: 'Japanese',
//     image: 'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=768,574',
//   ),
//   CuisineItem(
//     title: 'Turkish',
//     image: 'https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=768,574',
//   ),
// ];

// List _restaurantItems = [
//   Restaurants(
//     name: 'No. 1 Restaurant',
//     image: 'https://axwwgrkdco.cloudimg.io/v7/__gmpics__/048f71dc300347bf9bae7e3b388ee685?width=500&sharp=1',
//     description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//     workingHours: '08 00-22 00',
//     location: 'nowhere'
//   ),
//   Restaurants(
//     name: 'The best Restaurant',
//     image: 'https://axwwgrkdco.cloudimg.io/v7/__gmpics__/048f71dc300347bf9bae7e3b388ee685?width=500&sharp=1',
//     description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//     workingHours: '08 00-22 00',
//     location: 'nowhere'
//   ),
//   Restaurants(
//     name: 'Amazing Restaurant',
//     image: 'https://axwwgrkdco.cloudimg.io/v7/__gmpics__/048f71dc300347bf9bae7e3b388ee685?width=500&sharp=1',
//     description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//     workingHours: '08 00-22 00',
//     location: 'nowhere'
//   ),
//   Restaurants(
//     name: 'Top Quality Restaurant it is really',
//     image: 'https://axwwgrkdco.cloudimg.io/v7/__gmpics__/048f71dc300347bf9bae7e3b388ee685?width=500&sharp=1',
//     description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
//     workingHours: '08 00-22 00',
//     location: 'nowhere'
//   )
// ];

class BottomSheetSwitch extends StatefulWidget {
  BottomSheetSwitch({required this.switchValue, required this.valueChanged});

  final bool switchValue;
  final ValueChanged valueChanged;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<BottomSheetSwitch> {
  late bool _switchValue;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoSwitch(
          activeColor: Theme.of(context).colorScheme.primary,
          value: _switchValue,
          onChanged: (bool value) {
            setState(() {
              _switchValue = value;
              widget.valueChanged(value);
            });
          }),
    );
  }
}
