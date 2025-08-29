import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Historyscreen extends StatefulWidget {
  const Historyscreen({super.key});

  @override
  State<Historyscreen> createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<Historyscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('activities')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No data in the database "));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var activity = snapshot.data!.docs[index];
              //get the time stramp

              Timestamp timestamp = activity["createdAt"];
              //convert to dataTime
              DateTime dateTime = timestamp.toDate();
              String formattedDate =
                  "${dateTime.day}/${dateTime.month}/${dateTime.year}";
              return Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Exercise: ${activity['exercise']}"),
                        subtitle: Text(
                          "${activity["calories"]} cal burned in ${activity["time"]} minute",
                        ),
                        trailing: Text(formattedDate),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
