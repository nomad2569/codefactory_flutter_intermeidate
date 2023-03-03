import 'package:codefactory_intermediate/rating/model/rating_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:collection/collection.dart';
import '../../common/const/colors.dart';

class RatingCard extends StatelessWidget {
  // Network Image, Asset Image widget 같은 것들
  // CircleAvatar 받을 것
  final ImageProvider avatarImage;
  // 리스트로 위젯 이미지를 보여줄 때
  final List<Image> images;
  // 별점
  final int rating;
  // 이메일
  final String email;
  // 리뷰 내용
  final String content;
  const RatingCard({
    super.key,
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
  });

  factory RatingCard.fromModel({required RatingModel ratingModel}) {
    return RatingCard(
      avatarImage: NetworkImage(ratingModel.user.imageUrl),
      images: ratingModel.imgUrls.map((e) => Image.network(e)).toList(),
      rating: ratingModel.rating,
      email: ratingModel.user.username,
      content: ratingModel.content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          rating: rating,
          email: email,
        ),
        const SizedBox(
          height: 8.0,
        ),
        _Body(
          content: content,
        ),
        if (images.isNotEmpty)
          SizedBox(
            height: 100,
            child: _Images(
              images: images,
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;
  const _Header({
    super.key,
    required this.avatarImage,
    required this.rating,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12.0,
                  backgroundImage: avatarImage,
                ),
                Expanded(
                  child: Text(email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border_outlined,
                    color: PRIMARY_COLOR,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String content;
  const _Body({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // * `Flexible` 긴 글을 넣을 때, 화면을 벗어나지 않고 다음 줄로 자동 줄바꿈이 되기 위해서 사용하는
        Flexible(
            child: Text(
          content,
          style: TextStyle(
            fontSize: 14,
          ),
        )),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;
  const _Images({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      // * 좌우측으로 스크롤 가능
      scrollDirection: Axis.horizontal,
      // dart 의 `map` 은 index 를 받을 수는 없다.
      // * extension 을 활용해서 할 수 있다.
      // * import 'package:collection/collection.dart';
      // * 를 import 하면 `mapIndexed` 를 사용해서 받을 수 있다.
      children: images
          .mapIndexed(
            (index, e) => Padding(
              padding: EdgeInsets.only(
                right: index != images.length - 1 ? 16.0 : 0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: e,
              ),
            ),
          )
          .toList(),
    );
  }
}
