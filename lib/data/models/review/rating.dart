import 'dart:convert';
import 'package:zili_coffee/data/models/review/review.dart';
import 'package:zili_coffee/data/models/user/user.dart';

class Rating {
  final int total;
  final int totalRecords;
  final int totalStar1;
  final int totalStar2;
  final int totalStar3;
  final int totalStar4;
  final int totalStar5;
  final double? avgStar;
  final List<Review> reviews;
  Rating({
    required this.total,
    required this.totalRecords,
    required this.totalStar1,
    required this.totalStar2,
    required this.totalStar3,
    required this.totalStar4,
    required this.totalStar5,
    this.avgStar,
    this.reviews = const [],
  });

  static Rating get rating => Rating(
        total: 16,
        totalRecords: 2,
        totalStar1: 0,
        totalStar2: 0,
        totalStar3: 0,
        totalStar4: 4,
        totalStar5: 12,
        avgStar: 4.7,
        reviews: [
          Review(
            id: 1,
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            topicSentence: 'Shope xịn',
            customer: User(
              id: "12",
              name: "Kita Chihoko",
              email: "nts.sinhdo@gmail.com",
              phone: "0329934096",
            ),
            score: 4,
            likeCount: 20,
            disLikeCount: 2,
            postDate: DateTime.now(),
          ),
          Review(
            id: 2,
            topicSentence: 'Dịch vụ rất tốt',
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            customer: User(
              id: "12",
              name: "Jennetsu Amado",
              email: "nts.sinhdo@gmail.com",
              phone: "0329934096",
            ),
            score: 5,
            postDate: DateTime.now(),
          ),
          Review(
            id: 1,
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            topicSentence: 'Phục vụ tốt',
            customer: User(
              id: "12",
              name: "Hashibira Inosuke",
              email: "nts.sinhdo@gmail.com",
              phone: "0329934096",
            ),
            score: 4,
            likeCount: 20,
            disLikeCount: 2,
            postDate: DateTime.now(),
            replyReviews: ["1"],
          ),
          Review(
            id: 1,
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            topicSentence: 'WOW! Quá tuyệt vời!',
            customer: User(
              id: "12",
              name: "Kita Chihoko",
              email: "nts.sinhdo@gmail.com",
              phone: "0329934096",
            ),
            score: 4,
            likeCount: 20,
            disLikeCount: 2,
            postDate: DateTime.now(),
          ),
          Review(
            id: 1,
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            topicSentence: 'WOW! Quá tuyệt vời!',
            customer: User(
              id: "12",
              name: "Inube",
              email: "nts.sinhdo@gmail.com",
              phone: "0329934096",
            ),
            score: 4,
            postDate: DateTime.now(),
          ),
          Review(
            id: 1,
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            topicSentence: 'WOW! Quá tuyệt vời!',
            customer: User(
              id: "12",
              name: "Kita Chihoko",
              email: "nts.sinhdo@gmail.com",
              phone: "0329934096",
            ),
            score: 4,
            postDate: DateTime.now(),
          ),
          Review(
            id: 1,
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            topicSentence: 'WOW! Quá tuyệt vời!',
            customer: User(
              id: "12",
              name: "Kita Chihoko",
              email: "nts.sinhdo@gmail.com",
              phone: "0329934096",
            ),
            score: 4,
            postDate: DateTime.now(),
          ),
          Review(
            id: 1,
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            topicSentence: 'WOW! Quá tuyệt vời!',
            customer: User(
              id: "12",
              name: "Kita Chihoko",
              email: "nts.sinhdo@gmail.com",
              phone: "0329934096",
            ),
            score: 4,
            postDate: DateTime.now(),
          ),
          Review(
            id: 1,
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
            topicSentence: 'WOW! Quá tuyệt vời!',
            customer: User(
              id: "12",
              name: "Kita Chihoko",
              email: "nts.sinhdo@gmail.com",
              phone: "0329934096",  
            ),
            score: 4,
            postDate: DateTime.now(),
          ),
        ],
      );

  Rating copyWith({
    int? total,
    int? totalRecords,
    int? totalStar1,
    int? totalStar2,
    int? totalStar3,
    int? totalStar4,
    int? totalStar5,
    double? avgStar,
    List<Review>? reviews,
  }) {
    return Rating(
      total: total ?? this.total,
      totalRecords: totalRecords ?? this.totalRecords,
      totalStar1: totalStar1 ?? this.totalStar1,
      totalStar2: totalStar2 ?? this.totalStar2,
      totalStar3: totalStar3 ?? this.totalStar3,
      totalStar4: totalStar4 ?? this.totalStar4,
      totalStar5: totalStar5 ?? this.totalStar5,
      avgStar: avgStar ?? this.avgStar,
      reviews: reviews ?? this.reviews,
    );
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      total: map['total'] as int,
      totalRecords: map['total'] as int,
      totalStar1: map['totalStar1'] as int,
      totalStar2: map['totalStar2'] as int,
      totalStar3: map['totalStar3'] as int,
      totalStar4: map['totalStar4'] as int,
      totalStar5: map['totalStar5'] as int,
      avgStar: map['avgStar'] != null
          ? double.parse(map['avgStar'].toString())
          : null,
    );
  }

  factory Rating.fromJson(String source) =>
      Rating.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Rating(total: $total, totalRecords: $totalRecords, totalStar1: $totalStar1, totalStar2: $totalStar2, totalStar3: $totalStar3, totalStar4: $totalStar4, totalStar5: $totalStar5, avgStart: $avgStar, reviews: $reviews)';
  }
}
