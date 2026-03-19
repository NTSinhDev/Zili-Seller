import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/blog/blog.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';
import 'package:zili_coffee/data/models/blog/blog_category.dart';

class BlogRepository extends BaseRepository {
  final BehaviorSubject<List<BlogCategory>> blogCategoryStreamData = BehaviorSubject<List<BlogCategory>>();
  final BehaviorSubject<List<Blog>> blogStreamData = BehaviorSubject<List<Blog>>();
  @override
  Future<void> clean() async {}
}
