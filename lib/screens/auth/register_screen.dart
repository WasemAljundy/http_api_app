import 'package:api_project/api/controllers/auth_api_controller.dart';
import 'package:api_project/helpers/helpers.dart';
import 'package:api_project/models/student.dart';
import 'package:api_project/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  late TextEditingController _fullNameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  String _gender = 'M';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fullNameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Text(
            'Create new account....',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Enter details below',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          AppTextField(
              controller: _fullNameTextController,
              hint: 'Full Name',
              prefixIcon: Icons.person),
          const SizedBox(
            height: 10,
          ),
          AppTextField(
            controller: _emailTextController,
            keyboardType: TextInputType.emailAddress,
            hint: 'Email',
            prefixIcon: Icons.email,
          ),
          const SizedBox(
            height: 10,
          ),
          AppTextField(
            controller: _passwordTextController,
            hint: 'Password',
            prefixIcon: Icons.lock,
            obscureText: true,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RadioListTile(
                  title: const Text('Male'),
                  contentPadding: EdgeInsets.zero,
                  value: 'M',
                  groupValue: _gender,
                  onChanged: (String? value) {
                    setState(() {
                      if (value != null) {
                        _gender = value;
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: const Text('Female'),
                  contentPadding: EdgeInsets.zero,
                  value: 'F',
                  groupValue: _gender,
                  onChanged: (String? value) {
                    setState(() {
                      if (value != null) {
                        _gender = value;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async => await performRegister(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('REGISTER'),
          ),
        ],
      ),
    );
  }

  Future<void> performRegister() async {
    if(checkData()) {
      await register();
    }
  }

  bool checkData() {
    if (_fullNameTextController.text.isNotEmpty &&
        _emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(
      context: context,
      message: 'Enter required data!',
      error: true,
    );
    return false;
  }

  Future<void> register() async {
    bool status = await AuthApiController().register(context, student: student);
    if(status && context.mounted) Navigator.pop(context);
  }

  Student get student {
    Student student = Student();
    student.fullName = _fullNameTextController.text;
    student.email = _emailTextController.text;
    student.password = _passwordTextController.text;
    student.gender = _gender;
    return student;
  }


}
