import 'package:api_project/prefs/shared_pref_controller.dart';
import 'package:api_project/screens/auth/login_screen.dart';
import 'package:api_project/screens/auth/password/forget_password_screen.dart';
import 'package:api_project/screens/auth/register_screen.dart';
import 'package:api_project/screens/categories_screen.dart';
import 'package:api_project/screens/images/images_screen.dart';
import 'package:api_project/screens/images/upload_image_screen.dart';
import 'package:api_project/screens/launch_screen.dart';
import 'package:api_project/screens/users_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPref();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/launch_screen',
      routes: {
        '/launch_screen': (context) => const LaunchScreen(),
        '/login_screen': (context) => const LoginScreen(),
        '/register_screen': (context) => const RegisterScreen(),
        '/forget_password_screen': (context) => const ForgetPasswordScreen(),
        '/users_screen': (context) => const UsersScreen(),
        '/categories_screen': (context) => const CategoriesScreen(),
        '/images_screen': (context) => const ImagesScreen(),
        '/upload_image_screen': (context) => const UploadImageScreen(),
      },
    );
  }
}
