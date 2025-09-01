import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:task4/dashBoardScreen.dart';
import 'package:task4/historyScreen.dart';
import 'package:task4/logAcitvityScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fitness Tracker App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int currentIndex = 0;
  final List<Widget> Screens = [
    Dashboardscreen(),
    Logacitvityscreen(),
    Historyscreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue, // Background color of the bar
        buttonBackgroundColor:
            Colors.transparent, // Background color of the pressed button
        backgroundColor: Colors.transparent, // Color behind the bar
        index: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          Icon(Icons.dashboard, size: 35, semanticLabel: "DashBoard"),
          Icon(Icons.add_circle, size: 35, semanticLabel: "LogActivity"),
          Icon(Icons.history, size: 35, semanticLabel: "History"),
        ],
      ),
    );
  }
}
