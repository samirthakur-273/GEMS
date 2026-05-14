import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/makesense_module/notification_count_module/notification_count_view.dart';
import 'package:http/http.dart' as http;

class NotificationCountPresenter {
  NotificationCountView notificationCountView;

  NotificationCountPresenter(this.notificationCountView);

  notificationCountsApiCall() {
    MakesenseApiConfig.notificationCountsApi(http.Client())
        .then((value) {
      this.notificationCountView.notificationCountSuccess(value);
    }).catchError((onError) {
      this.notificationCountView.notiificationCountError(onError);
    });
  }
}