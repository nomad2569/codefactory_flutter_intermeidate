import 'package:codefactory_intermediate/common/model/model_with_id.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/data_utils.dart';

part 'restaurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<ProductModel> products;
  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailModelFromJson(json);
}

@JsonSerializable()
class ProductModel implements IModelWithId {
  final String id;
  final RestaurantModel restaurant;
  final String name;
  final String detail;
  @JsonKey(
    fromJson: DataUtils.pathConcatThumbUrl,
  )
  final String imgUrl;
  final int price;

  ProductModel({
    required this.id,
    required this.restaurant,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
