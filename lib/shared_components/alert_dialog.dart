import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:nottacafe/styles/colors.dart';

Future<void> showAlert(BuildContext context, String content, bool isDark) {
  bool isiOS = Platform.isIOS;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      if (isiOS) {
       return CupertinoAlertDialog(
            title: Text('Error'),
            content: Text(content),
            actions: [
              RoundedButton(
                buttonText: 'OK',
                buttonColor: Theme.of(context).colorScheme.primary,
                buttonTextStyle: AppTextStyles.buttonTextWhite,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
      }
      else {
        return AlertDialog(
            title: Text('Error'),
            content: Text(content),
            backgroundColor: isDark ? AppColors.lightGrey : AppColors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            actions: [
              RoundedButton(
                buttonText: 'OK',
                buttonColor: Theme.of(context).colorScheme.primary,
                buttonTextStyle: AppTextStyles.buttonTextWhite,
                onTap: () {
                  Navigator.pop(context);
                },
                
              ),
            ],
          );
      }
    }, 
  );
}