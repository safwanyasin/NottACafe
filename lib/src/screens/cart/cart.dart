import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nottacafe/classes/grandtotal_valuenotifier.dart';
import 'package:nottacafe/main.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:nottacafe/shared_components/loading_dialog.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/shared_functions/show_toast.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/cart/cart_card.dart';
import 'package:nottacafe/src/screens/confirmation/orderConfirmation.dart';
import 'package:nottacafe/src/screens/restaurant/restaurant.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  static const routeName = '/cart';
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late MyFirebaseAuth _myFirebaseAuth;
  late Future cartData;
  num initialTotal = 0;
  late GrandTotalProvider grandTotal;
  num cartTotal = 0;
  bool checkOutSucessful = false;
  //late Future totalAmount;
  //late num grandTotal = calculateTotalAmount();
  @override
  void initState() {
    grandTotal = Provider.of<GrandTotalProvider>(context, listen: false);
    super.initState();
    _myFirebaseAuth = MyFirebaseAuth();
    cartData = getCartData();

    //totalAmount = calculateTotalAmount();
  }

  @override
  void didChangeDependencies() {
    grandTotal = Provider.of<GrandTotalProvider>(context, listen: true);
    super.didChangeDependencies();
  }

  List<CartItem> _cartItems = [
    // CartItem(itemID: '45lJqywRe7b4Nribw9N0', quantity: 2),
    // CartItem(itemID: 'oB8mKu4xq3EmvYTdhIJo', quantity: 1),
    // CartItem(itemID: 'zuPPLDTvwZg9RvM40xBB', quantity: 4),
    // CartItem(itemID: '45lJqywRe7b4Nribw9N0', quantity: 2),
    // CartItem(itemID: 'oB8mKu4xq3EmvYTdhIJo', quantity: 1),
    // CartItem(itemID: 'zuPPLDTvwZg9RvM40xBB', quantity: 4)
  ];

  calculateTotalAmount() {
    num total = 0;
    for (int i = 0; i < _cartItems.length; i++) {
      total += _cartItems[i].quantity * _cartItems[i].price;
    }
    return total;
  }

  Future checkout() async {
    loadingAlert(context);
    bool differentRestaurant = false;
    bool timePassed = false;
    int counter = 1;
    DateTime time = DateTime.now();
    String restaurantID = _cartItems[0].restaurantID;
    if (_cartItems[0].deliveryType != "Instant") {
      if (int.parse(_cartItems[0].deliveryHour) < time.hour ||
          (int.parse(_cartItems[0].deliveryHour) == time.hour &&
              int.parse(_cartItems[0].deliveryMin) < time.minute - 2)) {
        timePassed = true;
      }
    }
    while (differentRestaurant == false &&
        counter < _cartItems.length - 1 &&
        timePassed == false) {
      if (restaurantID != _cartItems[counter].restaurantID) {
        differentRestaurant = true;
      }
      if (_cartItems[counter].deliveryType != "Instant") {
        if (int.parse(_cartItems[counter].deliveryHour) < time.hour ||
            (int.parse(_cartItems[counter].deliveryHour) == time.hour &&
                int.parse(_cartItems[counter].deliveryMin) < time.minute - 2)) {
          timePassed = true;
        }
      }
      counter += 1;
    }
    if (differentRestaurant == false && timePassed == false) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_myFirebaseAuth.getCurrentUser!.uid)
          .get();
      QuerySnapshot userCartItems = await FirebaseFirestore.instance
          .collection('users')
          .doc(_myFirebaseAuth.getCurrentUser!.uid)
          .collection('cart')
          .get();
      for (int i = 0; i < _cartItems.length; i++) {
        final data = {
          'foodID': _cartItems[i].foodID,
          'quantity': userCartItems.docs[i]['quantity'],
          'deliveryTime': _cartItems[i].deliveryType != "Instant"
              ? _cartItems[i].deliveryHour + ":" + _cartItems[i].deliveryMin
              : "Instant",
          'address': userData['address'],
          'cName': userData['name'],
          'cPhone': userData['phone']
        };
        String timestampID = '';
        DateTime time = DateTime.now();
        if (_cartItems[i].deliveryType != "Instant") {
          //if (time.hour > _cartItems.)
          time = DateTime(
              time.year,
              time.month,
              time.day,
              int.parse(_cartItems[i].deliveryHour),
              int.parse(_cartItems[i].deliveryMin));
        }
        await FirebaseFirestore.instance
            .collection('restaurants')
            .doc(_cartItems[i].restaurantID)
            .collection('pendingOrders')
            .doc(_cartItems[i].deliveryType == "Instant"
                ? DateTime.now().millisecondsSinceEpoch.toString()
                : time.millisecondsSinceEpoch.toString())
            .set(data);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_myFirebaseAuth.getCurrentUser!.uid)
            .collection('cart')
            .doc(_cartItems[i].itemID)
            .delete();
      }
      Navigator.pop(context);
      checkOutSucessful = true;
    } else {
      showToast(
          differentRestaurant == true
              ? 'You have items from different restaurants in your cart. To continue, please ensure that items in your cart belong to one restaurant only.'
              : 'One or more of your scheduled orders have a time that already passed or is about to pass',
          Toast.LENGTH_LONG);
      Navigator.pop(context);
    }
  }

  Future getCartData() async {
    //print('heelo');
    // print(_myFirebaseAuth.getCurrentUser);
    // print(_myFirebaseAuth.getCurrentUser!.uid);
    QuerySnapshot userCartItems = await FirebaseFirestore.instance
        .collection('users')
        .doc(_myFirebaseAuth.getCurrentUser!.uid)
        .collection('cart')
        .get();
    // for (int i = 0; i < _cartItems.length; i++) {
    //   DocumentSnapshot documentSnapshotFood = await FirebaseFirestore.instance
    //       .collection('food')
    //       .doc(_cartItems[i].itemID)
    //       .get();
    //   _cartItems[i].image = documentSnapshotFood['image'];
    //   _cartItems[i].name = documentSnapshotFood['name'];
    //   _cartItems[i].price = documentSnapshotFood['price'];
    //   //grandTotal += _cartItems[i].quantity * _cartItems[i].price;
    // }
    print(userCartItems.docs.length);
    for (int i = 0; i < userCartItems.docs.length; i++) {
      DocumentSnapshot documentSnapshotFood = await FirebaseFirestore.instance
          .collection('food')
          .doc(userCartItems.docs[i]['foodID'])
          .get();
      _cartItems.add(CartItem(
          itemID: userCartItems.docs[i].id,
          foodID: documentSnapshotFood.id,
          name: documentSnapshotFood['name'],
          price: documentSnapshotFood['price'],
          quantity: userCartItems.docs[i]['quantity'],
          image: documentSnapshotFood['image'],
          deliveryType: userCartItems.docs[i]['deliveryHour'] == "Instant"
              ? "Instant"
              : "Sceheduled",
          deliveryHour: userCartItems.docs[i]['deliveryHour'],
          deliveryMin: userCartItems.docs[i]['deliveryMin'],
          restaurantID: documentSnapshotFood['restaurantID']));
    }
    initialTotal = calculateTotalAmount();
    grandTotal.grandTotal = calculateTotalAmount();
    //print(initialTotal);
    //grandTotal.grandTotal = initialTotal;
    //cartTotal = grandTotal.grandTotal;
  }

  @override
  Widget build(BuildContext context) {
    final grandTotal = Provider.of<GrandTotalProvider>(context);
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var isDark = themeChange.darkTheme;

    return Scaffold(
        backgroundColor: isDark ? AppColors.lightGrey : AppColors.white,
        appBar: AppBar(
          title: const Text(
            'Cart',
            style: AppTextStyles.secondaryHeadingWhite,
          ),
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(20))),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: FutureBuilder(
                    future: cartData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        grandTotal.grandTotal = initialTotal;
                        cartTotal = grandTotal.grandTotal;
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: _cartItems.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Container(height: 10);
                            } else if (index <= _cartItems.length) {
                              final item = _cartItems[index - 1];
                              return Dismissible(
                                  key: Key(item.itemID),
                                  onDismissed: (direction) {
                                    setState(() async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(_myFirebaseAuth
                                              .getCurrentUser!.uid)
                                          .collection('cart')
                                          .doc(item.itemID)
                                          .delete();
                                      _cartItems.removeAt(index - 1);
                                    });
                                  },
                                  child: CartCard(
                                      itemID: _cartItems[index - 1].itemID,
                                      name: _cartItems[index - 1].name,
                                      index: index - 1,
                                      image: _cartItems[index - 1].image,
                                      quantity: _cartItems[index - 1].quantity,
                                      price: _cartItems[index - 1].price,
                                      deliveryType:
                                          _cartItems[index - 1].deliveryType,
                                      deliveryHour:
                                          _cartItems[index - 1].deliveryHour,
                                      deliveryMin:
                                          _cartItems[index - 1].deliveryMin));
                            } else {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1);
                            }
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                            height: MediaQuery.of(context).size.height,
                            child: const Center(
                                child: Center(
                                    child: Text(
                                        'The app encountered some error :('))));
                      } else {
                        return Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                                child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator())));
                      }
                    })),
          ],
        ),
        bottomSheet: Container(
            // height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            //color: Theme.of(context).colorScheme.primaryContainer
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0.2,
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 25,
                      offset: Offset(0, 10))
                ]),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Amount: ',
                              style: isDark
                                  ? AppTextStyles.descriptionWhite
                                  : AppTextStyles.descriptionBlack),
                          FutureBuilder(
                              future: cartData,
                              builder: (context, snapshot) {
                                return Text(cartTotal.toString(),
                                    style: AppTextStyles.buttonTextBlue);
                              })
                        ],
                      ),
                    ),
                    TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        topLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)))),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Checkout",
                              style: AppTextStyles.buttonTextWhite,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        //buttonColor: Theme.of(context).colorScheme.primary,
                        //buttonTextStyle: AppTextStyles.buttonTextWhite,

                        onPressed: () async {
                          await checkout();
                          if (checkOutSucessful == true) {
                            Navigator.pop(context);
                            justPush(context, OrderConfirmation());
                          }
                          //print(grandTotal.grandTotal);
                        }),
                  ]),
            )));
  }
}

class CartItem {
  final String foodID;
  final String itemID;
  String name;
  String image;
  int quantity;
  num price;
  final String deliveryType;
  final String deliveryHour;
  final String deliveryMin;
  final String restaurantID;

  CartItem(
      {required this.itemID,
      required this.foodID,
      this.name = 'default',
      this.image = 'none',
      this.price = 0,
      required this.quantity,
      required this.deliveryType,
      required this.deliveryHour,
      required this.deliveryMin,
      required this.restaurantID});
}
