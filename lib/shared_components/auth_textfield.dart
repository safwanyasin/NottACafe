import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class AuthTextfield extends StatefulWidget {
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final Function()? onTap;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final IconData? suffixIcon;
  final Function()? suffixIconTap;
  final String? initialValue;
  final void Function()? onEditingComplete;
  final bool labelAbove;
  final bool showCursor;
  final TextEditingController? textEditingController;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const AuthTextfield({
    Key? key,
    this.validator,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.suffixIcon,
    this.suffixIconTap,
    this.initialValue,
    this.onEditingComplete,
    this.labelAbove = false,
    this.showCursor = false,
    this.textEditingController,
    this.inputFormatters,
    this.maxLength,
  }) : super(key: key);

  @override
  State<AuthTextfield> createState() => _AuthTextfieldState();
}

class _AuthTextfieldState extends State<AuthTextfield> {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DarkThemeProvider>(context);
    bool isDark = theme.darkTheme;
    return TextFormField(
      validator: widget.validator,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      initialValue: widget.initialValue,
      onEditingComplete: widget.onEditingComplete,
      controller: widget.textEditingController,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      style: isDark ? AppTextStyles.desriptionWhite : AppTextStyles.descriptionBlack,
      decoration: InputDecoration(
        errorMaxLines: 6,
        errorStyle: AppTextStyles.textFieldError,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
                //color: isDark ? AppColors.white : const Color.fromRGBO(0, 0, 0, 0.5),
                color: isDark ? AppColors.white: AppColors.black,
                width: 2,
                style: BorderStyle.solid)),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : null,
        suffixIcon: widget.suffixIcon != null
            ? GestureDetector(
                onTap: widget.suffixIconTap,
                child: Icon(
                  widget.suffixIcon,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: AppTextStyles.textFieldHint,
        fillColor: Theme.of(context).colorScheme.primaryContainer,
        filled: true,
        labelText: widget.hintText,
        labelStyle: isDark ? AppTextStyles.descriptionWhite : AppTextStyles.descriptionBlack
        //style: AppTextStyles.descriptionWhite
        //label: widget.labelAbove ? Text(widget.hintText.toString()) : null,
        //labelText: widget.labelAbove == true ? widget.hintText.toString() : '',
      ),
    );
  }
}
