import 'package:flutter/material.dart';
import 'package:flutter_tienda_real/firestoreserice/firestore_service.dart';
import 'package:flutter_tienda_real/models/product_model.dart';
import 'package:flutter_tienda_real/pages/Posts_Details.dart';
import 'package:flutter_tienda_real/provider/user_provider.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {

  final category;
  Category({Key key,@required this.category,}) : super(key : key);

  @override
  _CategoryState createState() => _CategoryState(category);
}

class _CategoryState extends State<Category> {
  final category;
  _CategoryState(this.category);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),

      body: SafeArea(
        child: ListView(
          children: <Widget>[

            StreamBuilder(
              stream: FirestoreService().getProductModel(category) ,
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
}
