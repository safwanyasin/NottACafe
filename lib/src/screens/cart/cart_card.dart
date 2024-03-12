import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/cuisines/cuisines.dart';
import 'package:nottacafe/src/screens/restaurant/restaurant.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartCard extends StatefulWidget {
  final String itemID;
  final String name;
  final String image;
  final int index;
  final num price;
  final String deliveryType;
  final String deliveryHour;
  final String deliveryMin;
  int quantity;

  CartCard(
      {Key? key,
      required this.itemID,
      required this.name,
      required this.image,
      required this.price,
      required this.deliveryType,
      this.index = 0,
      this.quantity = 0,
      required this.deliveryHour,
      required this.deliveryMin})
      : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  static late Route<void> _myRouteBuilder;
  late MyFirebaseAuth _myFirebaseAuth;
  late GrandTotalProvider grandTotal;

  @override
  void initState() {
    grandTotal = Provider.of<GrandTotalProvider>(context, listen: false);
    // TODO: implement initState
    super.initState();
    _myFirebaseAuth = MyFirebaseAuth();
  }

  // @override
  // void didChangeDependencies() {
  //   grandTotal = Provider.of<GrandTotalProvider>(context, listen: true);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    //final grandTotal = Provider.of<GrandTotalProvider>(context, listen: false);
    var isDark = themeChange.darkTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: widget.index % 2 == 0
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.secondary,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Image.network(
                    widget.image,
                    height: 150,
                    fit: BoxFit.cover,
                    width: (MediaQuery.of(context).size.width - 30) * 0.35,
                  ),
                ),
                Container(
                  width: (MediaQuery.of(context).size.width - 30) * 0.65,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          //height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    widget.name.length > 20
                                        ? widget.name.substring(0, 17) + "..."
                                        : widget.name,
                                    // widget.title,
                                    // overflow: TextOverflow.ellipsis,
                                    style: isDark
                                        ? AppTextStyles.secondaryHeadingWhite
                                        : AppTextStyles.secondaryHeadingBlack),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(widget.price.toString() + ' TL',
                                style: isDark
                                    ? AppTextStyles.descriptionWhite
                                    : AppTextStyles.descriptionBlack),
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
                                    if (widget.quantity > 1) {
                                      widget.quantity -= 1;
                                      final data = {
                                        'quantity': widget.quantity
                                      };
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(_myFirebaseAuth
                                              .getCurrentUser!.uid)
                                          .collection('cart')
                                          .doc(widget.itemID)
                                          .set(data, SetOptions(merge: true));
                                      //grandTotal.grandTotal += widget.price;
                                    }
                                  });
                                },
                              ),
                              Text(widget.quantity.toString(),
                                  style: isDark
                                      ? AppTextStyles.descriptionWhite
                                      : AppTextStyles.descriptionBlack),
                              IconButton(
                                icon: Icon(Icons.add),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                onPressed: () {
                                  setState(() {
                                    widget.quantity += 1;
                                    final data = {'quantity': widget.quantity};
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(
                                            _myFirebaseAuth.getCurrentUser!.uid)
                                        .collection('cart')
                                        .doc(widget.itemID)
                                        .set(data, SetOptions(merge: true));
                                    //grandTotal.grandTotal += widget.price;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 15,
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(widget.deliveryType,
                                style: AppTextStyles.descriptionGrey),
                          ),
                        ],
                      )
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: SizedBox(
                      //     height: 40,
                      //     child: Container(
                      //       padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
                      //       decoration: BoxDecoration(
                      //       color: Theme.of(context).colorScheme.primary,
                      //       borderRadius: const BorderRadius.only(
                      //         bottomLeft: Radius.circular(20),
                      //         topRight: Radius.circular(20)
                      //       )
                      //     ),
                      //       child: Icon(
                      //         Icons.arrow_forward_ios_outlined,
                      //         color: AppColors.white,
                      //       )
                      //     )
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
