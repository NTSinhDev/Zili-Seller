import 'package:equatable/equatable.dart';

import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/collaborator_middleware.dart';
import 'package:zili_coffee/data/models/payment/collaborator.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/collaborator_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

part 'collaborator_state.dart';

class CollaboratorCubit extends BaseCubit<CollaboratorState> {
  CollaboratorCubit() : super(CollaboratorInitial());

  final _middleware = di<CollaboratorMiddleware>();
  final _repository = di<CollaboratorRepository>();

  Future<void> fetchCollaborators({
    List<String>? status,
    String? event,
  }) async {
    emit(CollaboratorLoadingState(event: event ?? 'fetch'));
    final result = await _middleware.getCollaborators(status: status);

    if (result is ResponseSuccessState<List<Collaborator>>) {
      _repository.setCollaborators(result.responseData);
      emit(CollaboratorLoadedState(result.responseData));
    } else if (result is ResponseFailedState) {
      emit(CollaboratorErrorState(error: result));
    } else {
      emit(const CollaboratorErrorState());
    }
  }
}

