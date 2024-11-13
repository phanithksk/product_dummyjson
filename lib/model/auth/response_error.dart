class ResponseErrorModel {
  String? path;
  String? error;
  String? message;
  int? status;

  ResponseErrorModel({this.path, this.error, this.message, this.status});

  ResponseErrorModel.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    error = json['error'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = path;
    data['error'] = error;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
