import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:car_app_beta/src/app.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  // @pragma("vm:entry-point")
  // static Future<void> onActionReceivedMethod(
  //     ReceivedAction receivedAction) async {
  //   MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //       '/notification-page',
  //       (route) =>
  //           (route.settings.name != '/notification-page') || route.isFirst,
  //       arguments: receivedAction);
  // }
}
