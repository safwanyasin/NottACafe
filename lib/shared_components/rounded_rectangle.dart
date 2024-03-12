import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RoundedRectangle extends StatelessWidget {
  const RoundedRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: MediaQuery.of(context).size.width * 0.3,
      // child: Card(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(20),
      //       bottomLeft: Radius.circular(20),
      //       topRight: Radius.circular(20),
      //       bottomRight: Radius.circular(20)
      //     )
      //   ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2.5)),
        color: Theme.of(context).colorScheme.onPrimary
      ),
      
      
    );
  }
}