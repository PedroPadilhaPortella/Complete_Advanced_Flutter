class LoginRequest {
  String email;
  String password;
  String imei;
  String deviceType;

  LoginRequest(this.email, this.password, this.imei, this.deviceType);
}

class RegisterRequest {
  String userName;
  String email;
  String password;
  String mobileNumber;
  String countryMobileCode;
  String profilePicture;

  RegisterRequest(
    this.userName,
    this.email,
    this.password,
    this.mobileNumber,
    this.countryMobileCode,
    this.profilePicture,
  );
}
