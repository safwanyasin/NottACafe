import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/classes/food_items.dart';
import 'package:nottacafe/shared_components/rounded_picture_container.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class Cuisines extends StatefulWidget {
  final String cuisineName;
  final String cuisineDescription;
  final String cuisineID;

  const Cuisines({
    Key? key,
    this.cuisineID = '',
    this.cuisineName = "",
    this.cuisineDescription = "",
  }) : super(key: key);

  static const routeName = '/cuisines';

  @override
  State<Cuisines> createState() => _CuisinesState();
}

class _CuisinesState extends State<Cuisines> {
  late Future relevantFood;

  @override
  void initState() {
    relevantFood = getRelevantFood();
  }

  List<FoodItem> _foodItems = [];

  Future getRelevantFood() async {
    QuerySnapshot querySnapshotCFood =
        await FirebaseFirestore.instance.collection('food').get();
    for (int i = 0; i < querySnapshotCFood.docs.length; i++) {
      if (querySnapshotCFood.docs[i]['cuisineID'] == widget.cuisineID) {
        DocumentSnapshot documentSnapshotRestaurant = await FirebaseFirestore
            .instance
            .collection('restaurants')
            .doc(querySnapshotCFood.docs[i]['restaurantID'])
            .get();
        _foodItems.add(FoodItem(
            foodID: querySnapshotCFood.docs[i].id,
            name: querySnapshotCFood.docs[i]['name'],
            restaurantID: querySnapshotCFood.docs[i]['restaurantID'],
            restaurantName: documentSnapshotRestaurant['name'],
            calorieCount: querySnapshotCFood.docs[i]['calorieCount'],
            cuisineID: querySnapshotCFood.docs[i]['cuisineID'],
            cuisineName: widget.cuisineName,
            image: querySnapshotCFood.docs[i]['image'],
            price: querySnapshotCFood.docs[i]['price'],
            description: querySnapshotCFood.docs[i]['description']));
      }
    }
    print(_foodItems.length);
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var isDark = themeChange.darkTheme;
    return Scaffold(
      backgroundColor: isDark ? AppColors.lightGrey : AppColors.white,
      appBar: AppBar(
        title: Text(
          widget.cuisineName,
          style: AppTextStyles.secondaryHeadingWhite,
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder(
              future: relevantFood,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: _foodItems.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 80),
                              child: Text(
                                widget.cuisineDescription,
                                style: AppTextStyles.descriptionGrey,
                              ),
                            ),
                          );
                        }
                        //if (index > 0) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 80),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: RoundedPictureContainer(
                                  foodID: _foodItems[2 * (index - 1)].foodID,
                                  image: _foodItems[2 * (index - 1)].image,
                                  title: _foodItems[2 * (index - 1)].name,
                                  description: _foodItems[2 * (index - 1)]
                                      .restaurantName,
                                  calorieCount:
                                      _foodItems[2 * (index - 1)].calorieCount,
                                  restaurantID:
                                      _foodItems[2 * (index - 1)].restaurantID,
                                  price: _foodItems[2 * (index - 1)].price,
                                  foodDescription:
                                      _foodItems[2 * (index - 1)].description,
                                ),
                              ),
                              if ((2 * (index - 1) + 1) < _foodItems.length)
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: RoundedPictureContainer(
                                    foodID: _foodItems[2 * (index - 1)].foodID,
                                    image:
                                        _foodItems[2 * (index - 1) + 1].image,
                                    title: _foodItems[2 * (index - 1) + 1].name,
                                    description: _foodItems[2 * (index - 1) + 1]
                                        .restaurantName,
                                    calorieCount:
                                        _foodItems[2 * (index - 1) + 1]
                                            .calorieCount,
                                    restaurantID:
                                        _foodItems[2 * (index - 1) + 1]
                                            .restaurantID,
                                    price:
                                        _foodItems[2 * (index - 1) + 1].price,
                                    foodDescription:
                                        _foodItems[2 * (index - 1) + 1]
                                            .description,
                                  ),
                                ),
                            ],
                          ),
                        );
                        //}
                        //return Container();
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
              })),
    );
  }
}
