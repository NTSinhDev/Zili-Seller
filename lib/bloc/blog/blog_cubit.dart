import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/blog_middleware.dart';
import 'package:zili_coffee/data/models/blog/blog.dart';
import 'package:zili_coffee/data/models/blog/blog_category.dart';
import 'package:zili_coffee/data/repositories/blog_repository.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

part 'blog_state.dart';

class BlogCubit extends BaseCubit<BlogState> {
  BlogCubit() : super(BlogInitial());

  final BlogMiddleware _blogMiddleware = di<BlogMiddleware>();
  final BlogRepository _blogRepository = di<BlogRepository>();

  Future<void> getBlogCategories() async {
    final result = await _blogMiddleware.getBlogCategories();
    if (result is ResponseSuccessState<List<BlogCategory>>) {
      _blogRepository.blogCategoryStreamData.sink.add(result.responseData);
    } else if (result is ResponseFailedState) {
      _blogRepository.blogCategoryStreamData.sink.add([]);
    }
  }

  Future<void> getBlogs() async {
    final result = await _blogMiddleware.getAllBlogs();
    if (result is ResponseSuccessState<List<Blog>>) {
      _blogRepository.blogStreamData.sink.add(result.responseData);
    } else if (result is ResponseFailedState) {
      _blogRepository.blogStreamData.sink.add([]);
    }
  }
}
