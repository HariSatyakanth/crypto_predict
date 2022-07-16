class User {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String? image;
  final int isSubscribed;
  final String subscription;

  final String? subStartDate;
  final String? referal;
  final String? mobileNumber;
  final String? nric;
  final String? address;
  final String? postcode;
  final String? subDuration;
  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.fullName,
      required this.email,
      required this.isSubscribed,
      required this.subscription,
      this.nric,
      this.address,
      this.postcode,
      this.image,
      this.mobileNumber,
      this.referal,
      this.subStartDate,
      this.subDuration});

  factory User.fromJson(Map<String, dynamic> userData) {
    return User(
      id: userData['Id'],
      firstName: userData['firstName'] ?? '',
      lastName: userData['lastName'] ?? '',
      fullName: userData['Fullname'] ?? '',
      email: userData['Email'] ?? '',
      image: userData['Picture'] ?? '',
      isSubscribed: int.tryParse(userData['isSubscribed']) ?? 0,
      subscription: userData['Subscription'] ?? '',
      mobileNumber: userData['MobileNumber'] ?? '0',
      referal: userData['Refer_code'] ?? '',
      nric: userData['NRIC'] ?? '',
      address: userData['Address'] ?? '',
      postcode: userData['Postcode'] ?? '',
      subStartDate: userData['Subscription_Start_date'] ?? '',
      subDuration: userData['Duration'] ?? '',
    );
  }
}
