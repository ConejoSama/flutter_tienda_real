import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_tienda_real/firestoreserice/firestore_service.dart';
import 'package:flutter_tienda_real/models/Posts.dart';
import 'package:flutter_tienda_real/models/product_model.dart';
import 'package:flutter_tienda_real/models/searchservice.dart';
import 'package:flutter_tienda_real/pages/account.dart';
import 'package:flutter_tienda_real/pages/cart.dart';
import 'package:flutter_tienda_real/pages/category.dart';
import 'package:flutter_tienda_real/pages/favorites.dart';
import 'package:flutter_tienda_real/pages/login.dart';
import 'package:flutter_tienda_real/provider/app_provider.dart';
import 'package:flutter_tienda_real/provider/user_provider.dart';
import 'package:flutter_tienda_real/pages/product_details.dart';
import 'package:flutter_tienda_real/widgets/custom_app_bar.dart';
import 'package:flutter_tienda_real/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_tienda_real/pages/Posts_Details.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  var categorydivider = 'PUEDOSENTIR';
var queryResultSet = [];
var tempSearchStore = [];
var NaM;

initiateSearch(value) {
  if (value.length == 0) {
    setState(() {
      queryResultSet = [];
      tempSearchStore = [];
    });
  }

  var capitalizedValue =
      value.substring(0, 1).toUpperCase() + value.substring(1);

  if (queryResultSet.length == 0 && value.length == 1) {
    SearchService().searchByName(value).then((QuerySnapshot docs) {
      for (int i = 0; i < docs.documents.length; ++i) {
        queryResultSet.add(docs.documents[i].data);
      }
    });
  } else {
    tempSearchStore = [];
    queryResultSet.forEach((element) {
      if (element['category'].startsWith(capitalizedValue)) {
        setState(() {
          tempSearchStore.add(element);
        });
      }
    });
  }
}

  @override
  Widget build(BuildContext context) {
  var querydata = MediaQuery.of(context);
  var screen_height = querydata.size.height;
  var container_height = screen_height/6;
    final user = Provider.of<UserProvider>(context);
    DocumentReference documentReference =
    Firestore.instance.collection("Users").document(user.user.uid);
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        NaM = datasnapshot.data['name'].toString();
      }
      else{
        print("No name");
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('SHOP APP'),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
//            header
            new UserAccountsDrawerHeader(
              accountName: Text(NaM ?? ''),
              accountEmail: Text(user.user.email ?? ''),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white,),
                ),
              ),
              decoration: new BoxDecoration(
                  color: Colors.red.shade900
              ),
            ),

//            body

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home),
              ),
            ),

            InkWell(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_)=>Account()));},
              child: ListTile(
                title: Text('My account'),
                leading: Icon(Icons.person),
              ),
            ),


            InkWell(
              onTap: (){{Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart(username: NaM ,userid : user.user.uid)));
                }

              },
              child: ListTile(
                title: Text('My Cart'),
                leading: Icon(Icons.shopping_cart),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('My Orders'),
                leading: Icon(Icons.shopping_basket),
              ),
            ),

            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Categories'),
                leading: Icon(Icons.dashboard),
              ),
            ),

            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favorites(userid : user.user.uid)));
              },
              child: ListTile(
                title: Text('My Favorites'),
                leading: Icon(Icons.favorite),
              ),
            ),

            Divider(),

            InkWell(
              onTap: (){
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.pop(context, MaterialPageRoute(builder: (context)=> Login()));
//                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                });
              },
              child: ListTile(
                title: Text('Log out'),
                leading: Icon(Icons.transit_enterexit, color: Colors.grey,),
              ),
            ),

          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
//           Custom App bar


//          Search Text field
         ListView(
           scrollDirection: Axis.vertical,
           shrinkWrap: true,
           children: <Widget>[

            Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.arrow_back),
                    iconSize: 20.0,
                    onPressed: () {},
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
            SizedBox(height: 10.0),
            GridView.count(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                primary: false,
                shrinkWrap: true,
                children: tempSearchStore.map((element) {
                  return buildResultCard(element);
                }).toList())
            ]),

//            featured products
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('Featured products')),
                ),
              ],
            ),
//            FeaturedProducts(),

            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('Recent products')),
                ),
              ],
            ),
            StreamBuilder(
              stream: FirestoreService().getProductModel(categorydivider) ,
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
        onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostsDetails(id : note.id, name : note.pname, price : note.pprice, picture : note.ppicture, quantity : note.pquantity, brand : note.pbrand, category : note.pcategory)));},
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
                      new Text("\$${note.pprice}"

                      ),
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

Widget buildResultCard(data) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: InkWell(
          onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context) => Category(category : data['category'].toString())));},
          child: Container(
              child: Center(
                  child: Text(data['category'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  )
              )
          )
      )

  );
}
}

