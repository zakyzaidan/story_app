import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/login_register/bloc/login_register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final LoginRegisterBloc loginRegisterBloc = LoginRegisterBloc();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    loginRegisterBloc.add(LoginRegisterInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginRegisterBloc, LoginRegisterState>(
      bloc: loginRegisterBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case LoginRegisterLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case LoginRegisterSuccessState:
            return Scaffold(
              body: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          const Text(
                            "Register",
                            style: TextStyle(fontSize: 25),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Username"),
                              TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.person),
                                    hintText: "Create your username"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Email"),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.email),
                                    hintText: "Input your email"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Password"),
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscureText,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    icon: Icon(_obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  hintText: "Input your password",
                                  icon: const Icon(Icons.lock),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Have an account?"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Login here!"))
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                loginRegisterBloc.add(
                                    RegisterButtonClickedEvent(
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                        email: _emailController.text,
                                        context: context));
                              },
                              child: const Text("Register"))
                        ],
                      ),
                    ),
                  ),
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
