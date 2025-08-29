import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task4/database.dart';

class Logacitvityscreen extends StatefulWidget {
  const Logacitvityscreen({super.key});

  @override
  State<Logacitvityscreen> createState() => _LogacitvityscreenState();
}

class _LogacitvityscreenState extends State<Logacitvityscreen> {
  //add textediting controller to controll the textfield
  final exerciseController = TextEditingController();
  final caloriesController = TextEditingController();
  final timeController = TextEditingController();

  //make a method for database to store data in the data base
  Future<void> saveActivity() async {
    if (exerciseController.text.isEmpty ||
        caloriesController.text.isEmpty ||
        timeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }
    String id = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> activityData = {
      'exercise': exerciseController.text,
      'calories': int.parse(caloriesController.text),
      'time': int.parse(timeController.text), // save time
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await Database.addActivity(activityData, id);
      Get.snackbar("Saved", "Saved the Activity in the backened");
      exerciseController.clear();
      caloriesController.clear();
      timeController.clear();
    } catch (e) {
      Get.snackbar("Error", "Error saving activity: $e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    exerciseController.dispose();
    caloriesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'AddActivity',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: exerciseController,

              decoration: InputDecoration(
                labelText: 'Exercise Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: caloriesController,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                labelText: 'Calories Burned',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: timeController,
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await saveActivity();
              },
              child: Text('Save Activity', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
