import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/shared_functions/mark_fulfilled.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/cuisines/cuisines.dart';
import 'package:nottacafe/src/screens/order/order_details.dart';
import 'package:nottacafe/src/screens/restaurant/restaurant.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomepageCardVendor extends StatefulWidget {
  final String orderID;
  final String foodID;
  final String foodName;
  final int quantity;
  final String deliveryTime;
  final String image;
  final String address;
  final int category;
  final int index;
  final String relevantID;
  final String cName;
  final String cPhone;

  const HomepageCardVendor(
      {Key? key,
      this.foodID = 'Default Title',
      this.foodName = 'Default Description',
      this.quantity = 0,
      this.deliveryTime = '09 00',
      this.address = 'nowhere',
      required this.image,
      required this.category,
      this.index = 0,
      this.relevantID = '',
      this.cName = 'anonymous',
      this.cPhone = '000',
      this.orderID = 'xxx'})
      : super(key: key);

  @override
  State<HomepageCardVendor> createState() => _HomepageCardVendorState();
}

class _HomepageCardVendorState extends State<HomepageCardVendor> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
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
        onTap: () {
          if (widget.category == 0) {
            justPush(
                context,
                OrderDetails(
                  orderID: widget.orderID,
                  foodID: widget.foodID,
                  foodName: widget.foodName,
                  quantity: widget.quantity,
                  deliveryTime: widget.deliveryTime,
                  address: widget.address,
                  cName: widget.cName,
                  cPhone: widget.cPhone,
                ));
          } else {}
        },
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 30) * 0.65,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    widget.foodName.length > 18
                                        ? widget.quantity.toString() +
                                            " " +
                                            widget.foodName.substring(0, 17) +
                                            "..."
                                        : widget.quantity == 0
                                            ? "Deleted Item"
                                            : widget.quantity.toString() +
                                                " " +
                                                widget.foodName,
                                    // widget.title,
                                    // overflow: TextOverflow.ellipsis,
                                    style: isDark
                                        ? AppTextStyles.secondaryHeadingWhite
                                        : AppTextStyles.secondaryHeadingBlack),
                                Container(
                                  child: widget.category == 1
                                      ? Container()
                                      : Text(
                                          // widget.description.length > 85 ? widget.description.substring(0, 84) + '...' : widget.description,
                                          widget.deliveryTime,
                                          style: AppTextStyles.descriptionGrey),
                                ),
                                Container(
                                  child: widget.category == 0
                                      ? RichText(
                                          text: TextSpan(
                                              text: 'MARK AS FULFILLED',
                                              style: AppTextStyles.moreButton,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  markAsFulfilled(
                                                      widget.orderID,
                                                      widget.foodID,
                                                      widget.quantity);
                                                }))
                                      : Container(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                  child: Image.network(
                    widget.image,
                    height: 150,
                    fit: BoxFit.cover,
                    width: (MediaQuery.of(context).size.width - 30) * 0.35,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
