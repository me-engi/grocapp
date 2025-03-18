class ProfileModel {
  final int? id;
  final String? username;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? profilePicture;
  final String? shopName;
  final String? shopAddress;
  final String? shopDescription;

  ProfileModel({
    this.id,
    this.username,
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.profilePicture,
    this.shopName,
    this.shopAddress,
    this.shopDescription,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['user']['id'],
      username: json['user']['username'],
      email: json['user']['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postal_code'],
      profilePicture: json['profile_picture'],
      shopName: json['shop_name'],
      shopAddress: json['shop_address'],
      shopDescription: json['shop_description'],
    );
  }
}