import 'package:flutter/material.dart';
import 'package:nottacafe/shared_functions/navigation.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/src/screens/food/food.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class RoundedPictureContainer extends StatelessWidget {
  final String foodID;
  final String image;
  final String title;
  final String description;
  final int calorieCount;
  final num price;
  final String restaurantID;
  final String foodDescription;

  const RoundedPictureContainer(
      {Key? key,
      required this.foodID,
      required this.image,
      required this.title,
      required this.description,
      required this.calorieCount,
      required this.restaurantID,
      required this.price,
      required this.foodDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var isDark = themeChange.darkTheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      shadowColor: Theme.of(context).colorScheme.shadow,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
          onTap: () {
            justPush(
                context,
                Food(
                  foodID: foodID,
                  name: title,
                  restaurantName: description,
                  imageURL: image,
                  calorieCount: calorieCount,
                  restaurantID: restaurantID,
                  price: price,
                  description: foodDescription,
                ));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(20)),
                child: Image.network(
                  image,
                  height: MediaQuery.of(context).size.height / 6,
                  fit: BoxFit.cover,
                  width: (MediaQuery.of(context).size.width / 2) - 10,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        title,
                        style: isDark
                            ? AppTextStyles.descriptionWhite
                            : AppTextStyles.descriptionBlack,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        '${calorieCount.toString()} kcal',
                        style: AppTextStyles.smallDescriptionBlue,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0),
                child: Text(
                  description,
                  style: AppTextStyles.smallDescriptionGrey,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          )),
    );
  }
}
