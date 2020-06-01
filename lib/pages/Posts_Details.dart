import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tienda_real/firestoreserice/firestore_service.dart';
import 'package:flutter_tienda_real/firestoreserice/firestore_service_cart.dart';
import 'package:flutter_tienda_real/models/Posts.dart';
import 'package:flutter_tienda_real/provider/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

class PostsDetails extends StatefulWidget {

  final id,name,price,quantity,picture,category,brand;
  PostsDetails({Key key,@required this.id,this.name,this.quantity,this.picture,this.price,this.category,this.brand}) : super(key : key);

  @override
  _PostsDetailsState createState() => _PostsDetailsState(id,name,quantity,picture,price,category,brand);
}

class _PostsDetailsState extends State<PostsDetails> {
  final DBRef = FirebaseDatabase.instance.reference();
  final id,name,price,quantity,picture,category,brand;
  _PostsDetailsState(this.id,this.name,this.quantity,this.picture,this.price,this.brand,this.category);
  FirebaseUser currentUser;
  Icon iconin = Icon(Icons.favorite_border);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> new HomePage()));
            },
            child: Text("SHOP APP")),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: (){}),

        ],
      ),
      body: new ListView(
        children: <Widget>[

          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.network(picture),
              ),
              footer: new Container(
                margin: const EdgeInsets.only(left: 50),
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(name,

                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),textAlign: TextAlign.center,),
                  title: new Row(
                    children: <Widget>[
//                      Expanded(
//                          child: new Text("\$${widget.product_detail_old_price}", style: TextStyle(color: Colors.grey, decoration:  TextDecoration.lineThrough),)
//                      ),
                      Expanded(
                          child: new Text("\$${price}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),textAlign: TextAlign.center)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //botones

//          Row(
//            children: <Widget>[
//
//              //Boton de Tamaño
//              Expanded(
//                child: MaterialButton(onPressed: (){
//                  showDialog(context: context,
//                      builder: (context){
//                        return new AlertDialog(
//                          title: new Text("Size"),
//                          content: new Text("Choose the size"),
//                          actions: <Widget>[
//                            new MaterialButton(onPressed: (){
//                              Navigator.of(context).pop(context);
//                            },
//                              child: new  Text("Close"),)
//                          ],
//                        );
//                      });
//                },
//                  color: Colors.white,
//                  textColor: Colors.grey,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                          child: new Text("Size")
//                      ),
//                      Expanded(
//                          child: new Icon(Icons.arrow_drop_down)
//                      ),
//                    ],
//                  ),
//                ),
//              ),

              //Boton de Color
//              Expanded(
//                child: MaterialButton(onPressed: (){
//                  showDialog(context: context,
//                      builder: (context){
//                        return new AlertDialog(
//                          title: new Text("Color"),
//                          content: new Text("Choose a color"),
//                          actions: <Widget>[
//                            new MaterialButton(onPressed: (){
//                              Navigator.of(context).pop(context);
//                            },
//                              child: new  Text("Close"),)
//                          ],
//                        );
//                      });
//                },
//                  color: Colors.white,
//                  textColor: Colors.grey,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                          child: new Text("Color")
//                      ),
//                      Expanded(
//                          child: new Icon(Icons.arrow_drop_down)
//                      ),
//                    ],
//                  ),
//                ),
//              ),


              //Boton de Cantidad
//              Expanded(
//                child: MaterialButton(onPressed: (){
//                  showDialog(context: context,
//                      builder: (context){
//                        return new AlertDialog(
//                          title: new Text("Quantity"),
//                          content: new Text("Choose the quantity"),
//                          actions: <Widget>[
//                            new MaterialButton(onPressed: (){
//                              Navigator.of(context).pop(context);
//                            },
//                              child: new  Text("Close"),)
//                          ],
//                        );
//                      });
//                },
//                  color: Colors.white,
//                  textColor: Colors.grey,
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                          child: new Text("Quantity")
//                      ),
//                      Expanded(
//                          child: new Icon(Icons.arrow_drop_down)
//                      ),
//                    ],
//                  ),
//                ),
//              ),


//            ],
//          ),

          Row(
            children: <Widget>[

              Expanded(
                child: MaterialButton(onPressed: (){
                  var uid = Uuid();
                  String productId = uid.v1();

                  Firestore.instance.collection('Orders').document(user.user.uid).get().then((onValue){

                    if(!onValue.exists)
                    {
                      Firestore.instance.collection('Users').document(user.user.uid).collection('Cart').document(productId).setData({
                        "name":name,
                        "price":price,
//              "sizes":selectedSizes,
//              "colors": colors,
                        "picture":picture,
//                    "quantity":quatityController.text,
                        "brand":brand,
                        "category":category,
//              'sale':onSale,
//              'featured':featured,
                        'id':productId,
                        'originalid':id
                      });

                      Firestore.instance.collection('Users').document(user.user.uid).collection('Total').document('Total').get().then((onValue){
                        if(!onValue.exists){
                          Firestore.instance.collection('Users').document(user.user.uid).collection('Total').document('Total').setData({
                            "totalprice":price,
                          });
                        }
                        else
                        {
                          int precioactual = price;
                          int preciointernet = onValue.data['totalprice'];
                          int preciototal = precioactual + preciointernet;
                          Firestore.instance.collection('Users').document(user.user.uid).collection('Total').document('Total').updateData({
                            "totalprice": preciototal,
                          });
                        }
                      });
                      Fluttertoast.showToast(msg: "Product Added");
                    }
                    else
                    {
                      Fluttertoast.showToast(msg: 'Already asked');

                    }});

                  Navigator.pop(context,true);
                },
                  color: Colors.red,
                  textColor: Colors.white,
                  elevation: 0.2,
                  child: new Text("Add To Cart"),
                ),
              ),


              new IconButton(icon: iconin,color: Colors.red, onPressed: (){
                Firestore.instance.collection('Users').document(user.user.uid).collection('Favorites').document(id).get().then((onValue){

                if(!onValue.exists)
                  {
                    setState(() {
                      iconin = Icon(Icons.favorite);
                    });
                    Firestore.instance.collection('Users').document(user.user.uid).collection('Favorites').document(id).setData({
                      "name":name,
                      "price":price,
//              "sizes":selectedSizes,
//              "colors": colors,
                      "picture":picture,
//                    "quantity":quatityController.text,
                      "brand":brand,
                      "category":category,
//              'sale':onSale,
//              'featured':featured,
                      'id':id
                    });
                    Fluttertoast.showToast(msg: "Favorite Added");
                  }
                else
                  {
                  {
                  setState(() {
                  iconin = Icon(Icons.favorite_border);
                  });
                  Firestore.instance.collection('Users').document(user.user.uid).collection('Favorites').document(id).delete();
                    Fluttertoast.showToast(msg: "Favorite Deleted");
                  }

                }});
              }),

            ],
          ),
          Divider(),
          new ListTile(
            title: new Text("Product Details"),
          ),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Product name", style: TextStyle(color: Colors.grey),),),
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text(name),)
            ],
          ),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Product brand", style: TextStyle(color: Colors.grey),),),

              //brand
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text(brand),)

            ],
          ),

          //similar products

//          Divider(),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: new Text("Similar Products"),
//          ),
          ]),
      );


  }

//  FavoriteDetecter()async{
//    final snapShot = await Firestore.instance
//        .collection('Users')
//        .document(user.user.uid)
//        .collection('Favorites')
//        .document(id)
//        .get();
//
//    if (snapShot == null || !snapShot.exists) {
//      // Document with id == docId doesn't exist.
//    }
//  }
//

}