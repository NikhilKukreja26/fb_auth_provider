import 'package:fb_auth_provider/constants/constants.dart';
import 'package:fb_auth_provider/models/custom_error.dart';
import 'package:fb_auth_provider/providers/sign_in/sign_in_provider.dart';
import 'package:fb_auth_provider/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _emailAddressController;
  late final TextEditingController _passwordController;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  void initState() {
    super.initState();
    _emailAddressController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailAddressController.dispose();
    _passwordController.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });
    final form = _globalKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    try {
      await context.read<SignInProvider>().signIn(
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
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _globalKey,
                autovalidateMode: _autovalidateMode,
                child: Consumer<SignInProvider>(
                  builder: (_, SignInProvider signInProvider, __) {
                    final signInState = signInProvider.state;
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Image.asset(
                          'assets/images/flutter_logo.png',
                          width: 250,
                          height: 250,
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
                          onSaved: (String? value) {
                            _email = value;
                          },
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
                          onSaved: (String? value) {
                            _password = value;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () =>
                              signInState.status == SignInStatus.submitting
                                  ? null
                                  : _submit(context),
                          style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          child: Text(
                              signInState.status == SignInStatus.submitting
                                  ? 'Loading...'
                                  : 'Sign In'),
                        ),
                        const SizedBox(height: 10.0),
                        TextButton(
                          onPressed: signInState.status ==
                                  SignInStatus.submitting
                              ? null
                              : () {
                                  Navigator.of(context).pushNamed('/signUp');
                                },
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          child: const Text('Not a member? Sign Up!'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
