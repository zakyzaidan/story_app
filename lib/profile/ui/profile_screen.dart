import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/assets/database_services.dart';
import 'package:story_app/assets/date_format.dart';
import 'package:story_app/home/model/story_model.dart';
import 'package:story_app/login_register/UI/login_screen.dart';
import 'package:story_app/profile/bloc/profile_bloc.dart';
import 'package:story_app/profile/ui/edit_profile_screen.dart';
import 'package:story_app/profile/ui/edit_story_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc profileBloc = ProfileBloc();
  final _auth = FirebaseAuth.instance;
  DatabaseServices databaseServices = DatabaseServices();

  @override
  void initState() {
    profileBloc.add(ProfileInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (ProfileLoadingState):
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case ProfileLoadedSuccessState:
            final successState = state as ProfileLoadedSuccessState;
            final user = successState.user;
            final Stream<QuerySnapshot> dataMyStory =
                databaseServices.getMyStory(user.email);

            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30)),
                          color: Color.fromARGB(255, 110, 136, 181)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(user.bio),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const EditProfileScreen()))
                                        .then((value) {
                                      profileBloc.add(ProfileInitialEvent());
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: const Text("Edit Profile"),
                                  )),
                              const SizedBox(
                                width: 15,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Colors.red.shade300)),
                                  onPressed: () async {
                                    try {
                                      await _auth.signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()));
                                    } catch (e) {
                                      SnackBar snackBar = SnackBar(
                                        content:
                                            Text("Failed create user = $e"),
                                        backgroundColor: Colors.red,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: const Text(
                                      "Log Out",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: dataMyStory,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text("something went wrong");
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text(
                                  "You don't have story yet",
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                              );
                            }
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 15,
                                ),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  StoryModel story = StoryModel(
                                      story: snapshot.data!.docs[index]
                                          ["story"],
                                      username: snapshot.data!.docs[index]
                                          ["username"],
                                      email: snapshot.data!.docs[index]
                                          ["email"],
                                      uploadTime: snapshot.data!.docs[index]
                                          ["uploadTime"]);
                                  DateTime time = story.uploadTime.toDate();

                                  return Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black38)),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const CircleAvatar(
                                                  radius: 20,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      story.username,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      story.email,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              displayDateDifferenceFromTodayWithMS(
                                                  time),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(story.story),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditStoryScreen(
                                                                  storyModel:
                                                                      story,
                                                                  index:
                                                                      index)));
                                                },
                                                icon: const Icon(Icons.edit)),
                                            IconButton(
                                                onPressed: () async {
                                                  return showDialog(
                                                      context: context,
                                                      builder: (builder) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Delete"),
                                                          content: const Text(
                                                              "Do you want to delete this story?"),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  profileBloc.add(DeleteMystoryEvent(
                                                                      email: story
                                                                          .email,
                                                                      index:
                                                                          index));
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          const SnackBar(
                                                                    content: Text(
                                                                        "Success delete story"),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            2),
                                                                  ));
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Yes")),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: const Text(
                                                                    "Cancel"))
                                                          ],
                                                        );
                                                      });
                                                },
                                                icon: const Icon(Icons.delete))
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}
