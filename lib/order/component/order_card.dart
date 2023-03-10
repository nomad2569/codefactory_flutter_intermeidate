import 'package:codefactory_intermediate/order/model/order_model.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.network(order.restaurant.thumbUrl,
              width: 50.0, height: 50.0, fit: BoxFit.cover),
        ),
        Column(
          children: [
            Text(order.restaurant.name),
            Text(order.products[0].product.name),
          ],
        )
      ],
    );
  }
}
