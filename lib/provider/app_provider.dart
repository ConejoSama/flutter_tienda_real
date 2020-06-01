import 'package:flutter/material.dart';
import 'package:flutter_tienda_real/db/products.dart';
import 'package:flutter_tienda_real/models/product.dart';

class AppProvider with ChangeNotifier{
  List<Product> _featureProducts = [];
  ProductsService _productService = ProductsService();
  AppProvider(){
    getFeaturedProducts();
  }

  //getter
  List<Product> get featuredProducts => _featureProducts;

//methods
  void getFeaturedProducts() async{
    _featureProducts = await _productService.getFeaturedProducts();
    notifyListeners();
  }
}