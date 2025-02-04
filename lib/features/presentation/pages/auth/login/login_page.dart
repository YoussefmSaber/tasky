import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/core/styles/snackbar.dart';
import 'package:tasky/features/presentation/pages/auth/login/cubit/login_states.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

import 'cubit/login_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // Reset cubit state on screen initialization
    context.read<LoginCubit>().initial();
  }

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
    context.read<LoginCubit>().close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (BuildContext context, LoginState state) {
        if (state is LoginSuccess) {
          Navigator.of(context).pop;
          showAppSnackBar(
              message: "Login Successful!",
              textColor: AppColors.successTextColor,
              backgroundColor: AppColors.successBackgroundColor,
              context:  context);
          Navigator.of(context).pushNamed(RouteGenerator.home);
          phoneController.clear();
          passwordController.clear();
        }
        if (state is LoginError) {
          Navigator.of(context).pop;
        }
      },
      builder: (context, state) {
        return _buildLoginScreen(context, state);
      },
    );
  }

  Widget _buildLoginScreen(BuildContext context, LoginState state) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(Images.art)),
            _buildPadding(
              child: Text(
                "Login",
                style: FontStyles.mainTextStyle,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildPadding(
                    child: PhoneInput(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  _buildPadding(
                    child: PasswordInput(
                      controller: passwordController,
                      inputType: TextInputType.visiblePassword,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  state is LoginError
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            state.message,
                            style: TextStyle(color: AppColors.errorTextColor),
                          ),
                        )
                      : const SizedBox.shrink(),
                  _buildPadding(
                    child: SizedBox(
                      width: double.infinity,
                      child: SignButton(
                        text: Strings.signin,
                        onTap: () => _onLoginButtonPressed(context),
                      ),
                    ),
                  ),
                  _buildFooter(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPadding({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: child,
    );
  }

  void _onLoginButtonPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Logging in"),
              content: Column(
                // Wrap content vertically
                children: [
                  Text("Please wait while we log you in"),
                  SizedBox(height: 8),
                  CircularProgressIndicator(
                    color: AppColors.inprogressTextColor,
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(8)), // Adjust corner radius
              ),
            );
          });
      context.read<LoginCubit>().login(
          phone: phoneController.text, password: passwordController.text);
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Strings.haveAcc,
          style: FontStyles.secondaryTextStyle,
        ),
        TextButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(RouteGenerator.register),
          child: Text(
            Strings.signHere,
            style: FontStyles.textButtonStyle,
          ),
        ),
      ],
    );
  }
}
