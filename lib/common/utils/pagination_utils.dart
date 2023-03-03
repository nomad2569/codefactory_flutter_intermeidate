import 'package:codefactory_intermediate/common/provider/paginate_provider.dart';
import 'package:flutter/material.dart';

class PaginationUtils {
  static void paginate(
      {required ScrollController scrollController,
      required PaginationProvider provider}) {
    if (scrollController.offset >
        scrollController.position.maxScrollExtent - 300) {
      provider.paginate(
        fetchMore: true,
      );
    }
  }
}
