import 'package:equatable/equatable.dart';
import 'package:zili_coffee/bloc/base_cubit.dart';
import 'package:zili_coffee/data/middlewares/middlewares.dart';
import 'package:zili_coffee/data/models/notification.dart';
import 'package:zili_coffee/data/network/network_response_state.dart';

part 'notification_state.dart';

class NotificationCubit extends BaseCubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  Future getNotifications() async {
    emit(GettingNotificationState());
    final result = await AppMiddleware().getNotifications();
    if (result is ResponseSuccessState<List<NotificationModel>>) {
      emit(GotNotificationsState(notifications: result.responseData));
    } else if (result is ResponseFailedState) {
      emit(const GotNotificationsState(notifications: []));
    }
  }
}
