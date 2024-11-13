class RequestBodyModel {
  dynamic phoneNumber;
  dynamic password;

  RequestBodyModel({this.phoneNumber, this.password});

  RequestBodyModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    return data;
  }
}
