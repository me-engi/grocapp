import 'package:get/get.dart';
import 'package:grocery/models/profilr_model.dart';
import 'package:grocery/screens/sign_in_repo/profile_repo.dart';
 // Import the ProfileModel

class ProfileController extends GetxController {
  final ProfileRepo _profileRepo = ProfileRepo();
  var profileData = Rx<ProfileModel?>(null); // Observable profile data
  var isLoading = true.obs; // Observable loading state

  @override
  void onInit() {
    fetchProfileData();
    super.onInit();
  }

  /// Fetch profile data from the API
  Future<void> fetchProfileData() async {
    try {
      isLoading(true); // Show loading indicator
      final data = await _profileRepo.getProfile();
      if (data != null) {
        profileData.value = ProfileModel.fromJson(data['results'][0]);
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }

  /// Logout functionality
  void logout() async {
    await _profileRepo.box.erase(); // Clear session data
    Get.offAllNamed('/signin'); // Navigate to the sign-in screen
  }
}