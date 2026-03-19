part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class GettingNotificationState extends NotificationState {}

class GotNotificationsState extends NotificationState {
  final List<NotificationModel> notifications;
  const GotNotificationsState({required this.notifications});
}

class FailedGotNotificationsState extends NotificationState {}