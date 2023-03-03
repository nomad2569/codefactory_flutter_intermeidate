import 'package:codefactory_intermediate/rating/model/rating_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/pagination_params.dart';

part 'restaurant_rating_repository.g.dart';

// baseUrl: http://baseIp:basePort/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository {
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
