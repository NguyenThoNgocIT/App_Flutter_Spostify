import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/presentation/intro/pages/get_started.dart';
import 'package:spotify/presentation/home/pages/home.dart'; // <-- Trang chính của bạn

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
    // Lắng nghe sự thay đổi session khi người dùng đăng nhập hoặc đăng xuất
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        // Nếu đã đăng nhập, điều hướng đến HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else if (event == AuthChangeEvent.signedOut) {
        // Nếu đăng xuất, điều hướng về GetStartedPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GetStartedPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SvgPicture.asset(AppVectors.logo)),
    );
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 2)); // giữ splash mượt

    final session = Supabase.instance.client.auth.currentSession;
    // chức năng này sẽ được sử dụng để xác thực người dùng với Supabase
    // và lấy thông tin người dùng từ cơ sở dữ liệu Supabase.
    // Nó sẽ sử dụng SupabaseClient để thực hiện các yêu cầu đến Supabase API.
    // SupabaseClient là một đối tượng được cung cấp bởi Supabase SDK để tương tác với dịch vụ Supabase.
    // kiểm tra xem người dùng đã đăng nhập hay chưa
    // Nếu session không null, có nghĩa là người dùng đã đăng nhập
    // Nếu session là null, có nghĩa là người dùng chưa đăng nhập
    // và sẽ được chuyển hướng đến trang GetStartedPage

    if (session != null) {
      // Đã đăng nhập, chuyển qua HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      // Chưa đăng nhập, chuyển qua GetStartedPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GetStartedPage()),
      );
    }
  }
}
