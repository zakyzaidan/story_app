import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/assets/database_services.dart';
import 'package:story_app/home/bloc/home_bloc.dart';
import 'package:story_app/home/model/story_model.dart';
import 'package:story_app/home/ui/add_story_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc homeBloc = HomeBloc();
  DatabaseServices databaseServices = DatabaseServices();

  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case HomeLoadedSuccessState:
            final Stream<QuerySnapshot> dataStory =
                databaseServices.getAllStory();

            return Scaffold(
              appBar: AppBar(
                title: const Text("Story App"),
              ),
              body: StreamBuilder<QuerySnapshot>(
                  stream: dataStory,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("something went wrong");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          StoryModel story = StoryModel(
                              story: snapshot.data!.docs[index]["story"],
                              username: snapshot.data!.docs[index]["username"],
                              email: snapshot.data!.docs[index]["email"]);

                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black38)),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          story.email,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(story.story)
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }),
              floatingActionButton: FloatingActionButton.extended(
                label: const Row(
                  children: [
                    Text("Add Story"),
                    Icon(Icons.add),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddStoryScreen()));
                },
              ),
            );

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
