import 'package:codefactory_intermediate/common/model/cursor_pagination_model.dart';
import 'package:codefactory_intermediate/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantRatingStateNotifier
    extends StateNotifier<CursorPaginationBase> {
  final RestaurantRatingRepository repository;

  RestaurantRatingStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading());
}
