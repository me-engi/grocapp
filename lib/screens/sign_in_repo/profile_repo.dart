import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocery/common_repo.dart';
import '../../../constants/global.dart';
import '../../../constants/const_colors.dart';

class ProfileRepo {
  API api = API();
  GetStorage box = GetStorage();

  /// Fetch user profile
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      // Retrieve the saved token
      String? token = box.read('token');
      if (token == null || token.isEmpty) {
        Fluttertoast.showToast(
          msg: "Token not found. Please log in again.",
          backgroundColor: ConstColors.primaryColor,
          toastLength: Toast.LENGTH_LONG,
        );
        return null;
      }

      // Add the token to the request headers
      Response response = await api.sendRequest.get(
        Global.profile,
        options: Options(headers: {"Authorization": "Token $token"}),
      );

      if (response.statusCode == 200) {
        return response.data; // Return the raw API response
      } else {
        Fluttertoast.showToast(
          msg: "Failed to fetch profile. Please try again.",
          backgroundColor: ConstColors.primaryColor,
          toastLength: Toast.LENGTH_LONG,
        );
        return null;
      }
    } on DioException catch (e) {
      // Handle errors
      if (e.response != null &&
          e.response!.statusCode! >= 400 &&
          e.response!.statusCode! <= 500) {
        Fluttertoast.showToast(
          msg: e.response!.data.toString(),
          backgroundColor: ConstColors.primaryColor,
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(
          msg: "An unexpected error occurred.",
          backgroundColor: ConstColors.primaryColor,
          toastLength: Toast.LENGTH_LONG,
        );
      }
      return null;
    }
  }
}