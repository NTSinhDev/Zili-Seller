import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/models/review/rating.dart';
import 'package:zili_coffee/data/models/review/review.dart';
import 'package:zili_coffee/data/repositories/base_repository.dart';

class ReviewRepository extends BaseRepository {
  final BehaviorSubject<Rating?> behaviorRating = BehaviorSubject();
  final BehaviorSubject<List<Review>> behaviorReviews = BehaviorSubject();
  final BehaviorSubject<String> filterByTypeStreamData = BehaviorSubject();
  final BehaviorSubject<String> filterByStarStreamData = BehaviorSubject();
  List<Review> allReviews = [];
  List<Review> imageReviews = [];
  List<Review> videoReviews = [];
  int toolbarIndex = 0;

  void addToStream(Rating rating) {
    behaviorRating.sink.add(rating);
    final List<Review> reviews = rating.reviews;
    behaviorReviews.sink.add(reviews);
    allReviews = reviews;
  }

  Product? currentProduct;

  String? yourFeedback;

  @override
  Future<void> clean() async {}
}
