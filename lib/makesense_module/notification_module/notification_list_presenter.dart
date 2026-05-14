import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/makesense_module/notification_module/notification_list_view.dart';
import 'package:http/http.dart' as http;

class NotificationListPresenter {
  NotificationListView _notificationListView;

  NotificationListPresenter(this._notificationListView);

  notificationListApiCall() {
    MakesenseApiConfig.notificationApiCall(http.Client())
        .then((value) {
      this._notificationListView.notificationListSuccessRees(value);
    }).catchError((onError) {
      this._notificationListView.notiificationListError(onError);
    });
  }
}
