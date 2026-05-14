import 'package:gems_revamp/hotel_module/hotel_apiconfig/apiconfig_hotel.dart';
import 'package:gems_revamp/hotel_module/hotel_review/view_hotelreview.dart';
import 'package:http/http.dart' as http;

class ReviewPresenter { 
  ReviewDetailView reviewDetailView;
  ReviewPresenter(this.reviewDetailView);
  void reviewdetail(details) {
     HotelApiconfig.createorder(http.Client(), details).then((response) {
      reviewDetailView.reviewResponse(response);
    }).catchError((err) {
      this.reviewDetailView.allErr(err);
    });
  }
}