import 'package:gems_revamp/account/favourites/my_favourite_view.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:http/http.dart' as http;

class MyFavouritePresenter {
  final MyFavouriteView _myFavouriteView;

  MyFavouritePresenter(this._myFavouriteView);

  void myFavouriteApiResponse(req) {
    UserApiConfig.myFavouriteApiCall(http.Client(), req)
        .then((value) => _myFavouriteView.favouriteListSuccessRes(value))
        .catchError((onError) => _myFavouriteView.favouriteListError(onError));
  }
}
