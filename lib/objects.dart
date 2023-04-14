import 'dart:convert';

import 'package:flutter/material.dart';


SizeChart sizeChartFromJson(String str) => SizeChart.fromJson(json.decode(str));

String sizeChartToJson(SizeChart data) => json.encode(data.toJson());

class SizeChart {
  SizeChart({
    required this.id,
    required this.name,
    required this.photo,
  });

  String id;
  String name;
  String photo;

  factory SizeChart.fromJson(Map<String, dynamic> json) => SizeChart(
    id: json["id"],
    name: json["name"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo": photo,
  };
}

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    required this.id,
    required this.name,
    required this.urlName,
    required this.active,
    required this.displayOrder,
    required this.metaTitle,
    required this.metaDescription,
  });

  int id;
  String name;
  String urlName;
  bool active;
  int displayOrder;
  String metaTitle;
  String metaDescription;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    urlName: json["url_name"],
    active: json["active"],
    displayOrder: json["display_order"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url_name": urlName,
    "active": active,
    "display_order": displayOrder,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
  };
}

Collection collectionFromJson(String str) => Collection.fromJson(json.decode(str));

String collectionToJson(Collection data) => json.encode(data.toJson());

class Collection {
  Collection({
    required this.id,
    required this.name,
    required this.urlName,
    required this.comingSoon,
    required this.bannerPhoto,
    required this.description,
    required this.active,
    required this.displayOrder,
    required this.metaTitle,
    required this.metaDescription,
    required this.shopBanner,
  });

  String id;
  String name;
  String urlName;
  bool comingSoon;
  String bannerPhoto;
  String description;
  bool active;
  int displayOrder;
  String metaTitle;
  String metaDescription;
  String shopBanner;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    id: json["id"],
    name: json["name"],
    urlName: json["url_name"],
    comingSoon: json["coming_soon"],
    bannerPhoto: json["banner_photo"],
    description: json["description"],
    active: json["active"],
    displayOrder: json["display_order"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    shopBanner: json["shop_banner"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url_name": urlName,
    "coming_soon": comingSoon,
    "banner_photo": bannerPhoto,
    "description": description,
    "active": active,
    "display_order": displayOrder,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "shop_banner": shopBanner,
  };
}

ShippingZone shippingZoneFromJson(String str) => ShippingZone.fromJson(json.decode(str));

String shippingZoneToJson(ShippingZone data) => json.encode(data.toJson());

class ShippingZone {
  ShippingZone({
    required this.id,
    required this.countryId,
    required this.name,
    required this.priceEgp,
    required this.priceUsd,
    required this.priceEur,
  });

  int id;
  int countryId;
  String name;
  int priceEgp;
  int priceUsd;
  int priceEur;

