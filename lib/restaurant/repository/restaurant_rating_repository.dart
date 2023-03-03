import 'package:codefactory_intermediate/common/dio/dio.dart';
import 'package:codefactory_intermediate/common/repository/base_pagination_repository.dart';
import 'package:codefactory_intermediate/rating/model/rating_model.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/pagination_params.dart';

part 'restaurant_rating_repository.g.dart';

final RestaurantRatingRepositoryProvider =
    Provider.family<RestaurantRatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);

  return RestaurantRatingRepository(dio,
      baseUrl: 'http://$baseIp:$basePort/$id/rating');
});

// baseUrl: http://baseIp:basePort/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository
    implements IBasePaginationRepository<RestaurantModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/')
  // dio interceptor 에서 미리 정해둔 syntax
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
