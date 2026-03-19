// import 'dart:convert';

// import 'package:intl/intl.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final bool isSeen;
  // String type;
  // String imageUrl;
  // String link;
  // DateTime dateStart;
  final DateTime date;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    this.isSeen = true,
    // required this.type,
    // required this.imageUrl,
    // required this.link,
    // required this.dateStart,
    required this.date,
  });

  static List<NotificationModel> get data => [
        NotificationModel(
          id: 1,
          message:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
          title: "Nguyễn Hữu Cảnh",
          date: DateTime.now(),
          isSeen: false,
        ),
        NotificationModel(
          id: 2,
          message:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
          title: "Nguyễn Thị Thu Huyền",
          date: DateTime.now(),
        ),
        NotificationModel(
          id: 3,
          message:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
          title: "Phạm Huyền Trang",
          date: DateTime.now().copyWith(day: 24),
        ),
        NotificationModel(
          id: 4,
          message:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
          title: "Trương Bá Thái",
          date: DateTime.now().copyWith(day: 22),
        ),
        NotificationModel(
          id: 5,
          message:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
          title: "Dương Thanh Nhàn",
          date: DateTime.now().copyWith(day: 22),
        ),
      ];

  // NotificationModel copyWith({
  //   int? id,
  //   String? title,
  //   String? message,
  //   String? type,
  //   String? imageUrl,
  //   String? link,
  //   DateTime? dateStart,
  //   DateTime? dateEnd,
  // }) {
  //   return NotificationModel(
  //     id: id ?? this.id,
  //     title: title ?? this.title,
  //     message: message ?? this.message,
  //     // type: type ?? this.type,
  //     // imageUrl: imageUrl ?? this.imageUrl,
  //     // link: link ?? this.link,
  //     dateStart: dateStart ?? this.dateStart,
  //     dateEnd: dateEnd ?? this.dateEnd,
  //   );
  // }

  // factory NotificationModel.fromMap(Map<String, dynamic> map) {
  //   return NotificationModel(
  //     id: map['id'] as int,
  //     title: map['title'] as String,
  //     message: map['message'] as String,
  //     // type: map['type'] as String,
  //     // imageUrl: map['image_url'] as String,
  //     // link: map['link'] as String,
  //     dateStart: DateFormat("yyyy-MM-dd").parse(map['date_start'] as String),
  //     dateEnd: DateFormat("yyyy-MM-dd").parse(map['date_start'] as String),
  //   );
  // }

  // factory NotificationModel.fromJson(String source) =>
  //     NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
