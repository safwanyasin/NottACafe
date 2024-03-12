import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nottacafe/main.dart';
import 'package:nottacafe/shared_functions/mark_fulfilled.dart';
import 'package:nottacafe/shared_functions/show_toast.dart';
import 'package:nottacafe/src/app.dart';
import 'package:nottacafe/styles/text_styles.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  final String orderID;
  final String foodID;
  final String foodName;
  final int quantity;
  final String deliveryTime;
  final String address;
  final String cName;
  final String cPhone;

  const OrderDetails(
      {required this.orderID,
      this.foodID = 'xxx',
      this.foodName = 'Untitled',
      this.quantity = 0,
      this.deliveryTime = '09 00',
      this.address = 'nowhere',
      this.cName = "anonymous",
      this.cPhone = "000",
      super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var isDark = themeChange.darkTheme;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        appBar: AppBar(
          title:
              Text("Order Details", style: AppTextStyles.secondaryHeadingWhite),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.quantity.toString() + " " + widget.foodName,
                      style: isDark
                          ? AppTextStyles.primaryHeadingWhite
                          : AppTextStyles.primaryHeadingBlack,
                    ),
                    Text(
                      widget.deliveryTime == "Instant"
                          ? "Instant Delivery"
                          : "Scheduled at ${widget.deliveryTime}",
                      style: AppTextStyles.smallDescriptionBlue,
                    ),
                    SizedBox(height: 15),
                    Row(
                      //mainAxisAlignment: main,
                      //crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Text("Customer Name: ",
                            style: AppTextStyles.smallDescriptionGrey),
                        SizedBox(width: 5),
                        Text(widget.cName,
                            style: isDark
                                ? AppTextStyles.secondaryHeadingWhite
                                : AppTextStyles.secondaryHeadingBlack)
                      ],
                    ),
                    Row(
                      children: [
                        Text("Phone: ",
                            style: AppTextStyles.smallDescriptionGrey),
                        SizedBox(width: 5),
                        Text(widget.cPhone,
                            style: isDark
                                ? AppTextStyles.secondaryHeadingWhite
                                : AppTextStyles.secondaryHeadingBlack)
                      ],
                    ),
                    Text("Address:", style: AppTextStyles.smallDescriptionGrey),
                    Text(widget.address,
                        style: isDark
                            ? AppTextStyles.descriptionWhite
                            : AppTextStyles.descriptionBlack),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          "Mark as fulfilled",
                          style: AppTextStyles.buttonTextWhite,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    //buttonColor: Theme.of(context).colorScheme.primary,
                    //buttonTextStyle: AppTextStyles.buttonTextWhite,

                    onPressed: () async {
                      await markAsFulfilled(
                          widget.orderID, widget.foodID, widget.quantity);
                      showToast(
                          "The order has been marked as fulfilled. Refresh to see changes",
                          Toast.LENGTH_SHORT);
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ));
  }
}
