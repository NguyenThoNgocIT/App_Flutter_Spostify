import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/data/models/auth/user.dart';
import 'package:spotify/domain/entities/auth/user.dart';

abstract class AuthSupabaseService {
  Future<Either<String, String>> signup(CreateUserReq createUserReq);

  Future<Either<String, String>> signin(SigninUserReq signinUserReq);

  Future<Either<String, UserEntity>> getUser();
}

class AuthSupabaseServiceImpl extends AuthSupabaseService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  // chức năng này sẽ được sử dụng để xác thực người dùng với Supabase
  // và lấy thông tin người dùng từ cơ sở dữ liệu Supabase.
  // Nó sẽ sử dụng SupabaseClient để thực hiện các yêu cầu đến Supabase API.
  // SupabaseClient là một đối tượng được cung cấp bởi Supabase SDK để tương tác với dịch vụ Supabase.

  @override
  Future<Either<String, String>> signin(SigninUserReq signinUserReq) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );

      if (response.user != null) {
        return const Right('Signin was Successful');
      } else {
        return const Left('Đăng nhập thất bại');
      }
    } on AuthException catch (e) {
      String message = '';

      if (e.message.contains('Invalid login credentials')) {
        message = 'mật khẩu không đúng được cung cấp cho người dùng đó';
      } else if (e.message.contains('Email not confirmed')) {
        message = 'Email chưa được xác nhận';
      } else if (e.message.contains('User not found')) {
        message = 'Không tìm thấy người dùng cho email đó';
      } else {
        message = e.message;
      }

      return Left(message);
    } catch (e) {
      return Left('Đã xảy ra lỗi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, String>> signup(CreateUserReq createUserReq) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: createUserReq.email,
        password: createUserReq.password,
      );

      if (response.user != null) {
        // Insert additional user data into 'profiles' table
        await _supabaseClient.from('Users').insert({
          'id': response.user!.id,
          'fullname': createUserReq.fullname,
          'email': response.user!.email,
          'imageurl': AppURLs.defaultImage, // hoặc truyền mặc định nếu có
        });

        return const Right('Signup was Successful');
      } else {
        return const Left('Đăng ký thất bại');
      }
    } on AuthException catch (e) {
      String message = '';

      if (e.message.contains('weak password')) {
        message = 'Mật khẩu được cung cấp quá yếu';
      } else if (e.message.contains('already registered')) {
        message = 'Đã có tài khoản được tạo bằng email đó.';
      } else {
        message = e.message;
      }

      return Left(message);
    } catch (e) {
      return Left('Đã xảy ra lỗi: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;

      if (user == null) {
        return const Left('Không tìm thấy người dùng');
      }

      final userData = await _supabaseClient
          .from('Users')
          .select()
          .eq('id', user.id)
          .single();

      UserModel userModel = UserModel.fromJson(userData);
      userModel.imageurl =
          user.userMetadata?['avatar_url'] ?? AppURLs.defaultImage;
      UserEntity userEntity = userModel.toEntity();

      return Right(userEntity);
    } catch (e) {
      return const Left('Đã xảy ra lỗi');
    }
  }
}
