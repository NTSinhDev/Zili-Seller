import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../models/payment/collaborator.dart';
import 'base_repository.dart';

class CollaboratorRepository extends BaseRepository {
  final BehaviorSubject<List<Collaborator>> collaborators = BehaviorSubject();

  void setCollaborators(List<Collaborator> data) {
    collaborators.sink.add(data);
  }

  @override
  Future<void> clean() async {
    collaborators.drain(null);
    collaborators.sink.add([]);
  }
}
