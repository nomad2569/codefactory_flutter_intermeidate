import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:codefactory_intermediate/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RestaurantCard extends StatelessWidget {
  final Image image;
  final String title;
  final List<String> tags;
  final double ratings;
  final int receipt;
  final int timelapse;
  final int delivFee;

  const RestaurantCard({
    super.key,
    required this.image,
    required this.title,
    required this.tags,
    required this.ratings,
    required this.receipt,
    required this.timelapse,
    required this.delivFee,
  });

  factory RestaurantCard.fromModel(
      {required final RestaurantModel restaurantModel}) {
    return RestaurantCard(
      image: Image.network(
        restaurantModel.thumbUrl,
      ),
      title: restaurantModel.name,
      tags: restaurantModel.tags,
      ratings: restaurantModel.ratings,
      receipt: restaurantModel.ratingsCount,
      timelapse: restaurantModel.deliveryTime,
      delivFee: restaurantModel.deliveryFee,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List IconsTexts = [
      {'icon': Icons.star, 'label': ratings.toString()},
      {'icon': Icons.receipt, 'label': receipt.toString()},
      {'icon': Icons.timelapse_outlined, 'label': timelapse.toString()},
      {
        'icon': Icons.monetization_on,
        'label': delivFee == 0 ? '무료' : delivFee.toString()
      },
    ];
    return Column(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(8.0), child: image),
        SizedBox(height: 16),
        Column(
          /*
          crossAxisAlignment 속성은 하위 항목이 열 내에서 수평으로 정렬되는 방식을 제어합니다.
          crossAxisAlignment를 CrossAxisAlignment.stretch로 설정하면 열 내의 사용 가능한 공간을 채우기 위해 하위 요소가 가로로 늘어납니다.
           */

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),
            Text(
              tags.join(' - '),
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 4),
            Row(children: [
              for (Map mapp in IconsTexts)
                Row(
                  children: [
                    _IconText(icon: mapp['icon'], label: mapp['label']),
                    SizedBox(width: 4),
                  ],
                )
            ])
          ],
        )
      ],
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconText({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Icon(icon, color: PRIMARY_COLOR, size: 14.0),
          SizedBox(width: 2.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
