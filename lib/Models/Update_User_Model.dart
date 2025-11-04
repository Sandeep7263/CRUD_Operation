class UpdateUserModel {
  int id; // user ID required for update API
  String username;
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
  String? joiningDate;
  String? gender;
  int? totalLeave;
  String? image;
  String? dob;
  bool? screenMonitoring;
  String? employeeId;

  UpdateUserModel({
    required this.id,
    required this.username,
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
    this.joiningDate,
    this.gender,
    this.totalLeave,
    this.image,
    this.dob,
    this.screenMonitoring,
    this.employeeId,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "roleId": roleId,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "mobile": mobile,
      "address": address,
      "pincode": pincode,
      "country": country,
      "stateId": stateId,
      "cityId": cityId,
      "departmentId": departmentId,
      "designationId": designationId,
      "joining_date": joiningDate,
      "gender": gender,
      "total_leave": totalLeave,
      "image": image,
      "dob": dob,
      "screen_monitoring": screenMonitoring,
      "employee_id": employeeId,
    };
  }
}
