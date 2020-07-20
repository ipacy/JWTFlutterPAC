import 'package:flutter_guid/flutter_guid.dart';

class Product {
  Guid id;
  String name;
  String unit;
  double price;

  Product(this.id, this.name, this.unit, this.price) {
    this.id = id;
    this.name = name;
    this.unit = unit;
    this.price = price;
  }

  Product.fromJson(Map json)
      : id = new Guid(json['id']),
        name = json['name'],
        unit = json['unit'],
        price = json['price'].toDouble();

  Map toJson() {
    return {'id': id, 'name': name, 'unit': unit, 'price': price};
  }
}
