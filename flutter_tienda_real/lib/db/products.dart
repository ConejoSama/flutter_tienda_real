import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_tienda_real/models/product.dart';

class ProductsService{
  Firestore _firestore = Firestore.instance;
  String collection = 'products';

  Future<List<Product>> getFeaturedProducts() =>
      _firestore.collection(collection).where('featured', isEqualTo: true).getDocuments().then((snap){
        List<Product> featuredProducts = [];
         snap.documents.map((snapshot)=> featuredProducts.add(Product.fromSnapshot(snapshot)));
            return featuredProducts;
      });

}

