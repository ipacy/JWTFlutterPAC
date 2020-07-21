import 'package:flutter/material.dart';
import 'package:flutter_app/Models/Product.dart';
import 'package:flutter_app/Models/Response/Result.dart';
import 'package:flutter_app/Controllers/ProductsController.dart';
import 'package:flutter_app/Utils/Toasted.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetail extends StatefulWidget {
  final String appBarTitle;
  final Product product;

  ProductDetail(this.product, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return TodoDetailState(this.product, this.appBarTitle);
  }
}

class TodoDetailState extends State<ProductDetail> {
  ProductsController productsDb = new ProductsController();

  String appBarTitle;
  final Product product;

  TextEditingController nameController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TodoDetailState(this.product, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    nameController.text = product.name;
    unitController.text = product.unit;
    priceController.text = product.price.toString();
    idController.text = product.id.toString();

    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            backgroundColor: Colors.blueGrey,
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      // updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: priceController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      // updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: unitController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      // updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'Unit',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save(context);
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Save data to database
  void _save(BuildContext context) async {
    if (idController.text == "00000000-0000-0000-0000-000000000000") {
      Map product = {
        'name': nameController.text,
        'unit': unitController.text,
        'price': double.parse(priceController.text)
      };
      var response = await productsDb.addProduct(product);
      if (response is SuccessState) {
        Navigator.pushNamed(context, '/product_list');
        //moveToLastScreen();
      }
    } else {
      Map product = {
        'id': idController.text,
        'name': nameController.text,
        'unit': unitController.text,
        'price': double.parse(priceController.text)
      };
      var response = await productsDb.updateProduct(product, idController.text);
      if (response is SuccessState) {
        Navigator.pushNamed(context, '/product_list');
      }
    }
  }

  void _delete() async {
    var response = await productsDb.deleteProduct(idController.text);
    if (response is SuccessState) {
      moveToLastScreen();
    } else {
      Fluttertoast.showToast(
          msg: 'Product Deleted', toastLength: Toast.LENGTH_LONG);
    }
  }
}
