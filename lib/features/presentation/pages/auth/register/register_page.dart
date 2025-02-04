import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/core/styles/snackbar.dart';
import 'package:tasky/features/domain/entities/auth/user_register.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

import 'cubit/register_cubit.dart';
import 'cubit/register_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final yearsOfExpController = TextEditingController();

  final addressController = TextEditingController();

  final phoneController = TextEditingController();

  final levelController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    yearsOfExpController.dispose();
    addressController.dispose();
    phoneController.dispose();
    levelController.dispose();
    context.read<RegisterCubit>().close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (BuildContext context, RegisterState state) {
            if (state is RegisterSuccess) {
              showAppSnackBar(
                  message: "Registration successful!",
                  textColor: AppColors.successTextColor,
                  backgroundColor: AppColors.successBackgroundColor,
                  context: context);
              Navigator.of(context).pushNamed(RouteGenerator.home);
            }
            if (state is RegisterError) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(Images.register),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        _buildInputFields(),
                        state is RegisterError
                            ? Center(
                                child: Text(state.message,
                                    style: FontStyles.errorMenuTextStyle))
                            : SizedBox.shrink(),
                        _buildSignUpButton(context),
                        _buildFooter(context),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        Strings.register,
        style: FontStyles.mainTextStyle,
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        Padding(
          padding: Constants.inputPadding,
          child: TextFormField(
            controller: nameController,
            validator: (value) =>
                value == null || value.isEmpty ? 'Name is required' : null,
            decoration: InputDecoration(
              hintText: Strings.registerName, // Added
              hintStyle: FontStyles.hintTextStyle, // labelText
              border: WidgetStyles.borderStyle,
              focusedBorder: WidgetStyles.borderStyle,
            ),
            keyboardType: TextInputType.name,
          ),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: PhoneInput(
              controller: phoneController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                return null;
              }),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: TextFormField(
            controller: yearsOfExpController,
            keyboardType: TextInputType.number,
            validator: (value) => value == null || value.isEmpty
                ? 'Years of experience is required'
                : null,
            decoration: InputDecoration(
              hintText: Strings.registerYearsOfExp, // Added
              hintStyle: FontStyles.hintTextStyle, // labelText
              border: WidgetStyles.borderStyle,
              focusedBorder: WidgetStyles.borderStyle,
            ),
          ),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: Dropdown(
            onLevelSelected: (value) {
              levelController.text = value;
            },
          ),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: TextFormField(
              controller: addressController,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Address is required' : null,
              decoration: InputDecoration(
                hintText: Strings.registerAddress, // Added
                hintStyle: FontStyles.hintTextStyle, // labelText
                border: WidgetStyles.borderStyle,
                focusedBorder: WidgetStyles.borderStyle,
              )),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: PasswordInput(
              controller: passwordController,
              inputType: TextInputType.visiblePassword,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              }),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: PasswordInput(
              controller: confirmPasswordController,
              inputType: TextInputType.visiblePassword,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                } else if (value != passwordController.text) {
                  return 'Passwords do not match';
                } else {
                  return null;
                }
              }),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: SignButton(
          text: Strings.signup,
          onTap: () {
            if (_formKey.currentState!.validate()) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Registering"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        // Wrap content vertically
                        children: [
                          Text("Wait while we register your new account"),
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
              context.read<RegisterCubit>().register(
                      userData: UserRegister(
                    phone: phoneController.text,
                    password: passwordController.text,
                    displayName: nameController.text,
                    experienceYears: int.parse(yearsOfExpController.text),
                    address: addressController.text,
                    level: levelController.text,
                  ));
            }
          },
        ),
      ),
    );
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
              Navigator.of(context).pushNamed(RouteGenerator.login),
          child: Text(
            Strings.signin,
            style: FontStyles.textButtonStyle,
          ),
        ),
      ],
    );
  }
}
