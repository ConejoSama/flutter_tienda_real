import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_tienda_real/db/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status{Uninitialized, Authenticated, Authenticating, Unauthenticated}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  FirebaseUser get user => _user;
  Firestore _firestore = Firestore.instance;
  UserServices _userServices = UserServices();
  final DBRef = FirebaseDatabase.instance.reference();

  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password)async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }


  Future<bool> signUp(String name,String email, String password)async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password).then((user){
        Firestore.instance.collection('Users').document(user.user.uid).setData({
          'name':name,
          'email':email,
          'uid':user.user.uid
        });
        DocumentReference documentReference =
        Firestore.instance.collection("TotalList").document('Total');
        documentReference.get().then((datasnapshot) {
          if (datasnapshot.exists) {
            int CantidadActual = datasnapshot.data['UsersTotal'];
            int CantidadTotal = CantidadActual + 1;
            Firestore.instance.collection("TotalList").document('Total').updateData({
              'UsersTotal':CantidadTotal,
            });
          }
          else{
            Firestore.instance.collection("TotalList").document('Total').setData({
              'UsersTotal': 1,
              'CategoryTotal': 0,
              'ProductTotal':0,
              'OrdersTotal':0,
            });
          }
        });
      });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }



  Future<void> _onStateChanged(FirebaseUser user) async{
    if(user == null){
      _status = Status.Unauthenticated;
    }else{
      _user = user;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}