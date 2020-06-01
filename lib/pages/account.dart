import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tienda_real/pages/home.dart';
import 'package:flutter_tienda_real/provider/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController NameController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  TextEditingController ENameController = TextEditingController();

  final brandController = TextEditingController();

  final priceController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
  <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentBrand;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  List<String> selectedSizes = <String>[];
  List<String> colors = <String>[];
  bool onSale = false;
  bool featured = false;
  Firestore _firestore = Firestore.instance;
  String ref = 'Products';

  bool isLoading = false;

  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        leading: Icon(
          Icons.close,
        ),
        title: Text(
          "My Account",
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: NameController,
                  decoration: InputDecoration(hintText: 'Full Name'),
                  validator: (value) {

                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: ENameController,
                  decoration: InputDecoration(hintText: 'Full Name'),
                  validator: (value) {

                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: pwController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  validator: (value) {

                  },
                ),
              ),

              FlatButton(
                color: red,
                textColor: white,
                child: Text('Update Data'),
                onPressed: () { _changePassword(pwController.text, ENameController.text, NameController.text);
//                  validateAndUpload();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  void _changePassword(String password, String email, String name) async{
    //Create an instance of the current user.
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if(pwController != null)
      {
        //Pass in the password to updatePassword.
        user.updatePassword(password).then((_){
          print("Succesfull changed password");
          Fluttertoast.showToast(msg: 'Password changed');
        }).catchError((error){
          print("Password can't be changed" + error.toString());
          Fluttertoast.showToast(msg: 'Password not changed');
          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        });
      }
    if(ENameController != null){
    //email
      user.updateEmail(email).then((_){
        print("Succesfull changed email");
        Fluttertoast.showToast(msg: 'Email changed');
      }).catchError((error){
        print("Email can't be changed" + error.toString());
        Fluttertoast.showToast(msg: 'Email not changed');
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });

    }
//    if(NameController != null){
//      //email
//      FirebaseUser user = await _auth.signInWithCredential(credential);
//      var userUpdateInfo = UserUpdateInfo();
//      userUpdateInfo.displayName = name;
//      user.updateProfile(userUpdateInfo);
//
//
//  }
      Navigator.pop(context,true);
//    Navigator.push(context, MaterialPageRoute(builder: (_)=>HomePage()));

}
}