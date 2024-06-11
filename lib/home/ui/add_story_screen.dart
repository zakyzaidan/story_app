import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/assets/database_services.dart';
import 'package:story_app/home/bloc/home_bloc.dart';
import 'package:story_app/home/model/story_model.dart';
import 'package:story_app/profile/model/user_model.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _storyTextController = TextEditingController();
  final DatabaseServices databaseServices = DatabaseServices();
  final HomeBloc homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Success Upload Story"),
          duration: Duration(seconds: 3),
        ));
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Add story"),
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
                        homeBloc.add(
                            UploadButtonClickedEvent(storyModel: storyModel));
                      },
                      label: const Text("Upload"))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
