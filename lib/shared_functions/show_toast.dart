import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, Toast t) => Fluttertoast.showToast(
      toastLength: t,
      msg: message,
      fontSize: 18.0,
    );