  factory ShippingZone.fromJson(Map<String, dynamic> json) => ShippingZone(
    id: json["id"],
    countryId: json["country_id"],
    name: json["name"],
    priceEgp: json["price_egp"],
    priceUsd: json["price_usd"],
    priceEur: json["price_eur"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "name": name,
    "price_egp": priceEgp,
    "price_usd": priceUsd,
    "price_eur": priceEur,
  };
}

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    required this.id,
    required this.categoryId,
    required this.collectionId,
    required this.sizingChartId,
    required this.name,
    required this.description,
    required this.urlName,
    required this.sku,
    required this.priceEgp,
    required this.priceUsd,
    required this.priceEur,
    required this.careInstructions,
    required this.composition,
    required this.metaTitle,
    required this.metaDescription,
    required this.discountEgp,
    required this.discountUsd,
    required this.discountEur,
    required this.active,
  });

  int id;
  int categoryId;
  int collectionId;
  int sizingChartId;
  String name;
  String description;
  String urlName;
  String sku;
  int priceEgp;
  int priceUsd;
  int priceEur;
  String careInstructions;
  String composition;
  String metaTitle;
  String metaDescription;
  int discountEgp;
  int discountUsd;
  double discountEur;
  bool active;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    categoryId: json["category_id"],
    collectionId: json["collection_id"],
    sizingChartId: json["sizing_chart_id"],
    name: json["name"],
    description: json["description"],
    urlName: json["url_name"],
    sku: json["sku"],
    priceEgp: json["price_egp"],
    priceUsd: json["price_usd"],
    priceEur: json["price_eur"],
    careInstructions: json["care_instructions"],
    composition: json["composition"],
    metaTitle: json["meta_title"],
    metaDescription: json["meta_description"],
    discountEgp: json["discount_egp"],
    discountUsd: json["discount_usd"],
    discountEur: json["discount_eur"]?.toDouble(),
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "collection_id": collectionId,
    "sizing_chart_id": sizingChartId,
    "name": name,
    "description": description,
    "url_name": urlName,
    "sku": sku,
    "price_egp": priceEgp,
    "price_usd": priceUsd,
    "price_eur": priceEur,
    "care_instructions": careInstructions,
    "composition": composition,
    "meta_title": metaTitle,
    "meta_description": metaDescription,
    "discount_egp": discountEgp,
    "discount_usd": discountUsd,
    "discount_eur": discountEur,
    "active": active,
  };
}

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.id,
    required this.currencyId,
    required this.referenceNumber,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerCountry,
    required this.customerAddress,
    required this.paymentMethod,
    required this.bookingDate,
    required this.status,
    required this.total,
    required this.productName,
    required this.specialRequest,
    required this.customerState,
    required this.customerCity,
    required this.customerZipCode,
    required this.totalInEgp,
    required this.customerZone,
    required this.shippingPrice,
    required this.discount,
    required this.couponCode,
  });

  int id;
  int currencyId;
  String referenceNumber;
  String customerName;
  String customerEmail;
  String customerPhone;
  String customerCountry;
  String customerAddress;
  String paymentMethod;
  DateTime bookingDate;
  String status;
  int total;
  String productName;
  String specialRequest;
  String customerState;
  String customerCity;
  String customerZipCode;
  int totalInEgp;
  String customerZone;
  int shippingPrice;
  int discount;
  String couponCode;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    currencyId: json["currency_id"],
    referenceNumber: json["reference_number"],
    customerName: json["customer_name"],
    customerEmail: json["customer_email"],
    customerPhone: json["customer_phone"],
    customerCountry: json["customer_country"],
    customerAddress: json["customer_address"],
    paymentMethod: json["payment_method"],
    bookingDate: DateTime.parse(json["booking_date"]),
    status: json["status"],
    total: json["total"],
    productName: json["product_name"],
    specialRequest: json["special_request"],
    customerState: json["customer_state"],
    customerCity: json["customer_city"],
    customerZipCode: json["customer_zip_code"],
    totalInEgp: json["total_in_egp"],
    customerZone: json["customer_zone"],
    shippingPrice: json["shipping_price"],
    discount: json["discount"],
    couponCode: json["coupon_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "currency_id": currencyId,
    "reference_number": referenceNumber,
    "customer_name": customerName,
    "customer_email": customerEmail,
    "customer_phone": customerPhone,
    "customer_country": customerCountry,
    "customer_address": customerAddress,
    "payment_method": paymentMethod,
    "booking_date": "${bookingDate.year.toString().padLeft(4, '0')}-${bookingDate.month.toString().padLeft(2, '0')}-${bookingDate.day.toString().padLeft(2, '0')}",
    "status": status,
    "total": total,
    "product_name": productName,
    "special_request": specialRequest,
    "customer_state": customerState,
    "customer_city": customerCity,
    "customer_zip_code": customerZipCode,
    "total_in_egp": totalInEgp,
    "customer_zone": customerZone,
    "shipping_price": shippingPrice,
    "discount": discount,
    "coupon_code": couponCode,
  };
}

OrderItem orderItemFromJson(String str) => OrderItem.fromJson(json.decode(str));

String orderItemToJson(OrderItem data) => json.encode(data.toJson());

class OrderItem {
  OrderItem({
    required this.id,
    required this.orderId,
    required this.productColorId,
    required this.size,
    required this.price,
    required this.quantity,
    required this.total,
  });

