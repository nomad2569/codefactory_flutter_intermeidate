import 'package:codefactory_intermediate/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String username;
  @JsonKey(
    fromJson: DataUtils.pathConcatThumbUrl,
  )
  final String imageUrl;
  UserModel({
    required this.id,
    required this.username,
    required this.imageUrl,
  });

  factory UserModel.fromJson(final Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
