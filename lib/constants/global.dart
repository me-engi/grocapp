class Global {
  static const hostUrl = "https://ecommerce.pythonanywhere.com/api/";
  // static const hostUrl = "http://10.0.2.2:8000/api/"; // Use 10.0.2.2 for Android emulator to localhost
  static const productbycategory ='products/by-category/';
  static const login = 'token/';
  static const profile = 'profiles';
  static const register = 'users/';
  static const searchApi = 'product/';
  static const category = 'categories/';
  // static const popularTours = 'tour/popular/';
  // static const trendingTours = 'tour/trending/';
  static const products = 'products/';
  static const cart = 'carts/';
  static const order = 'orders/';
  static const orderiteam = 'order-items/';
  static const payments = 'payments/';
  static const forgotPassword =
      "https://ghumneho.pythonanywhere.com/password_reset/";
  // static const likeTour = 'toggle-favorite/';
  // static const dislikeTour = 'untoggle-favorite/';
  // static const getFavTours = "favorite-tours/";
  // static const tourAvalability = '/availability/';
  // static const bookingTour = '/bookings/';
  // static const bookingPerson = '/persons/';
  // static const socialLogin = 'social-login/';
  // static const notification = 'notifications/';
  // static const getcomments = 'comments/';
  // static const postcomments = 'comments/';
  static int? userId;
  static int? shopOwnerId;
}

