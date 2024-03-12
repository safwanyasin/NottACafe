import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:nottacafe/shared_components/alert_dialog.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/shared_functions/show_toast.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class Food extends StatefulWidget {
  final String foodID;
  final String name;
  final String description;
  final String imageURL;
  final String restaurantName;
  final int calorieCount;
  final num price;
  final String restaurantID;

  const Food({
    Key? key,
    this.foodID = "",
    this.name = "",
    this.description = "Default description",
    this.imageURL = "",
    this.restaurantName = "",
    this.calorieCount = 0,
    this.price = 0,
    this.restaurantID = '',
  }) : super(key: key);

  static const String routeName = '/food';

  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  late int _orderOptionSelected;
  int quantity = 1;
  late MyFirebaseAuth _myFirebaseAuth;
  TimeOfDay? lateOrderTime;

  Future<void> showTimePopup(
      Widget title, Widget timePicker, bool isDark) async {
    bool isiOS = Platform.isIOS;
    return showDialog(
        // barrierColor: isDark ? AppColors.darkGrey : AppColors.white,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          if (isiOS) {
            return CupertinoAlertDialog(
              title: title,
              content: timePicker,
              actions: [
                RoundedButton(
                  buttonText: 'Confirm',
                  buttonColor: Theme.of(context).colorScheme.primary,
                  buttonTextStyle: AppTextStyles.buttonTextWhite,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                RoundedButton(
                  buttonText: 'Cancel',
                  buttonColor: Theme.of(context).colorScheme.primaryContainer,
                  buttonTextStyle: AppTextStyles.buttonTextWhite,
                  onTap: () {
                    _orderOptionSelected = 0;
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: title,
              content: timePicker,
              backgroundColor: isDark ? AppColors.lightGrey : AppColors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              actions: [
                RoundedButton(
                  buttonText: 'Confirm',
                  buttonColor: Theme.of(context).colorScheme.primary,
                  buttonTextStyle: AppTextStyles.buttonTextWhite,
                  onTap: () {
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
                    setState(() {
                      _orderOptionSelected = 0;
                    });
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
    _orderOptionSelected = 0;
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RoundedButton(
                                    buttonText: 'For Now',
                                    buttonColor: _orderOptionSelected == 0
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                    buttonTextStyle: _orderOptionSelected == 0
                                        ? AppTextStyles.buttonTextWhite
                                        : isDark
                                            ? AppTextStyles.buttonTextWhite
                                            : AppTextStyles.buttonTextBlue,
                                    onTap: () {
                                      setState(() {
                                        _orderOptionSelected = 0;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: RoundedButton(
                                    buttonText: 'For Later',
                                    buttonColor: _orderOptionSelected == 1
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                    buttonTextStyle: _orderOptionSelected == 1
                                        ? AppTextStyles.buttonTextWhite
                                        : isDark
                                            ? AppTextStyles.buttonTextWhite
                                            : AppTextStyles.buttonTextBlue,
                                    onTap: () async {
                                      setState(() {
                                        _orderOptionSelected = 1;
                                      });
                                      // showTimePopup(
                                      //   Text(
                                      //     'Choose the time',
                                      //     style: isDark ? AppTextStyles.secondaryHeadingWhite : AppTextStyles.secondaryHeadingBlack,

                                      //   ),
                                      //   TimePickerDialog(initialTime: TimeOfDay.now()),
                                      //   isDark
                                      // );
                                      lateOrderTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );

                                      if ((lateOrderTime != null &&
                                              lateOrderTime!.hour <
                                                  TimeOfDay.now().hour) ||
                                          (lateOrderTime != null &&
                                              lateOrderTime!.hour <=
                                                  TimeOfDay.now().hour &&
                                              lateOrderTime!.minute <
                                                  TimeOfDay.now().minute)) {
                                        showAlert(
                                            context,
                                            'You cannot select a past date!',
                                            isDark);
                                        lateOrderTime = null;
                                        setState(() {
                                          _orderOptionSelected = 0;
                                        });
                                      } else {}
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) {
                                  quantity -= 1;
                                }
                              });
                            },
                          ),
                          Text(quantity.toString(),
                              style: AppTextStyles.descriptionWhite),
                          IconButton(
                            icon: Icon(Icons.add),
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            onPressed: () {
                              setState(() {
                                quantity += 1;
                              });
                            },
                          ),
                          SizedBox(
                            width: 15,
                          )
                        ],
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
                                "Place Order",
                                style: AppTextStyles.buttonTextWhite,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          //buttonColor: Theme.of(context).colorScheme.primary,
                          //buttonTextStyle: AppTextStyles.buttonTextWhite,

                          onPressed: () async {
                            print(widget.foodID);
                            final data = {
                              'foodID': widget.foodID,
                              'quantity': quantity,
                              'deliveryHour': _orderOptionSelected == 0
                                  ? 'Instant'
                                  : lateOrderTime!.hour.toString(),
                              'deliveryMin': _orderOptionSelected == 0
                                  ? 'Instant'
                                  : lateOrderTime!.minute.toString(),
                              'restaurantID': widget.restaurantID
                            };
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(_myFirebaseAuth.getCurrentUser!.uid)
                                .collection('cart')
                                .doc()
                                .set(data);
                            showToast(
                                "Item add to the cart! Go to the cart to checkout",
                                Toast.LENGTH_SHORT);
                            Navigator.pop(context);
                          }),
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
