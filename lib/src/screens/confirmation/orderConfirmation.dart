import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class OrderConfirmation extends StatelessWidget {
  const OrderConfirmation({super.key});
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var isDark = themeChange.darkTheme;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
        Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(
                    Icons.check,
                    color: AppColors.white,
                    size: MediaQuery.of(context).size.width / 2.25,
                  ),
                  radius: MediaQuery.of(context).size.width / 4,
                ),
                SizedBox(height: 20,),
                Text(
                  "Your order has been received by the restaurant. You will receive a call to pick it up.",
                  style: isDark
                      ? AppTextStyles.descriptionWhite
                      : AppTextStyles.descriptionBlack,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)))),
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Back to homepage",
                    style: AppTextStyles.buttonTextWhite,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              //buttonColor: Theme.of(context).colorScheme.primary,
              //buttonTextStyle: AppTextStyles.buttonTextWhite,

              onPressed: () async {
                Navigator.pop(context);
              }),
        ),
          ],
        ));
  }
}
