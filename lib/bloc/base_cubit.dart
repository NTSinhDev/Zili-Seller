import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

enum BaseEvent { refresh, search, loadMore, fetch, post }

abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  @override
  Future<void> close() {
    log('Cubit: ${toString()} closed');
    return super.close();
  }

  @override
  void onChange(Change<State> change) {
    super.onChange(change);

    log(
      '🐞$change',
      name: "Cubit",
      level: 1000,
      sequenceNumber: 100,
      time: DateTime.now(),
    );
  }
}
