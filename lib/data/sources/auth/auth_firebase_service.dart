// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:spotify/core/configs/constants/app_urls.dart';
// import 'package:spotify/data/models/auth/create_user_req.dart';
// import 'package:spotify/data/models/auth/signin_user_req.dart';
// import 'package:spotify/data/models/auth/user.dart';
// import 'package:spotify/domain/entities/auth/user.dart';

// abstract class AuthFirebaseService {
//   Future<Either> signup(CreateUserReq createUserReq);

//   Future<Either> signin(SigninUserReq signinUserReq);

//   Future<Either> getUser();
// }

// class AuthFirebaseServiceImpl extends AuthFirebaseService {
//   @override
//   Future<Either> signin(SigninUserReq signinUserReq) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: signinUserReq.email, password: signinUserReq.password);

//       return const Right('Signin was Successful');
//     } on FirebaseAuthException catch (e) {
//       String message = '';

//       if (e.code == 'email không hợp lệ') {
//         message = 'Không tìm thấy người dùng cho email đó';
//       } else if (e.code == 'thông tin xác thực không hợp lệ') {
//         message = 'mật khẩu không đúng được cung cấp cho người dùng đó';
//       }

//       return Left(message);
//     }
//   }

//   @override
//   Future<Either> signup(CreateUserReq createUserReq) async {
//     try {
//       var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: createUserReq.email, password: createUserReq.password);

//       FirebaseFirestore.instance.collection('Users').doc(data.user?.uid).set({
//         'name': createUserReq.fullName,
//         'email': data.user?.email,
//       });

//       return const Right('Signup was Successful');
//     } on FirebaseAuthException catch (e) {
//       String message = '';

//       if (e.code == 'mật khẩu yếu`') {
//         message = 'Mật khẩu được cung cấp quá yếu';
//       } else if (e.code == 'email-already-in-use') {
//         message = 'Đã có tài khoản được tạo bằng email đó.';
//       }

//       return Left(message);
//     }
//   }

//   @override
//   Future<Either> getUser() async {
//     try {
//       FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//       FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//       var user = await firebaseFirestore
//           .collection('Users')
//           .doc(firebaseAuth.currentUser?.uid)
//           .get();

//       UserModel userModel = UserModel.fromJson(user.data()!);
//       userModel.imageURL =
//           firebaseAuth.currentUser?.photoURL ?? AppURLs.defaultImage;
//       UserEntity userEntity = userModel.toEntity();
//       return Right(userEntity);
//     } catch (e) {
//       return const Left('Đã xảy ra lỗi');
//     }
//   }
// }
