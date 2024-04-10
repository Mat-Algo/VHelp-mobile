class DataModel {
  final String title;
  final String imageName;
  DataModel(
    this.title,
    this.imageName
  );
}

List<DataModel> dataList = [
  DataModel("Laundry Logistics", "assets/animations/w_machine.json" ),
  DataModel("Mess Navigator", "assets/animations/analytics.json" ),
  DataModel("Food Park", "assets/animations/food_order.json"),
];