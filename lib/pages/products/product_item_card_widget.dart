import 'package:flutter/material.dart';
import 'package:woocommerce_app/models/products_item.dart';
import 'package:woocommerce_app/utils/colors.dart';

class ProductItemCardWidget extends StatelessWidget {
  const ProductItemCardWidget({super.key, required this.item});

  final ProductModel item;
  
  final double width = 170;
  final double height = 250;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: 75,
              width: MediaQuery.sizeOf(context).width,
              child: item.images!.isNotEmpty ? Image.network(item.images![0].url.toString()) : SizedBox(),
            ),

            SizedBox(height: 10,), // spacing

            Text(
              item.productName!, 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5,), // spacing

            Row(
              children: [
                Text(
                  "\$${item.price}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                Spacer(),
                addWidget(),
              ],
            ),
          ]
        ),
      ),
    );
  }

  Widget addWidget(){
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: AppColors.primaryColor,
      ),
      child: Center(
        child: Icon(
          Icons.add, 
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}