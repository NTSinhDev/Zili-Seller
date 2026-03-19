import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/category.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

class CategoryRepository extends BaseRepository {
  final BehaviorSubject<int> behaviorMinPrice = BehaviorSubject<int>();
  final BehaviorSubject<int> behaviorMaxPrice = BehaviorSubject<int>();

  final behaviorSelected = BehaviorSubject<List<Category>>();
  final BehaviorSubject<List<Category>> categories = BehaviorSubject();

  final BehaviorSubject<List<Category>> categoriesHome = BehaviorSubject();
  final BehaviorSubject<List<String>> featuredPrograms = BehaviorSubject();

  @override
  Future<void> clean() async {}
}
