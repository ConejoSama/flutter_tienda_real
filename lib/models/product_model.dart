class ProductModel {
  final String pbrand;
  final String pcategory;
  final String id;
  final String pname;
  final String ppicture;
  final int pprice;
  final int pquantity;
//  final String psale;
//  final String pfeatured;
//  List<String> pcolors;
//  List<String> psizes;

  ProductModel({this.pname,this.id,this.ppicture,this.pbrand,this.pcategory,this.pprice,this.pquantity});
//  ,this.psizes,this.pcolors,this.psale,this.pfeatured
  ProductModel.fromMap(Map<String,dynamic> data, String id):
        pbrand=data["brand"],
        pcategory=data["category"],
        pname=data["name"],
        ppicture=data["picture"],
        pprice=data["price"],
        pquantity=data["quantity"],
//        psale=data['sale'],
//        pfeatured=data["featured"],
//        pcolors=data['colors'],
//        psizes=data['sizes'],
        id=id;

  Map<String, dynamic> toMap() {
    return {
      "name": pname,
      "category": pcategory,
      'id':id,
      "brand": pbrand,
      "picture": ppicture,
      "price": pprice,
      "quantity": pquantity,
//      "featured": pfeatured,
//      "sale": psale,
//      "colors" : pcolors,
//      "sizes": psizes,
    };
  }

}

class TotalModel {
  final int total;


  TotalModel(this.total);

  TotalModel.fromMap(Map<String,dynamic> data, String id):
      total=data["totalprice"];

  Map<String, dynamic> toMap() {
    return {
      'totalprice':total
};
}
}