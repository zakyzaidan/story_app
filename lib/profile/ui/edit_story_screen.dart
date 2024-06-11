import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/assets/database_services.dart';
import 'package:story_app/home/model/story_model.dart';
import 'package:story_app/profile/bloc/profile_bloc.dart';
import 'package:story_app/profile/model/user_model.dart';

class EditStoryScreen extends StatefulWidget {
  final StoryModel storyModel;
  final int index;
  const EditStoryScreen(
      {super.key, required this.storyModel, required this.index});

  @override
  State<EditStoryScreen> createState() => _EditStoryScreenState();
}

class _EditStoryScreenState extends State<EditStoryScreen> {
  final TextEditingController _storyTextController = TextEditingController();
  final DatabaseServices databaseServices = DatabaseServices();
  final ProfileBloc profileBloc = ProfileBloc();

  @override
  Widget build(BuildContext context) {
    _storyTextController.text = widget.storyModel.story;
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
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit story"),
          ),
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 200,
                    child: TextField(
                      controller: _storyTextController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Write a message',
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  FloatingActionButton.extended(
                      onPressed: () async {
                        UserModel user = await databaseServices.getUser();
                        final StoryModel storyModel = StoryModel(
                            story: _storyTextController.text,
                            username: user.username,
                            email: user.email);
                        profileBloc.add(EditMyStoryButtonClickedEvent(
                            index: widget.index, storyModel: storyModel));
                      },
                      label: const Text("Edit"))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
