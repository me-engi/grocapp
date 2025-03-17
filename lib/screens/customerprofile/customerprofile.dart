import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage for session management
import 'package:grocery/constants/const_colors.dart';
 // Import ProfileRepo
import 'package:grocery/screens/sign_in_repo/profile_repo.dart';
import '../../constants/custom_textsyle.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final ProfileRepo _profileRepo = ProfileRepo(); // Initialize the repository
  Map<String, dynamic>? _profileData; // Store fetched profile data
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Fetch profile data when the screen loads
  }

  /// Fetch profile data from the API
  Future<void> _fetchProfileData() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final data = await _profileRepo.getProfile(); // Call the repository
      if (data != null) {
        setState(() {
          _profileData = data['results'][0]; // Extract the first profile result
          _isLoading = false; // Hide loading indicator
        });
      } else {
        setState(() {
          _isLoading = false; // Hide loading indicator if no data is returned
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Hide loading indicator in case of an error
      });
    }
  }

  /// Handle logout functionality
  void _handleLogout() async {
    // Clear user session data using GetStorage
    GetStorage box = GetStorage();
    await box.erase(); // Clear all stored data (e.g., token)

    // Navigate to the sign-in screen
    Get.offAllNamed('/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: getTextTheme().headlineMedium?.copyWith(
            fontSize: 20.sp, // Responsive font size
            color: ConstColors.textColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: ConstColors.primaryColor,
        actions: [
          IconButton(
            onPressed: _handleLogout, // Trigger logout functionality
            icon: Icon(
              Icons.logout, // Logout icon
              color: ConstColors.textColor,
              size: 24.sp, // Responsive icon size
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ConstColors.primaryColor,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: CircleAvatar(
                      radius: 50.r, // Responsive radius
                      backgroundImage: _profileData?['profile_picture'] != null
                          ? NetworkImage(_profileData!['profile_picture'])
                              as ImageProvider
                          : const AssetImage('assets/default_profile.png'),
                    ),
                  ),
                  SizedBox(height: 20.h), // Responsive spacing

                  // Username
                  _buildProfileField(
                    "Username",
                    _profileData?['user']['username'] ?? 'N/A',
                  ),

                  // Email
                  _buildProfileField(
                    "Email",
                    _profileData?['user']['email'] ?? 'N/A',
                  ),

                  // Phone Number
                  _buildProfileField(
                    "Phone Number",
                    _profileData?['phone_number'] ?? 'N/A',
                  ),

                  // Address
                  _buildProfileField(
                    "Address",
                    _profileData?['address'] ?? 'N/A',
                  ),

                  // City
                  _buildProfileField(
                    "City",
                    _profileData?['city'] ?? 'N/A',
                  ),

                  // State
                  _buildProfileField(
                    "State",
                    _profileData?['state'] ?? 'N/A',
                  ),

                  // Country
                  _buildProfileField(
                    "Country",
                    _profileData?['country'] ?? 'N/A',
                  ),

                  // Postal Code
                  _buildProfileField(
                    "Postal Code",
                    _profileData?['postal_code'] ?? 'N/A',
                  ),

                  // Shop Name (if applicable)
                  if (_profileData?['shop_name'] != null)
                    _buildProfileField(
                      "Shop Name",
                      _profileData?['shop_name'] ?? 'N/A',
                    ),

                  // Shop Address (if applicable)
                  if (_profileData?['shop_address'] != null)
                    _buildProfileField(
                      "Shop Address",
                      _profileData?['shop_address'] ?? 'N/A',
                    ),

                  // Shop Description (if applicable)
                  if (_profileData?['shop_description'] != null)
                    _buildProfileField(
                      "Shop Description",
                      _profileData?['shop_description'] ?? 'N/A',
                    ),
                ],
              ),
            ),
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
              fontSize: 14.sp, // Responsive font size
              fontWeight: FontWeight.bold,
              color: ConstColors.primaryColor,
            ),
          ),
          SizedBox(height: 4.h), // Responsive spacing
          Text(
            value,
            style: getTextTheme().bodyMedium?.copyWith(
              fontSize: 14.sp, // Responsive font size
              color: ConstColors.textColor,
            ),
          ),
        ],
      ),
    );
  }
}