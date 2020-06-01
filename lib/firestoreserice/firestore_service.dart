import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tienda_real/models/product_model.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
  FirestoreService._internal();
  Firestore _db = Firestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }


  Stream<List<ProductModel>> getProductModel(String categorysort) {
    return _db.collection('Products').where('category',isEqualTo: categorysort).snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => ProductModel.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

  Stream<List<ProductModel>> getFavoriteModel(String categorysort) {
    return _db.collection('Users').document(categorysort).collection('Favorites').snapshots().map(
          (snapshot) => snapshot.documents.map(
            (doc) => ProductModel.fromMap(doc.data, doc.documentID),
      ).toList(),
    );
  }

}


