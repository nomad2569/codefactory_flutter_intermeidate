import 'package:codefactory_intermediate/restaurant/model/restaurant_detail_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_order_body.g.dart';

@JsonSerializable(explicitToJson: true)
class PostOrderBody {
  final String id;
  final List<ProductIdWithCountModel> products;
  final int totalPrice;
  final String createdAt;
  PostOrderBody({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.createdAt,
  });
  factory PostOrderBody.fromJson(final Map<String, dynamic> json) =>
      _$PostOrderBodyFromJson(json);
  Map<String, dynamic> toJson() => _$PostOrderBodyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductIdWithCountModel {
  final String productId;
  final int count;
  ProductIdWithCountModel({
    required this.productId,
    required this.count,
  });
  factory ProductIdWithCountModel.fromJson(final Map<String, dynamic> json) =>
      _$ProductIdWithCountModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductIdWithCountModelToJson(this);
}
