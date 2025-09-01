import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  //we will make a function to get the data from the firebase and show it in the chart bar
  List<double> getWeeklyCalories(List<QueryDocumentSnapshot> allDocs) {
    List<double> weeklyData = [0, 0, 0, 0, 0, 0, 0];
    DateTime today = DateTime.now();
    for (var doc in allDocs) {
      Timestamp timestamp = doc['createdAt'];
      DateTime dailyActivity = timestamp.toDate();
      int dayDiff = today.difference(dailyActivity).inDays;
      if (dayDiff >= 0 && dayDiff < 7) {
        weeklyData[dayDiff] += (doc["calories"] as int).toDouble();
      }
    }
    return weeklyData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'DashBoard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('activities').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          //calculate today date
          DateTime today = DateTime.now();
          DateTime todayStart = DateTime(today.year, today.month, today.day);
          DateTime todayEnd = DateTime(
            today.year,
            today.month,
            today.day,
            23,
            59,
            59,
          );
          //filtering today's activities
          List<QueryDocumentSnapshot> todayActivities = snapshot.data!.docs
              .where((doc) {
                Timestamp timestamp = doc["createdAt"];
                DateTime activityDate = timestamp.toDate();
                return activityDate.isAfter(todayStart) &&
                    activityDate.isBefore(todayEnd);
              })
              .toList();

          //calculate totals
          int totalCalories = todayActivities.fold(
            0,
            (sum, doc) => sum + (doc["calories"] as int),
          );
          int totalDuration = todayActivities.fold(
            0,
            (sum, doc) => sum + (doc["time"] as int),
          );
          int totalActivites = todayActivities.length;
          //for graphs
          List<double> weeklyCalaries = getWeeklyCalories(snapshot.data!.docs);
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                color: Colors.orange,
                                size: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '$totalCalories cal',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Calories',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(Icons.timer, color: Colors.blue, size: 40),
                              SizedBox(height: 8),
                              Text(
                                '$totalDuration min',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Workout Time',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.list, color: Colors.green, size: 40),
                        Column(
                          children: [
                            Text(
                              '$totalActivites workouts',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Today', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Weekly Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                Container(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      barGroups: [
                        for (int i = 0; i < 7; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: weeklyCalaries[i],
                                color: Colors.blue,
                              ),
                            ],
                          ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, day) {
                              const days = ['1', '2', '3', '4', '5', '6', '7'];
                              return Text(days[value.toInt()]);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
