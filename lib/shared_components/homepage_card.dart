import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/cuisines/cuisines.dart';
import 'package:nottacafe/src/screens/restaurant/restaurant.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomepageCard extends StatefulWidget {

  final String title;
  final String description;
  final String operatingHours;
  final String image;
  final String location;
  final int category;
  final int index;
  final String relevantID;
  final String redirectLink;

  const HomepageCard({
    Key? key,
    this.title = 'Default Title',
    this.description = 'Default Description',
    this.operatingHours = '09 00-22 00',
    this.location = 'nowhere',
    required this.image,
    required this.category,
    this.index = 0,
    this.relevantID = '',
    this.redirectLink = '#'
  }) : super(key: key);

  @override
  State<HomepageCard> createState() => _HomepageCardState();
}

class _HomepageCardState extends State<HomepageCard> {

  Future<void> _launchURL(String link) async {
    var url = Uri.https(link);
   if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: widget.index % 2 == 0 ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondary,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (widget.category == 0) {
            _launchURL(widget.redirectLink);
          } else {
            justPush(context, Restaurant(
              restaurantID: widget.relevantID,
              name: widget.title,
              imageURL: widget.image,
              description: widget.description,
              operatingHours: widget.operatingHours,
              location: widget.location

            ));
          }
         
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child:  Row(
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
                                widget.title.length > 20 ? widget.title.substring(0, 17) + "..." : widget.title,
                                // widget.title,
                                // overflow: TextOverflow.ellipsis,
                                style: isDark ? AppTextStyles.secondaryHeadingWhite : AppTextStyles.secondaryHeadingBlack
                              ),
                              Container(
                                child: widget.category == 0 ?  Container() : Text(
                                  // widget.description.length > 85 ? widget.description.substring(0, 84) + '...' : widget.description,
                                  widget.operatingHours,
                                  style: AppTextStyles.descriptionGrey
                                ), 
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
                          padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
                          decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20), 
                            topRight: Radius.circular(20)
                          )
                        ),
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: AppColors.white,
                          )
                        )
                      ),
                    )
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), 
                  bottomRight: Radius.circular(20),
                  topLeft: Radius.circular(20)
                ),
                child: Image.network(
                  widget.image,
                  height: 150, 
                  fit: BoxFit.cover,
                  width: (MediaQuery.of(context).size.width - 30) * 0.35,
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}