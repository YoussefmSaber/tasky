import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/core.dart';
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

  @override
  Widget build(BuildContext context) {
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
            _buildPadding(
              child: PhoneInput(controller: phoneController),
            ),
            _buildPadding(
              child: PasswordInput(
                controller: passwordController,
                inputType: TextInputType.visiblePassword,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Password is required';
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
            LoginStateBuilder(
              phoneController: phoneController,
              passwordController: passwordController,
            ),
            _buildFooter(context),
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
    final phone = phoneController.text;
    final password = passwordController.text;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Wait while we log you in"),
            content: Column(
              mainAxisSize: MainAxisSize.min, // Wrap content vertically
              children: [
                CircularProgressIndicator(
                  color: AppColors.inprogressTextColor,
                ),
              ],
            ),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(8)), // Adjust corner radius
            ),
          );
        });
    context.read<LoginCubit>().login(phone: phone, password: password);
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

class LoginStateBuilder extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  const LoginStateBuilder({
    super.key,
    required this.phoneController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (BuildContext context, LoginState state) {
        if (state is LoginSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            phoneController.clear();
            passwordController.clear();
            Navigator.of(context).pushNamed(RouteGenerator.home);
          });
          return const SizedBox.shrink();
        } else if (state is LoginError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              state.message,
              style: TextStyle(color: AppColors.errorTextColor),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
