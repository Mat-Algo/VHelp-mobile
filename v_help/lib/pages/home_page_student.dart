import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:v_help/models/home_model.dart';
import 'package:v_help/pages/analyticsPage.dart';
import 'package:v_help/pages/pages_login/login_register.dart';
import 'package:v_help/pages/shop_main.dart';
import 'package:v_help/pages/user_status.dart';

class HomeScreenStudent extends StatefulWidget {
  const HomeScreenStudent({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenStudent> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(
              child: Text("Choose your service",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 30)),
            ),
          ),
          
          AspectRatio(
            aspectRatio: 0.85,
            child: PageView.builder(
                itemCount: dataList.length,
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                itemBuilder: (context, index) {
                  return carouselView(index);
                }),
          )
        ],
      ),
    ),
    // Add a floating action button as a logout button
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Log the user out and navigate to the LoginOrRegister page
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginOrRegister()));
      },
      child: Icon(Icons.logout),
      tooltip: 'Logout',
    ),
  );
}

  Widget carouselView(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0);
          value = (value * 0.038).clamp(-1, 1);
          print("value $value index $index");
        }
        return Transform.rotate(
          angle: pi * value,
          child: carouselCard(dataList[index]),
        );
      },
    );
  }

 Widget carouselCard(DataModel data) {
  return Column(
    children: <Widget>[
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Hero(
            tag: data.imageName,
            child: GestureDetector(
              onTap: () {
                // Determine action based on the data.title
                if (data.title == 'Laundry Logistics') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StudentInfoPage()));
                } else if (data.title == 'Mess Navigator') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StudentMessMealPreferencesPage()));
                } else if (data.title == 'Food Park') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  MainPage()));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(offset: Offset(0, 4), blurRadius: 4, color: Colors.black26)
                  ],
                ),
                child: Lottie.asset(
                  data.imageName,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          data.title,
          style: const TextStyle(color: Colors.black45, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}


}