import 'package:codefactory_intermediate/common/const/data.dart';
import 'package:codefactory_intermediate/restaurant/component/restaurant_card.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> PaginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final response = await dio.get('http://$baseIp:$basePort/restaurant',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));

    return response.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<List>(
        future: PaginateRestaurant(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          // 데이터가 없으면 빈 화면 출력
          if (!snapshot.hasData) {
            return Container();
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final item = snapshot.data![index];
              // 1. API 에서 받은 data 를 Model 로 변환
              final pItem = RestaurantModel.fromJSON(json: item);

              // 2. Model 을 기반으로 RestaurantCard 생성
              return RestaurantCard.fromModel(restaurantModel: pItem);
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
