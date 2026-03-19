import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';
import 'package:zili_coffee/data/models/seller/role.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';
import 'package:zili_coffee/data/repositories/role_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';

part 'role_state.dart';

class RoleCubit extends BaseCubit<RoleState> {
  RoleCubit() : super(RoleInitial());

  final _roleMiddleware = di<RoleMiddleware>();
  final _roleRepo = di<RoleRepository>();

  /// Get list of seller roles
  ///
  /// Parameters:
  /// - limit: Number of items per page (default: 8)
  /// - offset: Pagination offset (default: 0)
  ///
  /// States:
  /// - LoadingRoleState: Loading
  /// - LoadedRoleState: Success with data
  /// - FailedRoleState: Error
  Future<void> getSellerRoles({
    int limit = 8,
    int offset = 0,
  }) async {
    emit(const LoadingRoleState());
    final result = await _roleMiddleware.getSellerRoles(
      limit: limit,
      offset: offset,
    );
    if (result is ResponseSuccessListState<List<Role>>) {
      final items = result.responseData;
      _roleRepo.roles.sink.add(items);
      _roleRepo.totalRoles = result.total;
      emit(LoadedRoleState());
    } else if (result is ResponseFailedState) {
      emit(FailedRoleState(error: result));
    }
  }
}

