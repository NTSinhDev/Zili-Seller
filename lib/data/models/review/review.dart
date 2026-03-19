import 'package:zili_coffee/data/models/user/user.dart';

class Review {
  final int id;
  final User customer;
  final String? topicSentence;
  final String? content;
  final double score;
  final int? likeCount;
  final int? disLikeCount;
  final DateTime postDate;
  final List<dynamic> replyReviews;
  Review({
    required this.id,
    required this.customer,
    required this.topicSentence,
    required this.content,
    required this.score,
    this.likeCount,
    this.disLikeCount,
    required this.postDate,
    this.replyReviews = const [],
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as int,
      topicSentence: map['message'] != null ? map['message'] as String : null,
      content: map['message'] != null ? map['message'] as String : null,
      customer: map['customer'] == null
          ? User(
              id: map['customer_id'] ?? '',
              name: map['name'],
            )
          : User.fromMap(map["customer"]),
      score: double.parse(map['totalStar'].toString()),
      postDate: DateTime.parse(map['createdAt']),
      replyReviews: List<dynamic>.from((map['reply_reviews'] as List<dynamic>)),
    );
  }
}
