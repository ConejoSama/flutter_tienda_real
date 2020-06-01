import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices{
  Firestore _firestore = Firestore.instance;
  String collection = "Users";

  void createUser(Map data) {
    _firestore.collection(collection).document(data["id"]).setData(data);
  }
}