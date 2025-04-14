// import 'package:dartz/dartz.dart';
// import 'package:spotify/data/models/auth/create_user_req.dart';
// import 'package:spotify/data/models/auth/signin_user_req.dart';
// import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
// import 'package:spotify/domain/repository/auth/auth.dart';

// import '../../../service_locator.dart';

// class AuthRepositoryImpl extends AuthRepository {
//   @override
//   Future<Either> signin(SigninUserReq signinUserReq) async {
//     return await sl<AuthFirebaseService>().signin(signinUserReq);
//   }

//   @override
//   Future<Either> signup(CreateUserReq createUserReq) async {
//     return await sl<AuthFirebaseService>().signup(createUserReq);
//   }

//   @override
//   Future<Either> getUser() async {
//     return await sl<AuthFirebaseService>().getUser();
//   }
// }
import 'package:dartz/dartz.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/data/sources/auth/auth_supabase_service.dart';
import 'package:spotify/domain/repository/auth/auth.dart';
import 'package:spotify/domain/entities/auth/user.dart';

import '../../../service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<String, String>> signin(SigninUserReq signinUserReq) async {
    return await sl<AuthSupabaseService>().signin(signinUserReq);
  }

  @override
  Future<Either<String, String>> signup(CreateUserReq createUserReq) async {
    return await sl<AuthSupabaseService>().signup(createUserReq);
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    return await sl<AuthSupabaseService>().getUser();
  }
}
