import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grocery/constants/const_colors.dart';
import 'package:grocery/controllers/profile_controller.dart'; // Import the controller
import '../../constants/custom_textsyle.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _profileController.fetchProfileData(); // Fetch profile data when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: getTextTheme().headlineMedium?.copyWith(
                fontSize: 20.sp,
                color: ConstColors.textColor,
              ),
        ),
        centerTitle: true,
        backgroundColor: ConstColors.primaryColor,
        actions: [
          IconButton(
            onPressed: _profileController.logout, // Use controller's logout method
            icon: Icon(
              Icons.logout,
              color: ConstColors.textColor,
              size: 24.sp,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (_profileController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: ConstColors.primaryColor,
            ),
          );
        } else if (_profileController.profileData.value == null) {
          return Center(
            child: Text(
              "No profile data found.",
              style: getTextTheme().bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    color: ConstColors.textColor,
                  ),
            ),
          );
        } else {
          final profile = _profileController.profileData.value!;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                Center(
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundImage: profile.profilePicture != null
                        ? NetworkImage(profile.profilePicture!) as ImageProvider
                        : const AssetImage('assets/default_profile.png'),
                  ),
                ),
                SizedBox(height: 20.h),

                // Username
                _buildProfileField("Username", profile.username ?? 'Not provided'),

                // Email
                _buildProfileField("Email", profile.email ?? 'Not provided'),

                // Phone Number
                _buildProfileField("Phone Number", profile.phoneNumber ?? 'Not provided'),

                // Address
                _buildProfileField("Address", profile.address ?? 'Not provided'),

                // City
                _buildProfileField("City", profile.city ?? 'Not provided'),

                // State
                _buildProfileField("State", profile.state ?? 'Not provided'),

                // Country
                _buildProfileField("Country", profile.country ?? 'Not provided'),

                // Postal Code
                _buildProfileField("Postal Code", profile.postalCode ?? 'Not provided'),

                // Shop Name (if applicable)
                if (profile.shopName != null)
                  _buildProfileField("Shop Name", profile.shopName!),

                // Shop Address (if applicable)
                if (profile.shopAddress != null)
                  _buildProfileField("Shop Address", profile.shopAddress!),

                // Shop Description (if applicable)
                if (profile.shopDescription != null)
                  _buildProfileField("Shop Description", profile.shopDescription!),
              ],
            ),
          );
        }
      }),
    );
  }

  /// Helper method to build profile fields
  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: getTextTheme().headlineSmall?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: ConstColors.primaryColor,
                ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: getTextTheme().bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  color: ConstColors.textColor,
                ),
          ),
        ],
      ),
    );
  }
}