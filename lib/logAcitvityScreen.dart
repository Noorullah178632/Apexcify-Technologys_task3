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
  //make a form key for the form
  final formKey = GlobalKey<FormState>();
  //add textediting controller to controll the textfield
  final exerciseController = TextEditingController();
  final caloriesController = TextEditingController();
  final durationController = TextEditingController();
  void clear() {
    exerciseController.clear();
    caloriesController.clear();
    durationController.clear();
    setState(() {});
  }

  //make a method for database to store data in the data base
  Future<void> saveActivity() async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> activityData = {
      'name': exerciseController.text,
      'calories': int.parse(caloriesController.text),
      'duration': int.parse(durationController.text),
      'timestamp': FieldValue.serverTimestamp(),
    };

    await Database.addActivity(activityData, id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    exerciseController.dispose();
    caloriesController.dispose();
    durationController.dispose();
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
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: exerciseController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter exercise name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Exercise Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: caloriesController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Calories Burned',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter time';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await saveActivity();
                    Get.snackbar(
                      "Saved Data",
                      "Your data is saved in the backened",
                    );
                    clear();
                  }
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
      ),
    );
  }
}
