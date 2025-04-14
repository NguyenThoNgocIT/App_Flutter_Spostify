// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class AppURLs {
  static const String projectRef = 'iblalnytxsvlpgtyiwnt';
  static const String baseStorageURL =
      'https://$projectRef.supabase.co/storage/v1/object/public';

  // Bucket cho file âm thanh
  static const String songBucket = 'songs/';

  // Bucket cho ảnh bìa
  static const String coverBucket = 'covers/';

  // URL cho file ảnh bìa

  // static String getCoverURL(String fileName) =>
  //     '$baseStorageURL/$coverBucket/${Uri.encodeComponent(fileName)}';
  // // static String getCoverURL(String fileName) =>
  // //     '$baseStorageURL/$coverBucket/$fileName';
  // static String getCoverURL(String fileName) =>
  //     '$baseStorageURL/$coverBucket/$fileName';

  // URL cho file âm thanh - đã điều chỉnh theo cấu trúc thực tế
  // static String getSongURL(String fileName) =>
  //     '$baseStorageURL/$songBucket/${Uri.encodeComponent(fileName)}';
  // Sử dụng encodeFull thay vì encodeComponent để tránh mã hóa thừa
  static String getCoverURL(String fileName) {
    // Loại bỏ khoảng trắng thừa và mã hóa tên tệp
    String safeFileName = Uri.encodeComponent(fileName.trim());
    return '$baseStorageURL/$coverBucket/$safeFileName';
  }

  static String getSongURL(String fileName) {
    // Loại bỏ khoảng trắng thừa và mã hóa tên tệp
    String safeFileName = Uri.encodeComponent(fileName.trim());
    return '$baseStorageURL/$songBucket/$safeFileName';
  }

  static const String defaultImage =
      'https://cdn-icons-png.flaticon.com/512/10542/10542486.png';

  // Method hỗ trợ kiểm tra URL tồn tại
  static Future<bool> checkURLExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error checking URL: $e');
      return false;
    }
  }
}
