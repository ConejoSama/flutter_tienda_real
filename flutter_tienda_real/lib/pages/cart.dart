import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_tienda_real/components/cart_products.dart';
import 'package:flutter_tienda_real/firestoreserice/firestore_service.dart';
import 'package:flutter_tienda_real/firestoreserice/firestore_service_cart.dart';
import 'package:flutter_tienda_real/models/Posts.dart';
import 'package:flutter_tienda_real/models/product_model.dart';
import 'package:flutter_tienda_real/pages/Posts_Details.dart';
import 'package:flutter_tienda_real/provider/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class Cart extends StatefulWidget {

  final username, userid;
  Cart({Key key,@required this.userid,this.username,}) : super(key : key);

  @override
  _CartState createState() => _CartState(userid, username);
}

class _CartState extends State<Cart> {
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  final userid, username;
  _CartState(this.userid,this.username);
  Razorpay _razorpay;
  int TotalAmount;
  var UName,UAddress,UDate, Uid, UState, UEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async{
    var options ={
      'key': 'rzp_test_Lr4bSMlixaGLjO',
      'amount': TotalAmount*100,
//      'currency':'USD',
      'name': username,
      'Description': 'BUY',
      'prefill': {'contact ':'','email': ''},
      'external':{
        'wallets':['paytm']
      }
    };
    try{
      _razorpay.open(options);
    }
    catch(e){
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(msg: 'SUCCESS: '+response.paymentId);
    var respuesta = response.paymentId;

    Firestore.instance.collection('Orders').document(userid).setData({
      "id":userid,
      "name":UName,
      "price":TotalAmount,
      "address":categoryController.text,
      "date":UDate,
      "Email":UEmail,
      "State":'Pending',
      "paymentid":respuesta,
    });

    DocumentReference documentReference =
    Firestore.instance.collection("TotalList").document('Total');
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        int CantidadActual = datasnapshot.data['OrdersTotal'];
        int CantidadTotal = CantidadActual + 1;
        Firestore.instance.collection("TotalList").document('Total').updateData({
          'OrdersTotal':CantidadTotal,
        });
      }
      else{
        Firestore.instance.collection("TotalList").document('Total').setData({
          'OrdersTotal': 1,
          'CategoryTotal': 0,
          'ProductTotal':0,
          'UsersTotal':0,
        });
      }
    });

    Navigator.pop(context, true);
  }
  
  void _handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: 'ERROR '+response.code.toString()+" - "+response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: 'EXTERNAL WALLET '+response.walletName);
  }


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text("Cart"),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: (){}),

        ],
      ),

      body: ListView(

        children: <Widget>[
          StreamBuilder(
            stream: FirestoreServiceCart().getProductModel(user.user.uid) ,
            builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
              if(snapshot.hasError || !snapshot.hasData)
                return CircularProgressIndicator();
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ProductModel note = snapshot.data[index];

                  return ProductsUI(note);

                },
              );
            },
          ),
                ],
    ),

      bottomNavigationBar: new Container(
        color: Colors.white,


          child: StreamBuilder(
            stream: FirestoreServiceCart().getTotalPrice(user.user.uid) ,
            builder: (BuildContext context, AsyncSnapshot<List<TotalModel>> snapshot){
              if(snapshot.hasError || !snapshot.hasData)
                return CircularProgressIndicator();
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  TotalModel note = snapshot.data[index];
                  TotalAmount  = note.total;
                  return Row(
                    children: <Widget>[

                      Expanded(
                        child: ListTile(
                          title: new Text("Total:"),
                          subtitle: new Text("\$${note.total}"),
                        ),
                      ),
                      Expanded(
                        child: new MaterialButton(onPressed: (){
                          Firestore.instance.collection('Orders').document(user.user.uid).get().then((onValue){

                            if(!onValue.exists)
                            {
                              // set up the buttons
                              Widget cancelButton = FlatButton(
                                child: Text("Cancel"),
                                onPressed:  () => Navigator.pop(context, true),
                              );
                              Widget continueButton = FlatButton(
                                child: Text("Continue"),
                                onPressed:  () {



                                  var alert = new AlertDialog(
                                    content: Form(
                                      key: _categoryFormKey,
                                      child: TextFormField(
                                        controller: categoryController,
                                        validator: (value){
                                          if(value.isEmpty){
                                            return 'must be provided the address';
                                          }
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Address"
                                        ),
                                      ),

                                    ),

                                    actions: <Widget>[
                                      FlatButton(onPressed: (){
                                        if(categoryController.text != null){
                                          Uid = user.user.uid;
                                          UName = username;
                                         UAddress = categoryController.text;
                                         UEmail = user.user.email;
                                         UDate = formattedDate;
                                         UState = 'Pending';

                                          openCheckout();

//

                                        }
//          Fluttertoast.showToast(msg: 'category created');
                                        Navigator.pop(context);
                                      }, child: Text('Accept')),
                                      FlatButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text('Cancel')),

                                    ],
                                  );
                                  showDialog(context: context, builder: (_) => alert);



                                },
                              );

                              // set up the AlertDialog
                              AlertDialog alert = AlertDialog(
                                title: Text("Confirmation"),
                                content: Text("If continue, you cannot add more items to cart until your item has delivered"),
                                actions: [
                                  cancelButton,
                                  continueButton,
                                ],
                              );

                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }
                            else
                            {
                              Fluttertoast.showToast(msg: 'Already asked');

                            }});

                        },
                          child: new Text("Check out",style: TextStyle(color: Colors.white),),
                          color: Colors.red,),
                      )
                    ],
                  );

                },
              );
            },
          ),
        ),


    );
  }

  Widget ProductsUI(ProductModel note)
  {
    return new Card
      (
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),

      child: InkWell(
//        onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostsDetails(id : note.id, name : note.pname, price : note.pprice, picture : note.ppicture, quantity : note.pquantity, brand : note.pbrand, category : note.pcategory)));},
        onTap: (){_deleteNote(context, note.id);},

        child: new Container(
          padding: new  EdgeInsets.all(14.0),

          child: new  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              new Row(
                children: <Widget>[

                  new Image.network(note.ppicture,height: 75,width: 75),

                  SizedBox(width: 13),
                  Column(

                    children: <Widget>[

                      new Text(note.pname,
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      new Text("\$${note.pprice}",textAlign: TextAlign.left,

                      ),

//                      ListTile(
//                        trailing:  IconButton(
//                          color: Colors.red,
//                          icon: Icon(Icons.delete),
//                          onPressed: () => _deleteNote(context, note.id),
//                        ),
//
//
//                      )

                    ],
                  )




                ],
              ),


            ],
          ),
        ),
      ),
    );
  }


  void _deleteNote(BuildContext context,String id) async {
    if(await _showConfirmationDialog(context)) {
      try {
        Firestore.instance.collection('Orders').document(userid).get().then((onValue){

          if(!onValue.exists)
          {
             Firestore.instance.collection('Users').document(userid).collection('Cart').document(id).delete();
          }
          else
          {
            Fluttertoast.showToast(msg: 'Already asked');

          }});


      }catch(e) {
        print(e);
      }
    }
  }
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) =>
            AlertDialog(
              content: Text("Are you sure you want to delete?"),
              actions: <Widget>[
                FlatButton(
                  textColor: Colors.red,
                  child: Text("Delete"),
                  onPressed: () => Navigator.pop(context, true),
                ),
                FlatButton(
                  textColor: Colors.black,
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ));
  }

}

