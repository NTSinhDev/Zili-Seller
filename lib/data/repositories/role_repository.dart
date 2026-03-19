import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '../models/seller/role.dart';
import 'base_repository.dart';

class RoleRepository extends BaseRepository {
  final BehaviorSubject<List<Role>> roles = BehaviorSubject();
  int totalRoles = 0;

  @override
  Future<void> clean() async {
    roles.drain(null);
    roles.sink.add([]);
    totalRoles = 0;
  }
}

