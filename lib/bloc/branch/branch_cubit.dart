import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';

import '../../data/middlewares/middlewares.dart';
import '../../data/models/warehouse/warehouse.dart';
import '../../data/repositories/warehouse_repository.dart';
import '../../di/dependency_injection.dart';

part 'branch_state.dart';

class BranchCubit extends BaseCubit<BranchState> {
  BranchCubit() : super(BranchInitial());

  final WarehouseMiddleware _warehouseMiddleware = di<WarehouseMiddleware>();
  final WarehouseRepository _warehouseRepository = di<WarehouseRepository>();

  Future<void> getAllWarehouses({int limit = 100, int offset = 0}) async {
    emit(LoadingBranchState());
    final result = await _warehouseMiddleware.getSellerWarehouses(
      limit: limit,
      offset: offset,
    );

    if (result is ResponseSuccessState<List<Warehouse>>) {
      final warehouses = result.responseData;
      _warehouseRepository.warehouseSubject.sink.add(warehouses);
      emit(LoadedBranchState());
    } else {
      emit(FailedLoadBranchState());
    }
  }
}
