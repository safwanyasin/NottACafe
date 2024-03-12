import 'package:flutter/material.dart';
import 'package:nottacafe/src/screens/auth/login_register/login_register.dart';
import 'package:nottacafe/styles/assets.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';

class WalkThrough extends StatefulWidget {
  
  const WalkThrough({
    Key? key
  }) : super(key: key);

  static const routeName = "/walkThrough";

  @override
  State<WalkThrough> createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {

  late int _pageNumber;

  @override
  void initState() {
    
    super.initState();
    _pageNumber = 0;
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: PageView(
          scrollDirection: Axis.vertical,
          children: [
            _page(
              Theme.of(context).colorScheme.onPrimaryContainer, 
              "NottACafe", 
              "Say hello to ease, say goodbye to long queues and conventionality", 
              "Skip", 
              Theme.of(context).colorScheme.secondaryContainer, 
              Image.asset(
                AppAssets.nottinghamLogo,
                fit: BoxFit.cover,
              ),
              AppTextStyles.buttonTextBlue,
            ),
            _page(
              Theme.of(context).colorScheme.onPrimary, 
              "Order Now, For Later", 
              "Plan your meals according to your schedule, and help us help you", 
              "Done", 
              Theme.of(context).colorScheme.onPrimaryContainer, 
              Image.asset(
                AppAssets.orderFoodIcon,
                fit: BoxFit.contain,
                color: Theme.of(context).colorScheme.primary,
              ),
              AppTextStyles.buttonTextWhite,
            ),
          ],
          onPageChanged: (pageNumber) {
            setState(() {
              _pageNumber = pageNumber;
            });
          },
        )
      ),
    );
  }

  Widget _page (Color backgroundColor, String title, String description, String buttonText, Color buttonColor, Image banner, TextStyle buttonTextStyle) {
    
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: banner,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                title,
                style: AppTextStyles.primaryHeadingWhite,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                description,
                style: AppTextStyles.desriptionWhite,
                textAlign: TextAlign.start,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedButton(
                  buttonText: buttonText,
                  buttonColor: buttonColor,
                  buttonTextStyle: buttonTextStyle,
                  onTap: () {
                    Navigator.restorablePopAndPushNamed(context, LoginRegister.routeName);
                  },
                  
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8.0,
                      height: _pageNumber == 0 ? 16.0 : 8.0,
                      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: _pageNumber == 0 ? BoxShape.rectangle : BoxShape.circle,
                        borderRadius: _pageNumber == 0 ? BorderRadius.circular(8.0) : null,
                        color: _pageNumber == 0 ?
                          Theme.of(context).colorScheme.secondaryContainer :
                          Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Container(
                      width: 8.0,
                      height:_pageNumber == 1 ? 16.0 : 8.0,
                      margin: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: _pageNumber == 1 ? BoxShape.rectangle : BoxShape.circle,
                        borderRadius: _pageNumber == 1 ? BorderRadius.circular(8.0) : null,
                        color: _pageNumber == 1 ?
                          Theme.of(context).colorScheme.secondaryContainer :
                          Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ]
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}