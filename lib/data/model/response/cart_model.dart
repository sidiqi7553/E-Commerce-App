import 'package:emarket_user/data/model/response/product_model.dart';

class CartModel {
  double _price;
  double _discountedPrice;
  List<Variation> _variation;
  double _discountAmount;
  int _quantity;
  double _taxAmount;
  int _maxQty;
  Product _product;

  CartModel(
        double price,
        double discountedPrice,
        List<Variation> variation,
        double discountAmount,
        int quantity,
        double taxAmount,
        int maxQty,
        Product product) {
    this._price = price;
    this._discountedPrice = discountedPrice;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._maxQty = maxQty;
    this._product = product;
  }

  double get price => _price;
  double get discountedPrice => _discountedPrice;
  List<Variation> get variation => _variation;
  double get discountAmount => _discountAmount;
  // ignore: unnecessary_getters_setters
  int get quantity => _quantity;
  // ignore: unnecessary_getters_setters
  set quantity(int qty) => _quantity = qty;
  double get taxAmount => _taxAmount;
  int get maxQty => _maxQty;
  Product get product => _product;

  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();
    _discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    _maxQty = json['max_qty'];
    if (json['product'] != null) {
      _product = Product.fromJson(json['product']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this._price;
    data['discounted_price'] = this._discountedPrice;
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['max_qty'] = this._maxQty;
    data['product'] = this._product.toJson();
    return data;
  }
}
