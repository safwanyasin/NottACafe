import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/shared_components/rounded_button.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:nottacafe/styles/colors.dart';

Future mediaSourceDialog(BuildContext context) {
  bool isiOS = Platform.isIOS;
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      if (isiOS) {
        return CupertinoAlertDialog(
          title: Text('Select Source'),
          content: Container(
            height: 80,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context, true),
                    child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 35),
                          const Text("Take photo",
                              style: AppTextStyles.descriptionBlue),
                        ]),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context, false),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            color: Theme.of(context).colorScheme.primary,
                            Icons.image_outlined,
                            size: 35),
                        const Text("Choose from gallery",
                            style: AppTextStyles.descriptionBlue),
                        const Text("gallery",
                            style: AppTextStyles.descriptionBlue),
                      ],
                    ),
                  )
                ]),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: AppTextStyles.descriptionBlue),
              //buttonColor: Theme.of(context).colorScheme.primary,
              //buttonTextStyle: AppTextStyles.buttonTextWhite,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      } else {
        return AlertDialog(
          title: Text('Select source'),
          content: Container(
            height: 80,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context, true),
                    child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: 35),
                          const Text("Take photo",
                              style: AppTextStyles.descriptionBlue),
                        ]),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context, false),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            color: Theme.of(context).colorScheme.primary,
                            Icons.image_outlined,
                            size: 35),
                        const Text("Choose from",
                            style: AppTextStyles.descriptionBlue),
                        const Text("gallery",
                            style: AppTextStyles.descriptionBlue)
                      ],
                    ),
                  )
                ]),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          actions: [
            TextButton(
              child: Text('Cancel', style: AppTextStyles.descriptionBlue),
              //buttonColor: Theme.of(context).colorScheme.primary,
              //buttonTextStyle: AppTextStyles.buttonTextWhite,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    },
  );
}
