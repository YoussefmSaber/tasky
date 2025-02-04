import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/core/styles/snackbar.dart';
import 'package:tasky/features/auth/presentation/states/login_states.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

import '../cubit/login_cubit.dart';

/// A stateful widget that represents the login page.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

/// The state for the `LoginPage` widget.
class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // Reset cubit state on screen initialization
    context.read<LoginCubit>().initial();
  }

  // Controller for the phone number input field.
  final TextEditingController phoneController = TextEditingController();

  // Controller for the password input field.
  final TextEditingController passwordController = TextEditingController();

  // Key for the login form.
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
              context: context);
          Navigator.of(context).pushNamed(RouteGenerator.home);
        }
        if (state is LoginError) {
          Navigator.of(context).pop;
          showAppSnackBar(
              message: state.message,
              backgroundColor: AppColors.errorBackgroundColor,
              textColor: AppColors.errorTextColor,
              context: context,
              duration: Duration(seconds: 5));
        }
      },
      builder: (context, state) {
        return _buildLoginScreen(context, state);
      },
    );
  }

  /// Builds the login screen UI.
  ///
  /// [context] is the build context.
  /// [state] is the current state of the login cubit.
  Widget _buildLoginScreen(BuildContext context, LoginState state) {
    String? passwordError;

    if (state is LoginError) {
      passwordError = state.message; // Extract error message from state
    }

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
                        if (passwordError != null) {
                          return passwordError; // Display login error under the password field
                        }
                        return null;
                      },
                    ),
                  ),
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

  /// Builds a padding widget.
  ///
  /// [child] is the widget to be wrapped with padding.
  Widget _buildPadding({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: child,
    );
  }

  /// Handles the login button press event.
  ///
  /// [context] is the build context.
  void _onLoginButtonPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Logging in"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
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

  /// Builds the footer widget.
  ///
  /// [context] is the build context.
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