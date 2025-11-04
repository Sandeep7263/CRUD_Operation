class UserFetchModel {
  final int id;
  final String username;
  final String? password;
  final bool isActive;
  final String joiningDate;
  final String? exitDate;
  final bool screenMonitoring;
  final int? employeeId;
  final String? lastLogin;
  final Profile? profile;
  final Department? role;
  final String totalLeave;

  UserFetchModel({
    required this.id,
    required this.username,
    this.password,
    required this.isActive,
    required this.joiningDate,
    this.exitDate,
    required this.screenMonitoring,
    this.employeeId,
    this.lastLogin,
    this.profile,
    this.role,
    required this.totalLeave,
  });

  factory UserFetchModel.fromJson(Map<String, dynamic>? json) {
    json = json ?? {};
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    bool parseBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      final s = v.toString().toLowerCase();
      return s == 'true' || s == '1';
    }

    return UserFetchModel(
      id: parseInt(json['id']),
      username: json['username']?.toString() ?? '',
      password: json['password']?.toString(),
      isActive: parseBool(json['is_Active'] ?? json['is_active'] ?? json['isActive']),
      joiningDate: json['joining_date']?.toString() ?? '',
      exitDate: json['exit_date']?.toString(),
      screenMonitoring: parseBool(json['screen_monitoring'] ?? json['screenMonitoring']),
      employeeId: json['employee_id'] != null ? int.tryParse(json['employee_id'].toString()) : null,
      lastLogin: json['last_login']?.toString(),
      profile: json['profile'] != null && json['profile'] is Map ? Profile.fromJson(json['profile']) : null,
      role: json['role'] != null ? Department.fromJson(json['role']) : null,
      totalLeave: json['total_leave']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'is_Active': isActive,
      'joining_date': joiningDate,
      'exit_date': exitDate,
      'screen_monitoring': screenMonitoring,
      'employee_id': employeeId,
      'last_login': lastLogin,
      'profile': profile?.toJson(),
      'role': role?.toJson(),
      'total_leave': totalLeave,
    };
  }
}

class Profile {
  final int? id;
  final String? email;
  final String? mobile;
  final String? address;
  final String? pincode;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final int? image;
  final String? dob;
  final Department? department;
  final Department? designation;
  final Department? city;
  final Department? state;
  final Department? countryinfo;
  final Images? images;

  Profile({
    this.id,
    this.email,
    this.mobile,
    this.address,
    this.pincode,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
    this.dob,
    this.department,
    this.designation,
    this.city,
    this.state,
    this.countryinfo,
    this.images,
  });

  factory Profile.fromJson(Map<String, dynamic>? json) {
    json = json ?? {};
    int? parseNullableInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return Profile(
      id: parseNullableInt(json['id']),
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
      address: json['address']?.toString(),
      pincode: json['pincode']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      gender: json['gender']?.toString(),
      image: parseNullableInt(json['image']),
      dob: json['dob']?.toString(),
      department: json['department'] != null ? Department.fromJson(json['department']) : null,
      designation: json['designation'] != null ? Department.fromJson(json['designation']) : null,
      city: json['city'] != null ? Department.fromJson(json['city']) : null,
      state: json['state'] != null ? Department.fromJson(json['state']) : null,
      countryinfo: json['countryinfo'] != null ? Department.fromJson(json['countryinfo']) : null,
      images: json['images'] != null && json['images'] is Map ? Images.fromJson(json['images']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'mobile': mobile,
      'address': address,
      'pincode': pincode,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'image': image,
      'dob': dob,
      'department': department?.toJson(),
      'designation': designation?.toJson(),
      'city': city?.toJson(),
      'state': state?.toJson(),
      'countryinfo': countryinfo?.toJson(),
      'images': images?.toJson(),
    };
  }
}

class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(dynamic json) {
    if (json == null) {
      return Department(id: 0, name: '');
    }

    if (json is int) {
      return Department(id: json, name: '');
    }

    if (json is String) {
      return Department(id: 0, name: json);
    }

    // assume Map
    final map = json as Map<String, dynamic>;
    int parseId(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return Department(
      id: parseId(map['id']),
      name: map['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Images {
  final int id;
  final String filename;
  final String path;
  final String size;
  final String entityType;
  final int entityId;
  final String extensions;
  final String createdAt;
  final String updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? uploadedBy;

  Images({
    required this.id,
    required this.filename,
    required this.path,
    required this.size,
    required this.entityType,
    required this.entityId,
    required this.extensions,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.uploadedBy,
  });

  factory Images.fromJson(Map<String, dynamic>? json) {
    json = json ?? {};
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return Images(
      id: parseInt(json['id']),
      filename: json['filename']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      entityType: json['entity_type']?.toString() ?? '',
      entityId: parseInt(json['entity_id']),
      extensions: json['extensions']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      createdBy: json['created_by']?.toString(),
      updatedBy: json['updated_by']?.toString(),
      uploadedBy: json['uploaded_by']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'path': path,
      'size': size,
      'entity_type': entityType,
      'entity_id': entityId,
      'extensions': extensions,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'uploaded_by': uploadedBy,
    };
  }
}