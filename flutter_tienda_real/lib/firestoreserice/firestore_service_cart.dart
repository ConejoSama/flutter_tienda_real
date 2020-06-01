import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tienda_real/models/product_model.dart';

class FirestoreServiceCart {
  static final FirestoreServiceCart _firestoreService =
  FirestoreServiceCart._internal();
  Firestore _db = Firestore.instance;

  FirestoreServiceCart._internal();

  factory FirestoreServiceCart() {
    return _firestoreService;
  }


  Stream<List<ProductModel>> getProductModel(String userid) {
    return _db.collection('Users').document(userid).collection('Cart').snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => ProductModel.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Stream<List<TotalModel>> getTotalPrice(String userid) {
    return _db.collection('Users').document(userid).collection('Total').snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => TotalModel.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

}


