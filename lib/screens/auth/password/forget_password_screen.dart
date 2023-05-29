import 'package:api_project/api/controllers/auth_api_controller.dart';
import 'package:api_project/helpers/helpers.dart';
import 'package:api_project/screens/auth/password/reset_password_screen.dart';
import 'package:api_project/widgets/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with Helpers {
  late TextEditingController _emailTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forget Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Text(
            'Enter Email....',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Reset code will be sent!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          AppTextField(
            controller: _emailTextController,
            hint: 'Email',
            prefixIcon: Icons.email,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async => await performForgetPassword(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('SEND'),
          ),
        ],
      ),
    );
  }

  Future<void> performForgetPassword() async {
    if (checkData()) {
      await forgetPassword();
    }
  }

  bool checkData() {
    if (_emailTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
      context: context,
      message: 'Enter Your Email!',
      error: true,
    );
    return false;
  }

  Future<void> forgetPassword() async {
    bool status = await AuthApiController().forgetPassword(
      context,
      email: _emailTextController.text,
    );
    if (status && context.mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              email: _emailTextController.text,
            ),
          ));
    }
  }
}
