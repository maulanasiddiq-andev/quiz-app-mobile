class BaseModel {
  final int version;
  final String description;
  final String recordStatus;
  final DateTime createdTime;
  final String createdBy;
  final DateTime modifiedTime;
  final String modifiedBy;

  BaseModel({
    required this.version,
    required this.description,
    required this.recordStatus,
    required this.createdTime,
    required this.createdBy,
    required this.modifiedTime,
    required this.modifiedBy,
  });

  BaseModel.fromJson(Map<String, dynamic> json) :
    version = json['version'], 
    description = json['description'], 
    recordStatus = json['recordStatus'], 
    createdTime = DateTime.parse(json['createdTime']), 
    createdBy = json['createdBy'], 
    modifiedTime = DateTime.parse(json['modifiedTime']), 
    modifiedBy = json['modifiedBy'];
}