//* dart 에서는 interface 가 따로 키워드는 없다. class 로 선언 가능
// * <T> generic 으로 받아올 데이터의 모델을 넘겨받는다.
import 'package:codefactory_intermediate/common/model/model_with_id.dart';

import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  // paginate 바디는 정의하지 않고 무조건 선언해야 한다고 한다.
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
