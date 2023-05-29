import 'package:api_project/api/controllers/auth_api_controller.dart';
import 'package:api_project/helpers/helpers.dart';
import 'package:api_project/widgets/app_text_field.dart';
import 'package:api_project/widgets/code_text_field.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with Helpers {
  late TextEditingController _newPasswordTextController;
  late TextEditingController _newPasswordConfirmationTextController;

  late TextEditingController _firstCodeTextController;
  late TextEditingController _secondCodeTextController;
  late TextEditingController _thirdCodeTextController;
  late TextEditingController _fourthCodeTextController;

  late FocusNode _firstFocusNode;
  late FocusNode _secondFocusNode;
  late FocusNode _thirdFocusNode;
  late FocusNode _fourthFocusNode;

  String? _code;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _newPasswordTextController = TextEditingController();
    _newPasswordConfirmationTextController = TextEditingController();

    _firstCodeTextController = TextEditingController();
    _secondCodeTextController = TextEditingController();
    _thirdCodeTextController = TextEditingController();
    _fourthCodeTextController = TextEditingController();

    _firstFocusNode = FocusNode();
    _secondFocusNode = FocusNode();
    _thirdFocusNode = FocusNode();
    _fourthFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _newPasswordTextController.dispose();
    _newPasswordConfirmationTextController.dispose();
    _firstCodeTextController.dispose();
    _secondCodeTextController.dispose();
    _thirdCodeTextController.dispose();
    _fourthCodeTextController.dispose();
    _firstFocusNode.dispose();
    _secondFocusNode.dispose();
    _thirdFocusNode.dispose();
    _fourthFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Text(
            'Enter new password....',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Reset new password and receive code!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: CodeTextField(
                  textEditingController: _firstCodeTextController,
                  focusNode: _firstFocusNode,
                  onChanged: (value) {
                    if (value.isNotEmpty) _secondFocusNode.requestFocus();
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CodeTextField(
                  textEditingController: _secondCodeTextController,
                  focusNode: _secondFocusNode,
                  onChanged: (value) {
                    value.isNotEmpty
                        ? _thirdFocusNode.requestFocus()
                        : _firstFocusNode.requestFocus();
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CodeTextField(
                  textEditingController: _thirdCodeTextController,
                  focusNode: _thirdFocusNode,
                  onChanged: (value) {
                    value.isNotEmpty
                        ? _fourthFocusNode.requestFocus()
                        : _secondFocusNode.requestFocus();
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CodeTextField(
                  textEditingController: _fourthCodeTextController,
                  focusNode: _fourthFocusNode,
                  onChanged: (value) {
                    if (value.isEmpty) _thirdFocusNode.requestFocus();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          AppTextField(
            controller: _newPasswordTextController,
            obscureText: true,
            hint: 'Password',
            prefixIcon: Icons.lock,
          ),
          const SizedBox(
            height: 10,
          ),
          AppTextField(
            controller: _newPasswordConfirmationTextController,
            obscureText: true,
            hint: 'Password Confirmation',
            prefixIcon: Icons.lock,
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () async => await performResetPassword(),
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

  Future<void> performResetPassword() async {
    if (checkData()) {
      await resetPassword();
    }
  }

//
  bool checkData() {
    if (checkCode() && checkPassword()) {
      return true;
    }
    return false;
  }

  bool checkPassword() {
    if (_newPasswordTextController.text.isNotEmpty &&
        _newPasswordConfirmationTextController.text.isNotEmpty) {
      if (_newPasswordTextController.text ==
          _newPasswordConfirmationTextController.text) {
        return true;
      }
      showSnackBar(
        context: context,
        message: 'Password Confirmation Error!',
        error: true,
      );
      return false;
    }
    showSnackBar(
      context: context,
      message: 'Enter New Password!',
      error: true,
    );
    return false;
  }

  bool checkCode() {
    if (_firstCodeTextController.text.isNotEmpty &&
        _secondCodeTextController.text.isNotEmpty &&
        _thirdCodeTextController.text.isNotEmpty &&
        _fourthCodeTextController.text.isNotEmpty) {
      getVerificationCode();
      return true;
    }
    showSnackBar(
      context: context,
      message: 'Enter Verification Code!',
      error: true,
    );
    return false;
  }

  String getVerificationCode() {
    return _code = _firstCodeTextController.text +
        _secondCodeTextController.text +
        _thirdCodeTextController.text +
        _fourthCodeTextController.text;
  }

  Future<void> resetPassword() async {
    bool status = await AuthApiController().resetPassword(
      context,
      email: widget.email,
      code: _code!,
      password: _newPasswordTextController.text,
    );
    if (status && context.mounted ) Navigator.pop(context);
  }
}
