import 'package:codefactory_intermediate/common/dio/dio.dart';
import 'package:codefactory_intermediate/common/model/cursor_pagination_model.dart';
import 'package:codefactory_intermediate/common/model/pagination_params.dart';
import 'package:codefactory_intermediate/common/repository/base_pagination_repository.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_detail_model.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';

part 'restaurant_repository.g.dart';

final RestaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository =
      RestaurantRepository(dio, baseUrl: 'http://$baseIp:$basePort/restaurant');

  return repository;
});

@RestApi()
// 무조건 `abstract` 로 생성해야함
abstract class RestaurantRepository
    implements IBasePaginationRepository<RestaurantModel> {
  // baseUrl 예시 : http:$baseIp:$basePort/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // ---- 여기까지는 retrofit 의 기본 틀이라고 보면 됨
  // ---- dio, baseUrl 의 역할이 무엇인지는 알아야 함

  // abstract class 이므로, 실제 함수의 body 를 작성하지는 않음.
  // 작성해야할 것은 오직
  // 1. 요청에 필요한 정보들 (Headers...)
  // 2. 반환될 Model (단, response 의 구조와 `완벽히` 같아야함)

  // GET http:$baseIp:$basePort/restaurant/
  @GET('/')
  // dio interceptor 에서 미리 정해둔 syntax
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
