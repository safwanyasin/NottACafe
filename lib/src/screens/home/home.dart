import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:nottacafe/main.dart';
import 'package:nottacafe/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/shared_components/homepage_card.dart';
import 'package:nottacafe/shared_components/rounded_rectangle.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/auth/login_register/login_register.dart';
import 'package:nottacafe/src/screens/cart/cart.dart';
import 'package:nottacafe/src/screens/edit_profile/edit_profile.dart';
import 'package:nottacafe/src/screens/restaurant/restaurant.dart';
import 'package:nottacafe/src/screens/welcome/welcome.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:nottacafe/shared_components/category_card.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routeName = '/home';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MyFirebaseAuth _myFirebaseAuth;
  late int _selectedCategory;
  late DarkThemeProvider themeChange;
  bool theme = false;
  //late Future categoriesData;
  late Future restaurantsData;

  @override
  void initState() {
    themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    super.initState();
    _myFirebaseAuth = MyFirebaseAuth();
    _selectedCategory = 0;
    //categoriesData = getCategories();
    restaurantsData = getRestaurants();
  }

  //List<CuisineItem> _cuisineItems = [];
  List<Restaurants> _restaurantItems = [];
  List<ServicesItem> _services = [
    ServicesItem(
        title: 'Google',
        image:
            'https://companieslogo.com/img/orig/GOOG-0ed88f7c.png?t=1633218227',
        redirectLink: 'www.google.com')
  ];

  Future getRestaurants() async {
    QuerySnapshot querySnapshotRestaurant =
        await FirebaseFirestore.instance.collection('restaurants').get();
    for (int i = 0; i < querySnapshotRestaurant.docs.length; i++) {
      _restaurantItems.add(Restaurants(
          id: querySnapshotRestaurant.docs[i].id,
          name: querySnapshotRestaurant.docs[i]['name'],
          image: querySnapshotRestaurant.docs[i]['image'],
          description: querySnapshotRestaurant.docs[i]['description'],
          workingHours: querySnapshotRestaurant.docs[i]['workingHours'],
          location: querySnapshotRestaurant.docs[i]['location']));
    }
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
            'NottACafe',
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
                                                                    const EditProfile());
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
                future: restaurantsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        //itemCount: _selectedCategory == 0 ? _cuisineItems.length + 2 : _restaurantItems.length + 2,
                        itemCount: _selectedCategory == 0
                            ? _services.length + 2
                            : _restaurantItems.length + 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 30),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width:
                                        (MediaQuery.of(context).size.width / 2),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: CategoryCard(
                                        title: 'Services',
                                        icon: Icons
                                            .miscellaneous_services_outlined,
                                        active: _selectedCategory == 0,
                                        onTap: () {
                                          setState(() {
                                            _selectedCategory = 0;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: CategoryCard(
                                        title: 'Restaurants',
                                        icon: Icons.food_bank_outlined,
                                        active: _selectedCategory == 1,
                                        onTap: () {
                                          setState(() {
                                            _selectedCategory = 1;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
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
                                      ? 'Services'
                                      : 'Restaurants',
                                  style: isDark
                                      ? AppTextStyles.secondaryHeadingWhite
                                      : AppTextStyles.secondaryHeadingBlack,
                                ));
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
                              return HomepageCard(
                                title: _services[index - 2].title,
                                image: _services[index - 2].image,
                                redirectLink: _services[index - 2].redirectLink,
                                category: 0,
                                index: index,
                              );
                            } else {
                              return HomepageCard(
                                title: _restaurantItems[index - 2].name,
                                image: _restaurantItems[index - 2].image,
                                description:
                                    _restaurantItems[index - 2].description,
                                category: 1,
                                index: index,
                                relevantID: _restaurantItems[index - 2].id,
                                operatingHours: _restaurantItems[index - 2].workingHours,

                              );
                            }
                          }
                          return Container();
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
          ])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        onPressed: () {
          justPush(context, Cart());
        },
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final IconData icon;
  final bool active;

  CategoryItem({required this.title, required this.icon, required this.active});
}

class ServicesItem {
  final String title;
  final String image;
  final String redirectLink;

  ServicesItem(
      {required this.title, required this.image, required this.redirectLink});
}

class CuisineItem {
  final String id;
  final String title;
  final String image;

  CuisineItem({
    required this.id,
    required this.title,
    required this.image,
  });
}

class Restaurants {
  final String id;
  final String name;
  final String image;
  final String description;
  final String workingHours;
  final String location;

  Restaurants(
      {required this.id,
      required this.name,
      required this.image,
      required this.description,
      required this.workingHours,
      required this.location});
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
