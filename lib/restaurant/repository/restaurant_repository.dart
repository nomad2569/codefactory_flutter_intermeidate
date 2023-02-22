import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../common/const/data.dart';

part 'restaurant_repository.g.dart';

@RestApi()
// 무조건 `abstract` 로 생성해야함
abstract class RestaurantRepository {
  // baseUrl 예시 : http:$baseIp:$basePort/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // ---- 여기까지는 retrofit 의 기본 틀이라고 보면 됨
  // ---- dio, baseUrl 의 역할이 무엇인지는 알아야 함

  // abstract class 이므로, 실제 함수의 body 를 작성하지는 않음.

  // GET http:$baseIp:$basePort/restaurant/
  @GET('/')
  paginate();

  // GET http:$baseIp:$basePort/restaurant/:id
  // path 변수 : id
  @GET('/{id}')
  getRestaurantDetail();
}
