class LoginModel {
  dynamic accessToken;
  String? tokenType;
  String? refreshToken;
  int? expiresIn;
  User? user;

  LoginModel(
      {this.accessToken,
      this.tokenType,
      this.refreshToken,
      this.expiresIn,
      this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    tokenType = json['tokenType'];
    refreshToken = json['refreshToken'];
    expiresIn = json['expiresIn'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['tokenType'] = tokenType;
    data['refreshToken'] = refreshToken;
    data['expiresIn'] = expiresIn;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? createAt;
  String? createBy;
  dynamic updateAt;
  dynamic updateBy;
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  dynamic verifyEmail;
  String? phoneNumber;
  String? status;
  String? profile;
  String? changePassword;
  List<Roles>? roles;

  User(
      {this.createAt,
      this.createBy,
      this.updateAt,
      this.updateBy,
      this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.verifyEmail,
      this.phoneNumber,
      this.status,
      this.profile,
      this.changePassword,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    createAt = json['createAt'];
    createBy = json['createBy'];
    updateAt = json['updateAt'];
    updateBy = json['updateBy'];
    id = json['id'];
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    verifyEmail = json['verifyEmail'];
    phoneNumber = json['phoneNumber'];
    status = json['status'];
    profile = json['profile'];
    changePassword = json['changePassword'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createAt'] = createAt;
    data['createBy'] = createBy;
    data['updateAt'] = updateAt;
    data['updateBy'] = updateBy;
    data['id'] = id;
    data['username'] = username;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['verifyEmail'] = verifyEmail;
    data['phoneNumber'] = phoneNumber;
    data['status'] = status;
    data['profile'] = profile;
    data['changePassword'] = changePassword;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? name;

  Roles({this.id, this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}