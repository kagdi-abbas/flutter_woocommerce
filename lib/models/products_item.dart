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
  List<int>? relatedIds;

  ProductModel({
    this.productId,
    this.productName,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.images,
    this.relatedIds,
  });

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
    if(json['cross_sell_ids'] != null) {
      relatedIds = json['cross_sell_ids'].cast<int>();
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