class ImageUploadModel {
  String? path;
  String? entityId;
  String? entityType;
  String? message;
  bool? status;

  ImageUploadModel({
    this.path,
    this.entityId,
    this.entityType,
    this.message,
    this.status,
  });

  factory ImageUploadModel.fromJson(Map<String, dynamic> json) {
    bool? parsedStatus;
    if (json['status'] is bool) {
      parsedStatus = json['status'];
    } else if (json['status'] is String) {
      parsedStatus = json['status'].toLowerCase() == 'true';
    }

    return ImageUploadModel(
      path: json['path']?.toString(),
      entityId: json['entity_id']?.toString(),
      entityType: json['entity_type']?.toString(),
      message: json['message']?.toString(),
      status: parsedStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'entity_id': entityId,
      'entity_type': entityType,
      'message': message,
      'status': status,
    };
  }
}
