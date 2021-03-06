import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Controllers/ProductsController.dart';
import 'package:flutter_app/Models/Product.dart';
import 'package:flutter_app/Models/Response/Result.dart';
import 'package:flutter_app/Utils/Toasted.dart';
import 'package:flutter_app/Views/ProductDetail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';

final storage = new FlutterSecureStorage();

class Products extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductListState();
  }
}

class ProductListState extends State<Products> {
  ProductsController productsDb = new ProductsController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Products List'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushNamed(context, '/login_page');
            },
          )
        ],
        //backgroundColor: const Color.fromRGBO(44, 120, 192, 255),
      ),
      body: Center(
        child: FutureBuilder(
            future: productsDb.getProducts(),
            builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
              if (snapshot.data is SuccessState) {
                List<Product> products = (snapshot.data as SuccessState).value;
                return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else {
                          body = Text("No more Data");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return productItem(index, products, context);
                        }));
              } else if (snapshot.data is ErrorState) {
                String errorMessage = (snapshot.data as ErrorState).msg;
                return Text(errorMessage);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Product(new Guid(''), '', '', 0), 'Add Todo');
        },
        tooltip: 'Add Product',
        child: Icon(Icons.add),
      ),
    );
  }

  Dismissible productItem(
      int index, List<Product> products, BuildContext context) {
    return Dismissible(
      onDismissed: (direction) async {
        var response =
            await productsDb.deleteProduct(products[index].id.toString());
        if (response is SuccessState) {
          Toasted.showSnackBar(context, response.value);
        }
        setState(() {
          products.removeAt(index);
        });
        // Result result = await _apiResponse.deleteBook(index);
      },
      background: Container(
        color: Colors.red,
      ),
      key: Key(products[index].name),
      child: Card(
        borderOnForeground: true,
        color: Colors.white,
        elevation: 6.0,
        child: CupertinoListTile(
          leading: Image.asset("assets/logo2.png"),
          title: Text(
            products[index].name,
            style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
          ),
          subtitle: Text(
            products[index].price.toString() + products[index].unit,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 15.0),
          ),
          isThreeLine: false,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.navigate_next,
                  color: Colors.blue,
                ),
                onTap: () {
                  //_delete(context, products[index]);
                },
              ),
            ],
          ),
          onTap: () {
            debugPrint("ListTile Tapped");
            navigateToDetail(products[index], 'Product Details');
          },
        ),
      ),
    );
  }

  void navigateToDetail(Product product, String title) async {
    await Navigator.pushNamed(context, '/product_detail',
        arguments: ProductDetail(
          product,
          title,
        ));
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
    setState(() {
      productsDb.getProducts();
    });
  }

  void _onLoading() async {
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }
}
