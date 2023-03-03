// 이 모델을 implement 하는 class 모두는 `id` 값을 가져야 한다.
abstract class IModelWithId {
  final String id;
  IModelWithId({required this.id});
}
