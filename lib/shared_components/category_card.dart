import 'package:flutter/material.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/styles/colors.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatefulWidget {

  final String title;
  final IconData icon;
  final bool active;
  final void Function() onTap;

  const CategoryCard({
    Key? key,
    required this.title, 
    required this.icon, 
    required this.active,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var isDark = themeChange.darkTheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      elevation: 10,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: widget.active ? 
        Theme.of(context).colorScheme.onPrimaryContainer 
        : Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: widget.active ? 
                    AppColors.white
                    : Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Center(
                  child: Text(
                    widget.title,
                    style: widget.active ?
                      AppTextStyles.desriptionWhite
                      : isDark ? AppTextStyles.descriptionWhite : AppTextStyles.descriptionBlack,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: widget.active ? 
                  AppColors.white
                  : isDark ? AppColors.white : AppColors.black,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: widget.active ? 
                      Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.primaryContainer,
                    size: 10,
                  ),
                  onPressed: () {
                    widget.onTap();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}