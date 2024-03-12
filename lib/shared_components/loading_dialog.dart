import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nottacafe/src/app.dart';
import 'package:provider/provider.dart';

Future<void> loadingAlert(BuildContext context) {
  bool isiOS = Platform.isIOS;
  return showDialog(
      // barrierColor: isDark ? AppColors.darkGrey : AppColors.white,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (isiOS) {
          return CupertinoAlertDialog(
            content: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.height * 0.15,
                child: Center(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 0.1,
                        child: CircularProgressIndicator()))),
          );
        } else {
          return AlertDialog(
              content: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.height * 0.15,
                  child: Center(
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.height * 0.1,
                          child: CircularProgressIndicator()))),
              // backgroundColor: isDark
              //     ? Color.fromRGBO(0, 0, 0, 0.5)
              //     : Color.fromRGBO(255, 255, 255, 0.5),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))));
        }
      });
}
