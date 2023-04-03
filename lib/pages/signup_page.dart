import 'package:fb_auth_provider/constants/constants.dart';
import 'package:fb_auth_provider/models/custom_error.dart';
import 'package:fb_auth_provider/providers/providers.dart';
import 'package:fb_auth_provider/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailAddressController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  String? _name;
  String? _email;
  String? _password;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailAddressController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailAddressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _globalKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    try {
      await context.read<SignUpProvider>().signUp(
            name: _name!,
            email: _email!,
            password: _password!,
          );
    } on CustomError catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        errorDialog(context, e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                autovalidateMode: _autovalidateMode,
                key: _globalKey,
                child: Consumer<SignUpProvider>(
                  builder: (_, SignUpProvider signUpProvider, __) {
                    final signUpState = signUpProvider.state;
                    return ListView(
                      reverse: true,
                      shrinkWrap: true,
                      children: [
                        Image.asset(
                          'assets/images/flutter_logo.png',
                          width: 250,
                          height: 250,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.account_box),
                          ),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name required';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                          onSaved: (String? value) => _name = value,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _emailAddressController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email required';
                            }
                            if (!RegExp(emailRegex).hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (String? value) => _email = value,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Password',
                          ),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password required';
                            }
                            if (value.trim().length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                          onSaved: (String? value) => _password = value,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Confirm Password',
                          ),
                          validator: (String? value) {
                            if (_passwordController.text != value) {
                              return 'Passwords not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () =>
                              signUpState.status == SignUpStatus.submitting
                                  ? null
                                  : _submit(context),
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                          ),
                          child: Text(
                            signUpState.status == SignUpStatus.submitting
                                ? 'Loading...'
                                : 'Sign Up',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextButton(
                          onPressed:
                              signUpState.status == SignUpStatus.submitting
                                  ? null
                                  : () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          child: const Text('Already a member? Sign in!'),
                        ),
                      ].reversed.toList(),
                    );
                  },
                ),
              )),
        ),
      ),
    );
  }
}
