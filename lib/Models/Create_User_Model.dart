class CreateUserModel {
  String username;
  String password;
  int roleId;
  String firstName;
  String lastName;
  String email;
  String mobile;
  String address;
  String pincode;
  int? country;
  int? stateId;
  int? cityId;
  int? departmentId;
  int? designationId;
  String joiningDate;
  String gender;
  int? totalLeave;
  String? image;
  String dob;
  bool screenMonitoring;
  String employeeId;

  CreateUserModel({
    required this.username,
    required this.password,
    required this.roleId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.address,
    required this.pincode,
    this.country,
    this.stateId,
    this.cityId,
    this.departmentId,
    this.designationId,
    required this.joiningDate,
    required this.gender,
    this.totalLeave,
    this.image,
    required this.dob,
    required this.screenMonitoring,
    required this.employeeId,
  });

  // JSON -> Model
  factory CreateUserModel.fromJson(Map<String, dynamic> json) {
    return CreateUserModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      roleId: json['roleId'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      address: json['address'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'],
      stateId: json['stateId'],
      cityId: json['cityId'],
      departmentId: json['departmentId'],
      designationId: json['designationId'],
      joiningDate: json['joining_date'] ?? '',
      gender: json['gender'] ?? '',
      totalLeave: json['total_leave'],
      image: json['image'],
      dob: json['dob'] ?? '',
      screenMonitoring: json['screen_monitoring'] ?? false,
      employeeId: json['employee_id'] ?? '',
    );
  }

  // Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'roleId': roleId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'address': address,
      'pincode': pincode,
      'country': country,
      'stateId': stateId,
      'cityId': cityId,
      'departmentId': departmentId,
      'designationId': designationId,
      'joining_date': joiningDate,
      'gender': gender,
      'total_leave': totalLeave,
      'image': image,
      'dob': dob,
      'screen_monitoring': screenMonitoring,
      'employee_id': employeeId,
    };
  }

  // CopyWith (optional but useful)
  CreateUserModel copyWith({
    String? username,
    String? password,
    int? roleId,
    String? firstName,
    String? lastName,
    String? email,
    String? mobile,
    String? address,
    String? pincode,
    int? country,
    int? stateId,
    int? cityId,
    var departmentId,
   var designationId,
    String? joiningDate,
    String? gender,
    int? totalLeave,
    String? image,
    String? dob,
    bool? screenMonitoring,
    String? employeeId,
  }) {
    return CreateUserModel(
      username: username ?? this.username,
      password: password ?? this.password,
      roleId: roleId ?? this.roleId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      country: country ?? this.country,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      departmentId: departmentId ?? this.departmentId,
      designationId: designationId ?? this.designationId,
      joiningDate: joiningDate ?? this.joiningDate,
      gender: gender ?? this.gender,
      totalLeave: totalLeave ?? this.totalLeave,
      image: image ?? this.image,
      dob: dob ?? this.dob,
      screenMonitoring: screenMonitoring ?? this.screenMonitoring,
      employeeId: employeeId ?? this.employeeId,
    );
  }
}
