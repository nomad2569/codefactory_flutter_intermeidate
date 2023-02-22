import 'package:codefactory_intermediate/common/const/colors.dart';
import 'package:codefactory_intermediate/common/layout/default_layout.dart';
import 'package:codefactory_intermediate/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;

  int currIndex = 0;
  @override
  void initState() {
    super.initState();

    // TabController 사용시 `SingleTickerProviderStateMixin` 을 무조건 사용해야함
    // 애니메이션 관련된 widget 은 이러는 경우가 있음.
    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      currIndex = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '홈 화면',
      child: TabBarView(
        // * TabBar 가로 스크롤 조정 가능
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          RestaurantScreen(),
          Center(child: Text('음식')),
          Center(child: Text('주문')),
          Center(child: Text('프로필')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 선택된 아이템 색상
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        // 애니메이션하려면 `shifting`
        type: BottomNavigationBarType.fixed,
        // `setState` 로 현재 tabIndex 를 지정한다.
        onTap: (int index) {
          controller.animateTo(index);
          //// currentIndex setState
          // setState(() {
          //   currIndex = index;
          // });
        },
        // 현재 Tab 의 index 정보 : `currentIndex`
        currentIndex: currIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.percent_outlined),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
