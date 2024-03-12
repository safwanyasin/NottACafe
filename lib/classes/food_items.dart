class FoodItem {
  final String foodID;
  final String name;
  final String restaurantID;
  final String restaurantName;
  final String cuisineID;
  final String cuisineName;
  final int calorieCount;
  final num price;
  final String image;
  final String description;

  FoodItem(
      {required this.foodID,
      required this.name,
      required this.restaurantID,
      required this.restaurantName,
      required this.calorieCount,
      required this.cuisineID,
      required this.cuisineName,
      required this.image,
      required this.price,
      required this.description});
}
