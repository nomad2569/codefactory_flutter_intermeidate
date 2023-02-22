import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/common/dio/dio.dart';
import 'package:codefactory_intermediate/restaurant/component/restaurant_card.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:codefactory_intermediate/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List<RestaurantModel>> PaginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(
      storage: storage,
    ));

    final res = await RestaurantRepository(dio,
            baseUrl: 'http://$baseIp:$basePort/restaurant')
        .paginate();

    return res.data;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<List<RestaurantModel>>(
        future: PaginateRestaurant(),
        builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
          // 데이터가 없으면 빈 화면 출력
          if (!snapshot.hasData) {
            return Container();
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final item = snapshot.data![index];
              // repo 결과인 Model 을 기반으로 RestaurantCard 생성
              return RestaurantCard.fromModel(restaurantModel: item);
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 16,
              );
            },
          );
        },
      ),
    );
  }
}
