import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nottacafe/services/firebase_service.dart';

Future markAsFulfilled(String orderID, String foodID, int quantity) async {
  MyFirebaseAuth _myfirebaseauth = MyFirebaseAuth();
  String userID = _myfirebaseauth.getCurrentUser!.uid;
  final data = {'orderID': orderID, 'foodID': foodID, 'quantity': quantity};
  await FirebaseFirestore.instance
      .collection('restaurants')
      .doc(userID)
      .collection('fulfilledOrders')
      .doc(orderID)
      .set(data);
  await FirebaseFirestore.instance
      .collection('restaurants')
      .doc(userID)
      .collection('pendingOrders')
      .doc(orderID)
      .delete();
}
