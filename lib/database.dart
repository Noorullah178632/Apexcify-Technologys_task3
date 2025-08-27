import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static Future<void> addActivity(Map<String, dynamic> data, String id) async {
    await FirebaseFirestore.instance.collection('activities').doc(id).set(data);
  }
}
