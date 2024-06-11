import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/assets/database_services.dart';
import 'package:story_app/profile/bloc/profile_bloc.dart';
import 'package:story_app/profile/model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _usernameTextController = TextEditingController();
  final _bioTextController = TextEditingController();
  final DatabaseServices databaseServices = DatabaseServices();
  final ProfileBloc profileBloc = ProfileBloc();

  @override
  void initState() {
    profileBloc.add(ProfileInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Success Edit Profile"),
          duration: Duration(seconds: 3),
        ));
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case ProfileLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case ProfileLoadedSuccessState:
            final successState = state as ProfileLoadedSuccessState;
            final UserModel user = successState.user;
            _bioTextController.text = user.bio;
            _usernameTextController.text = user.username;

            return Scaffold(
              appBar: AppBar(
                title: const Text("Edit profile"),
              ),
              body: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Text("Username"),
                      const SizedBox(
                        height: 5,
                      ),
                      TextField(
                        controller: _usernameTextController,
                        decoration: const InputDecoration(
                          filled: true,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Bio"),
                      SizedBox(
                        height:
                            100, //     <-- TextField expands to this height.
                        child: TextField(
                          controller: _bioTextController,
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Add bio',
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      FloatingActionButton.extended(
                          onPressed: () async {
                            profileBloc.add(ProfileEditButtonClickedEvent(
                                username: _usernameTextController.text,
                                bio: _bioTextController.text));
                          },
                          label: const Text("Edit"))
                    ],
                  ),
                ),
              ),
            );
          default:
            return const Placeholder();
        }
      },
    );
  }
}
