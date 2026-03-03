List<ProductModel> productsFromJson(dynamic str) =>
  List<ProductModel>.from((str).map((x) => ProductModel.fromJson(x)));

class ProductModel {
  int? productId;
  String? productName;
  String? description;
  String? price;
  String? regularPrice;
  String? salePrice;

  List<ImageModel>? images;

  ProductModel(
    this.productId,
    this.productName,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.images,
  );

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['id'];
    productName = json['name'];
    description = json['short_description']
      .toString()
      .replaceAll(RegExp(r'<\/?[^>]+>'), ''); // remove html tags
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];

    // check if image is received
    if(json['images'] != null){
      images = List<ImageModel>.empty(growable: true);
      json['images'].forEach(
        (v) {
          images!.add(ImageModel.fromJson(v));
        }
      );
    }
  }
}


class ImageModel{
  String? url;

  ImageModel({this.url});

  ImageModel.fromJson(Map<String, dynamic> json){
    url = json['src'];
  }
}