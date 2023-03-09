import 'package:codefactory_intermediate/common/utils/data_utils.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderProductModel {
  final String id;
  final String name;
  final String detail;
  @JsonKey(
    fromJson: DataUtils.pathConcatThumbUrl,
  )
  final String imgUrl;
  final int price;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
  });

  factory OrderProductModel.fromJson(final Map<String, dynamic> json) =>
      _$OrderProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);
}

@JsonSerializable()
class OrderProductAndCountModel {
  final OrderProductModel product;
  final int count;

  OrderProductAndCountModel({
    required this.product,
    required this.count,
  });

  factory OrderProductAndCountModel.fromJson(final Map<String, dynamic> json) =>
      _$OrderProductAndCountModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductAndCountModelToJson(this);
}

@JsonSerializable()
class OrderModel {
  final String id;
  final List<OrderProductAndCountModel> products;
  final int totalPrice;
  final RestaurantModel restaurant;
  @JsonKey(
    fromJson: DataUtils.stringToDateTime,
  )
  final DateTime createdAt;
  OrderModel({
    required this.id,
    required this.products,
    required this.restaurant,
    required this.totalPrice,
    required this.createdAt,
  });
  factory OrderModel.fromJson(final Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
