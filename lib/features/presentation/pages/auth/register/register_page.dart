import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/domain/entities/auth/user_register.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

import 'cubit/register_cubit.dart';
import 'cubit/register_state.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final yearsOfExpController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (BuildContext context, RegisterState state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registration successful!")),
              );
              Navigator.of(context).pushNamed(RouteGenerator.home);
            } else if (state is RegisterError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
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
                        if (state is RegisterLoading)
                          const Center(child: CircularProgressIndicator()),
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
          child: TextInput(
            hint: Strings.registerName,
            controller: nameController,
            inputType: TextInputType.name,
          ),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: PhoneInput(controller: phoneController),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: TextInput(
            hint: Strings.registerYearsOfExp,
            controller: yearsOfExpController,
            inputType: TextInputType.number,
          ),
        ),
        const Padding(
          padding: Constants.inputPadding,
          child: Dropdown(),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: TextInput(
            hint: Strings.registerAddress,
            controller: addressController,
            inputType: TextInputType.text,
          ),
        ),
        Padding(
          padding: Constants.inputPadding,
          child: PasswordInput(
              controller: passwordController,
              inputType: TextInputType.visiblePassword,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Password is required';
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
                if (value!.isEmpty) {
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
              context.read<RegisterCubit>().register(
                      userData: UserRegister(
                    phone: phoneController.text,
                    password: passwordController.text,
                    displayName: nameController.text,
                    experienceYears: int.parse(yearsOfExpController.text),
                    address: addressController.text,
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
