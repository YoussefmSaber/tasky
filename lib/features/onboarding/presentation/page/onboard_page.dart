import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:tasky/features/onboarding/presentation/states/onboarding_states.dart';
import 'package:tasky/routes.dart';

/// A stateless widget that represents the onboarding page.
class OnboardPage extends StatelessWidget {
  /// Creates an instance of [OnboardPage].
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingStates>(
        listener: (context, state) {
      if (state is OnboardingNavigateError) {
        // Handle error, e.g., show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    }, builder: (blocContext, state) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Image.asset(Images.art),
              const SizedBox(
                height: 32,
              ),
              Text(
                "Task Management &\nTo-Do List",
                style: FontStyles.mainTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "This productive tool is designed to help\n"
                "you better manage your task\n"
                "project-wise conveniently!",
                style: FontStyles.secondaryTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 64,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: AppColors.inprogressTextColor,
                  onPressed: () {
                    blocContext.read<OnboardingCubit>().skipOnboarding();
                    Navigator.of(context).pushNamed(RouteGenerator.login);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Let's Start",
                          style: FontStyles.buttonTextStyle,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          IconlyBold.arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}