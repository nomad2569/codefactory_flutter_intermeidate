// import 'package:codefactory_intermediate/common/utils/data_utils.dart';
// import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
// import 'package:json_annotation/json_annotation.dart';

// part "product_model.g.dart";

// @JsonSerializable()
// class ProductModel {
//   final String id;
//   final String name;
//   final String detail;
//   @JsonKey(
//     fromJson: DataUtils.pathConcatThumbUrl,
//   )
//   final String imgUrl;
//   final int price;
//   final RestaurantModel restaurant;
//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.detail,
//     required this.imgUrl,
//     required this.price,
//     required this.restaurant,
//   });
//   factory ProductModel.fromJson(final Map<String, dynamic> json) =>
//       _$ProductModelFromJson(json);
//   Map<String, dynamic> toJson() => _$ProductModelToJson(this);
// }
