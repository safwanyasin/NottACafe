import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/cuisines/cuisines.dart';
import 'package:nottacafe/src/screens/food/food.dart';
import 'package:nottacafe/src/screens/food/food_vendor.dart';
import 'package:nottacafe/src/screens/restaurant/restaurant.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorDishesCard extends StatefulWidget {
  final String foodID;
  final String foodName;
  final String description;
  final String image;
  final int index;
  final num price;
  final String relevantID;
  final int calorieCount;

  const VendorDishesCard(
      {Key? key,
      required this.foodID,
      required this.foodName,
      required this.image,
      required this.description,
      this.index = 0,
      this.relevantID = '',
      this.price = 0,
      required this.calorieCount})
      : super(key: key);

  @override
  State<VendorDishesCard> createState() => _VendorDishesCardState();
}

class _VendorDishesCardState extends State<VendorDishesCard> {
  static late Route<void> _myRouteBuilder;

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
          justPush(
              context,
              FoodVendor(
                foodID: widget.foodID,
                name: widget.foodName,
                restaurantName: widget.description,
                imageURL: widget.image,
                calorieCount: widget.calorieCount,
                restaurantID: widget.relevantID,
                price: widget.price,
                description: widget.description,
              ));
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
                          height: 110,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    widget.foodName.length > 20
                                        ? widget.foodName.substring(0, 17) +
                                            "..."
                                        : widget.foodName,
                                    // widget.title,
                                    // overflow: TextOverflow.ellipsis,
                                    style: isDark
                                        ? AppTextStyles.secondaryHeadingWhite
                                        : AppTextStyles.secondaryHeadingBlack),
                                Container(
                                  child: Text(
                                      // widget.description.length > 85 ? widget.description.substring(0, 84) + '...' : widget.description,
                                      widget.price.toString() + " TL",
                                      style: AppTextStyles.descriptionGrey),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            height: 40,
                            child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 10, 25, 15),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: AppColors.white,
                                ))),
                      )
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
