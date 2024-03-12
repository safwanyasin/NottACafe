import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/classes/food_items.dart';
import 'package:nottacafe/main.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/shared_components/rounded_picture_container.dart';
import 'package:nottacafe/shared_components/rounded_rectangle.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/food/food.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class Restaurant extends StatefulWidget {
  final String name;
  final String imageURL;
  final String description;
  final String operatingHours;
  final String location;
  final String restaurantID;

  const Restaurant({
    Key? key,
    this.name = "",
    this.description = "Default description",
    this.imageURL = "",
    this.operatingHours = "09 00-22 00",
    this.location = "nowhere",
    this.restaurantID = '',
  }) : super(key: key);

  static const String routeName = '/food';

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  late Future relevantFood;

  @override
  void initState() {
    relevantFood = getRelevantFood();
  }

  List<FoodItem> _foodItems = [];

  Future getRelevantFood() async {
    QuerySnapshot querySnapshotRFood =
        await FirebaseFirestore.instance.collection('food').get();
    for (int i = 0; i < querySnapshotRFood.docs.length; i++) {
      if (querySnapshotRFood.docs[i]['restaurantID'] == widget.restaurantID) {
        DocumentSnapshot documentSnapshotCuisine = await FirebaseFirestore
            .instance
            .collection('cuisines')
            .doc(querySnapshotRFood.docs[i]['cuisineID'])
            .get();
        _foodItems.add(FoodItem(
            foodID: querySnapshotRFood.docs[i].id,
            name: querySnapshotRFood.docs[i]['name'],
            restaurantID: querySnapshotRFood.docs[i]['restaurantID'],
            restaurantName: widget.name,
            calorieCount: querySnapshotRFood.docs[i]['calorieCount'],
            cuisineID: querySnapshotRFood.docs[i]['cuisineID'],
            cuisineName: documentSnapshotCuisine['name'],
            image: querySnapshotRFood.docs[i]['image'],
            price: querySnapshotRFood.docs[i]['price'],
            description: querySnapshotRFood.docs[i]['description']));
        //print(querySnapshotRFood.docs[i].id);
      }
    }
    print(_foodItems.length);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDark = themeChange.darkTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? AppColors.lightGrey : AppColors.white,
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
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 50),
              child: Card(
                margin: EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(55),
                )),
                elevation: 10,
                shadowColor: Theme.of(context).colorScheme.shadow,
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(55)),
                      child: Image.network(
                        widget.imageURL,
                        height: MediaQuery.of(context).size.height / (10 / 3),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 60),
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 60),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 9,
                          child: Column(
                            children: [
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: Text(
                                    widget.name,
                                    style: isDark
                                        ? AppTextStyles.foodNameDark
                                        : AppTextStyles.foodName,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: widget.description.length <= 25
                                      ? Text(widget.description,
                                          style: AppTextStyles.descriptionGrey,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis)
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.description
                                                      .substring(0, 25) +
                                                  '...',
                                              style:
                                                  AppTextStyles.descriptionGrey,
                                            ),
                                            RichText(
                                                text: TextSpan(
                                                    text: 'more',
                                                    style: AppTextStyles
                                                        .moreButton,
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            showModalBottomSheet<
                                                                    void>(
                                                                      isScrollControlled: true,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return (Wrap(
                                                                    children: [
                                                                      Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Theme.of(context).colorScheme.primaryContainer,
                                                                            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                                padding: const EdgeInsets.only(top: 8),
                                                                                child: RoundedRectangle()),
                                                                            Padding(
                                                                              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 40, horizontal: 20),
                                                                              child: Column(children: [
                                                                                Text(
                                                                                  widget.name,
                                                                                  style: isDark ? AppTextStyles.foodNameDark : AppTextStyles.foodName,
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                                Text(widget.description, style: AppTextStyles.descriptionGrey)
                                                                              ]),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ));
                                                                });
                                                          }))
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.height / (10 / 3)) - 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 15),
                    child: SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Card(
                        color: isDark ? AppColors.lightGrey : AppColors.white,
                        margin: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: AppColors.neutralOne,
                              size: 25,
                            ),
                            Text(widget.operatingHours,
                                style: AppTextStyles.descriptionGrey)
                          ],
                        )),
                        // color: Colors.white,
                        elevation: 5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
          SizedBox(
            height: MediaQuery.of(context).size.height / (25 / 13) - 2,
            child: FutureBuilder(
                future: relevantFood,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _foodItems.length,
                        padding: EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          print("index is " + index.toString());
                          return Row(
                            children: [
                              if ((2 * (index)) < _foodItems.length)
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: RoundedPictureContainer(
                                      foodID: _foodItems[2 * (index)].foodID,
                                      image: _foodItems[2 * (index)].image,
                                      title: _foodItems[2 * (index)].name,
                                      description: _foodItems[2 * (index)]
                                          .restaurantName,
                                      calorieCount:
                                          _foodItems[2 * (index)].calorieCount,
                                      restaurantID:
                                          _foodItems[2 * (index)].restaurantID,
                                      price: _foodItems[2 * (index)].price,
                                      foodDescription:
                                          _foodItems[2 * (index)].description),
                                ),
                              if ((2 * (index) + 1) < _foodItems.length)
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: RoundedPictureContainer(
                                      foodID: _foodItems[2 * (index) + 1].foodID,
                                      image: _foodItems[2 * (index) + 1].image,
                                      title: _foodItems[2 * (index) + 1].name,
                                      description: _foodItems[2 * (index) + 1]
                                          .restaurantName,
                                      calorieCount: _foodItems[2 * (index) + 1]
                                          .calorieCount,
                                      restaurantID: _foodItems[2 * (index) + 1]
                                          .restaurantID,
                                      price: _foodItems[2 * (index) + 1].price,
                                      foodDescription:
                                          _foodItems[2 * (index) + 1]
                                              .description),
                                ),
                            ],
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                            child: Text('The app encountered some error :(')));
                  } else {
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator()),
                        ));
                  }
                }),
          )
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
