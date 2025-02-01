// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/domain/use_cases/user/profile_use_case.dart';
import 'package:tasky/features/presentation/pages/app/profile/profile/profile_cubit.dart';
import 'package:tasky/features/presentation/pages/app/profile/profile/profile_states.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(RouteGenerator.home),
            icon: AppIcons.backArrow),
        title: Text(
          Strings.profile,
          style: FontStyles.textTitleStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (_, state) {},
          builder: (_, state) {
            if (state is ProfileLoadingState) {
              return CircularProgressIndicator();
            } else if (state is GetProfileSuccessState) {
              final profile = state.userData;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileItemCard(
                        title: "Name".toUpperCase(),
                        data: profile.displayName!),
                    SizedBox(
                      height: 8,
                    ),
                    PhoneCard(phoneNumber: profile.phoneNumber!),
                    SizedBox(
                      height: 8,
                    ),
                    ProfileItemCard(
                        title: "Level".toUpperCase(), data: profile.level!),
                    SizedBox(
                      height: 8,
                    ),
                    ProfileItemCard(
                        title: "Years of experience".toUpperCase(),
                        data: profile.experienceYears == 1
                            ? "1 Year"
                            : "${profile.experienceYears} Years"),
                    SizedBox(
                      height: 8,
                    ),
                    ProfileItemCard(
                        title: "Location".toUpperCase(),
                        data: profile.address!),
                    SizedBox(
                      height: 8,
                    ),
                  ]);
            } else if (state is ErrorFetchingProfileState) {
              return Center(child: Text("Error: $state"));
            } else {
              return const Center(child: Text("No Profile Data Available"));
            }
          },
        ),
      ),
    );
  }
}
