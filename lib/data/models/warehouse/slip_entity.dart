import 'package:flutter/material.dart';

import '../user/created_by.dart';

class SlipEntity {
  final String id;
  final String code;
  final String status;
  final String createdAt;
  final String? updatedAt;
  final String? note;
  final CreatedBy? referencePerson;

  SlipEntity({
    required this.id,
    required this.code,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.note,
    this.referencePerson
  }) {
    statusLabel = null;
  }

  String? statusLabel;
  Color? statusLabelColor;
  Color? cardColor;
  List<MapEntry<String, String>>? infoRows;
}
