import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:nottacafe/shared_components/alert_dialog.dart';
import 'package:nottacafe/shared_components/loading_dialog.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/shared_functions/show_toast.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/food/edit_food.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class FoodVendor extends StatefulWidget {
  final String foodID;
  final String name;
  final String description;
  final String imageURL;
  final String restaurantName;
  final int calorieCount;
  final num price;
  final String restaurantID;

  const FoodVendor({
    Key? key,
    required this.foodID,
    this.name = "",
    this.description = "Default description",
    this.imageURL = "",
    this.restaurantName = "",
    this.calorieCount = 0,
    this.price = 0,
    this.restaurantID = '',
  }) : super(key: key);

  static const String routeName = '/foodvendor';

  @override
  State<FoodVendor> createState() => _FoodVendorState();
}

class _FoodVendorState extends State<FoodVendor> {
  int quantity = 1;
  late MyFirebaseAuth _myFirebaseAuth;

  Future deleteFood() async {
    loadingAlert(context);
    QuerySnapshot pendingOrders = await FirebaseFirestore.instance
        .collection('restaurants')
        .doc(_myFirebaseAuth.getCurrentUser!.uid)
        .collection('pendingOrders')
        .get();
    bool found = false;
    int counter = 0;
    while (found == false && counter < pendingOrders.docs.length) {
      bool exists =
          await pendingOrders.docs[counter]['foodID'] == widget.foodID;
      if (exists == true) found = true;
      counter += 1;
    }
    if (found == false) {
      await FirebaseFirestore.instance
          .collection('food')
          .doc(widget.foodID)
          .delete();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      final imageRef = referenceRoot
          .child('${_myFirebaseAuth.getCurrentUser!.email}/${widget.foodID}');
      await imageRef.delete();
      Navigator.pop(context);
      Navigator.pop(context);
      showToast(
          "The dish has been deleted successfully! Refresh the page to view changes",
          Toast.LENGTH_SHORT);
    } else {
      Navigator.pop(context);
      showToast(
          'A pending order of this dish already exists. Please fulfill it before deleting this dish.',
          Toast.LENGTH_SHORT);
    }
  }

  Future<void> deleteFoodConfirmation(
      Widget title, Widget message, bool isDark) async {
    bool isiOS = Platform.isIOS;
    return showDialog(
        // barrierColor: isDark ? AppColors.darkGrey : AppColors.white,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if (isiOS) {
            return CupertinoAlertDialog(
              title: title,
              content: message,
              actions: [
                RoundedButton(
                  buttonText: 'Delete',
                  buttonColor: Theme.of(context).colorScheme.primary,
                  buttonTextStyle: AppTextStyles.buttonTextWhite,
                  onTap: () {
                    //Navigator.pop(context);
                    Navigator.pop(context);
                    deleteFood();
                  },
                ),
                RoundedButton(
                  buttonText: 'Cancel',
                  buttonColor: Theme.of(context).colorScheme.primaryContainer,
                  buttonTextStyle: AppTextStyles.buttonTextWhite,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: title,
              content: message,
              backgroundColor: isDark ? AppColors.lightGrey : AppColors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              actions: [
                RoundedButton(
                  buttonText: 'Delete',
                  buttonColor: Theme.of(context).colorScheme.primary,
                  buttonTextStyle: AppTextStyles.buttonTextWhite,
                  onTap: () {
                    deleteFood();
                    Navigator.pop(context);
                  },
                ),
                RoundedButton(
                  buttonText: 'Cancel',
                  buttonColor: Theme.of(context).colorScheme.primaryContainer,
                  buttonTextStyle: isDark
                      ? AppTextStyles.buttonTextWhite
                      : AppTextStyles.buttonTextBlue,
                  onTap: () {
                    //setState(() {});
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
        });
  }

  @override
  void initState() {
    super.initState();
    _myFirebaseAuth = MyFirebaseAuth();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var isDark = themeChange.darkTheme;

    return Scaffold(
      backgroundColor: isDark ? AppColors.lightGrey : AppColors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: const Text(
        //   'Order Now',
        //   style: AppTextStyles.secondaryHeadingWhite,
        // ),
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        elevation: 0,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomRight: Radius.circular(20)
        //   )
        // ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.25,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.network(
                      widget.imageURL,
                      // height: MediaQuery.of(context).size.height / 2.5,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 1.25),
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7)),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(0),
                  color: isDark ? AppColors.lightGrey : AppColors.white,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(55)),
                    child: Image.network(
                      widget.imageURL,
                      height: MediaQuery.of(context).size.height / 2.5,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(55),
                  )),
                  elevation: 0,
                  shadowColor: Theme.of(context).colorScheme.shadow,
                  color: isDark ? AppColors.lightGrey : AppColors.white,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2.1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height /
                                        40),
                                child: Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    child: Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          widget.name,
                                          style: isDark
                                              ? AppTextStyles.foodNameDark
                                              : AppTextStyles.foodName,
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          '${widget.calorieCount.toString()} kcal',
                                          style: AppTextStyles.descriptionBlue,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height /
                                        40),
                                child: Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    child: Text(
                                      widget.description,
                                      style: AppTextStyles.descriptionGrey,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.price.toString(),
                        style: AppTextStyles.primaryHeadingWhite,
                      ),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: IconButton(
                                    onPressed: () {
                                      justPush(context,
                                          EditFood(foodID: widget.foodID));
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: AppColors.white, size: 30)),
                              ),
                              Text(
                                "|",
                                style: TextStyle(
                                    color: AppColors.blueThree,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: IconButton(
                                    onPressed: () {
                                      deleteFoodConfirmation(
                                          Text(
                                            "Warning",
                                            style: isDark
                                                ? AppTextStyles
                                                    .primaryHeadingWhite
                                                : AppTextStyles
                                                    .primaryHeadingBlack,
                                          ),
                                          Text(
                                            "Are you sure you want to delete this dish? This action is irreversible.",
                                            style: isDark
                                                ? AppTextStyles.descriptionWhite
                                                : AppTextStyles
                                                    .descriptionBlack,
                                          ),
                                          isDark);
                                    },
                                    icon: const Icon(Icons.delete_outline,
                                        color: AppColors.white, size: 30)),
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          ]),
        ],
      ),
      // bottomSheet: Padding(
      //   padding: const EdgeInsets.all(20.0),
      //   child: SizedBox(
      //     height: 80,
      //     child: RoundedButton(
      //       buttonText: 'Place Order',
      //       buttonColor: Theme.of(context).colorScheme.primary,
      //       buttonTextStyle: AppTextStyles.buttonTextWhite,
      //       onTap: () {}
      //     ),
      //   ),
      // ),
    );
  }
}
