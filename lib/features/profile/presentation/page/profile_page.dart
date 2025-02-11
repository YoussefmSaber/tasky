import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky/core/core.dart';
import 'package:tasky/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:tasky/features/presentation/widgets/app_widgets.dart';
import 'package:tasky/features/presentation/widgets/loading/profile_item_loading.dart';
import 'package:tasky/routes.dart';

import '../states/profile_states.dart';

/// A `StatefulWidget` that represents the profile page.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

/// The state for the `ProfilePage` widget.
class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch the profile data when the widget is initialized.
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
              // Display a loading indicator while the profile data is being fetched.
              return ListView.separated(
                itemBuilder: (context, index) => ProfileItemLoading(),
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: 5,
              );
            } else if (state is GetProfileSuccessState) {
              final profile = state.userData;
              // Display the profile data when it is successfully fetched.
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
              // Display an error message if there was an error fetching the profile data.
              return Center(child: Text("Error: $state"));
            } else {
              // Display a message if no profile data is available.
              return const Center(child: Text("No Profile Data Available"));
            }
          },
        ),
      ),
    );
  }
}