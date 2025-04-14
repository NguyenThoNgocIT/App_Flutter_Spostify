import 'package:spotify/domain/entities/auth/user.dart';

class UserModel {
  String? fullname;
  String? email;
  String? imageurl;

  UserModel({this.fullname, this.email, this.imageurl});

  UserModel.fromJson(Map<String, dynamic> data) {
    fullname = data['fullname'];
    email = data['email'];
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(email: email, fullname: fullname, imageurl: imageurl);
  }
}
