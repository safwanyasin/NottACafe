import 'package:flutter/material.dart';
import 'package:nottacafe/styles/text_styles.dart';

void showSnackBar(BuildContext context, String message, Color backgroundColor, Duration duration) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTextStyles.snackbarText,
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    )
  );
}

