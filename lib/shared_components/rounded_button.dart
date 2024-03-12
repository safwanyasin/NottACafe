import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final String buttonText;
  final Color buttonColor;
  final TextStyle buttonTextStyle;
  final void Function() onTap;
  
  const RoundedButton({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextStyle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      color: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      elevation: 5,
      shadowColor: Theme.of(context).colorScheme.shadow,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Center(
            child: Text(
              buttonText,
              style: buttonTextStyle,
            ),
          ),
        ),
      ),
    );  
    
  }
}