  int id;
  int orderId;
  int productColorId;
  String size;
  int price;
  int quantity;
  int total;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    orderId: json["order_id"],
    productColorId: json["product_color_id"],
    size: json["size"],
    price: json["price"],
    quantity: json["quantity"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "product_color_id": productColorId,
    "size": size,
    "price": price,
    "quantity": quantity,
    "total": total,
  };
}

ProductColor productColorFromJson(String str) => ProductColor.fromJson(json.decode(str));

String productColorToJson(ProductColor data) => json.encode(data.toJson());

class ProductColor {
  ProductColor({
    required this.id,
    required this.productId,
    required this.colorId,
    required this.mainPhoto,
    required this.modelInto,
    required this.modelPhoto,
    required this.name,
  });

  int id;
  int productId;
  int colorId;
  String mainPhoto;
  String modelInto;
  String modelPhoto;
  String name;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
    id: json["id"],
    productId: json["product_id"],
    colorId: json["color_id"],
    mainPhoto: json["main_photo"],
    modelInto: json["model_into"],
    modelPhoto: json["model_photo"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "color_id": colorId,
    "main_photo": mainPhoto,
    "model_into": modelInto,
    "model_photo": modelPhoto,
    "name": name,
  };
}

Size sizeFromJson(String str) => Size.fromJson(json.decode(str));

String sizeToJson(Size data) => json.encode(data.toJson());

class Size {
  Size({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.displayOrder,
  });

  int id;
  String name;
  String abbreviation;
  String displayOrder;

  factory Size.fromJson(Map<String, dynamic> json) => Size(
    id: json["id"],
    name: json["Name"],
    abbreviation: json["Abbreviation"],
    displayOrder: json["DisplayOrder"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Name": name,
    "Abbreviation": abbreviation,
    "DisplayOrder": displayOrder,
  };
}

ProductColorPhoto productColorPhotoFromJson(String str) => ProductColorPhoto.fromJson(json.decode(str));

String productColorPhotoToJson(ProductColorPhoto data) => json.encode(data.toJson());

class ProductColorPhoto {
  ProductColorPhoto({
    required this.id,
    required this.productColorId,
    required this.photo,
  });

  int id;
  int productColorId;
  String photo;

  factory ProductColorPhoto.fromJson(Map<String, dynamic> json) => ProductColorPhoto(
    id: json["id"],
    productColorId: json["product_color_id"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_color_id": productColorId,
    "photo": photo,
  };
}

ProductColorStock productColorStockFromJson(String str) => ProductColorStock.fromJson(json.decode(str));

String productColorStockToJson(ProductColorStock data) => json.encode(data.toJson());

class ProductColorStock {
  ProductColorStock({
    required this.productColorId,
    required this.sizeId,
    required this.stock,
  });

  int productColorId;
  int sizeId;
  int stock;

  factory ProductColorStock.fromJson(Map<String, dynamic> json) => ProductColorStock(
    productColorId: json["productColorId"],
    sizeId: json["sizeId"],
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "productColorId": productColorId,
    "sizeId": sizeId,
    "stock": stock,
  };
}

Color colorFromJson(String str) => Color.fromJson(json.decode(str));

String colorToJson(Color data) => json.encode(data.toJson());

class Color {
  Color({
    required this.id,
    required this.name,
    required this.hexaCode,
  });

  int id;
  String name;
  String hexaCode;

  factory Color.fromJson(Map<String, dynamic> json) => Color(
    id: json["id"],
    name: json["name"],
    hexaCode: json["HexaCode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "HexaCode": hexaCode,
  };
}

PairProductColor pairProductColorFromJson(String str) => PairProductColor.fromJson(json.decode(str));

String pairProductColorToJson(PairProductColor data) => json.encode(data.toJson());

class PairProductColor {
  PairProductColor({
    required this.mainId,
    required this.pairWithId,
  });

  int mainId;
  int pairWithId;

  factory PairProductColor.fromJson(Map<String, dynamic> json) => PairProductColor(
    mainId: json["mainId"],
    pairWithId: json["pairWithId"],
  );

  Map<String, dynamic> toJson() => {
    "mainId": mainId,
    "pairWithId": pairWithId,
  };
}




