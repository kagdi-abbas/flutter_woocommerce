import 'package:flutter/material.dart';
import 'package:woocommerce_app/api/api_service.dart';
import 'package:woocommerce_app/models/products_item.dart';

class RelatedProducts extends StatefulWidget {
  RelatedProducts({super.key, required this.products, required this.title});
  final List<int> products;
  final String title;

  @override
  State<RelatedProducts> createState() => _RelatedProductsState();
}

class _RelatedProductsState extends State<RelatedProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(left:15, bottom: 8, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 5,),
            _productsList(),
          ],
        ),
      ),
    );
  }

  Widget _productsList() {
    return FutureBuilder(
      future: APIService.getProducts(productIds: widget.products),
      builder: (context, AsyncSnapshot<List<ProductModel>?> model){
        if(model.hasData){
          return _buildList(model.data!);
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Widget _buildList(List<ProductModel> items){
    return Container(
      height: 230,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var data = items[index];
          return GestureDetector(
            onTap: () {

            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProductImage(data),
                _buildProductName(data),
                _buildProductPrice(data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(ProductModel data){
    return Container(
      margin: EdgeInsets.all(8),
      height: 120,
      width: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 5),
            blurRadius: 15,
          ),
        ]
      ),
      child: Image.network(
        data.images![0].url.toString(),
        height: 120,
      ),
    ); 
  }

  Widget _buildProductName(ProductModel data){
    return Container(
      width: 120,
      alignment: Alignment.centerLeft,
      child: Text(
        data.productName!,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildProductPrice(ProductModel data){
   return Container(
      width: 120,
      alignment: Alignment.centerLeft,
      child: Text(
        "\$ ${data.price!}",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}