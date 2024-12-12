// ignore_for_file: always_use_package_imports

import 'package:expense_tracking/domain/repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../home/home_page.dart';
import 'widgets/gradient_button.dart';
import 'widgets/login_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String animationURL;
  Artboard? _bunnyArtboard;
  SMITrigger? success;
  SMITrigger? fail;
  SMIBool? isPassword;
  SMIBool? isFocus;
  SMINumber? number;

  StateMachineController? stateMachineController;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    animationURL = 'assets/rives/bunny_login.riv';
    loadRiveFile();
  }

  void activateIsFocus() {
    isPassword?.change(false);
    isFocus?.change(true);
  }

  void activateIsPassword() {
    isFocus?.change(false);
    isPassword?.change(true);
  }

  void activateIsSuccess() {
    isFocus?.change(false);
    isPassword?.change(false);
    fail?.change(false);
    success?.change(true);
  }

  void activateIsFail() {
    isFocus?.change(false);
    isPassword?.change(false);
    success?.change(false);
    fail?.change(true);
  }

  Future<void> loadRiveFile() async {
    try {
      final data = await rootBundle.load(animationURL);
      final file = RiveFile.import(data);

      final artboard = file.mainArtboard;
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1', // Ensure this matches your state machine name in Rive
      );

      if (controller != null) {
        artboard.addController(controller);

        success = controller.findInput<bool>('login_success') as SMITrigger?;
        fail = controller.findInput<bool>('login_fail') as SMITrigger?;
        isPassword = controller.findInput<bool>('IsPassword') as SMIBool?;
        isFocus = controller.findInput<bool>('isFocus') as SMIBool?;
        number = controller.findInput<double>('eye_track') as SMINumber?;
        setState(() {
          _bunnyArtboard = artboard;
          stateMachineController = controller;
        });
      } else {
        debugPrint('StateMachineController not found.');
      }
    } catch (e) {
      debugPrint('Error loading Rive file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<IExpenseRepository>();
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            activateIsFail();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
          if (state is AuthSuccess) {
            activateIsSuccess();
            // Delay the navigation to allow the success animation to play
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            });
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Welcome to\nExpense Tracking',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: _bunnyArtboard != null
                          ? Rive(
                              artboard: _bunnyArtboard!,
                              fit: BoxFit.fitHeight,
                            )
                          : const CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 15),
                    LoginField(
                      isEmail: true,
                      hintText: 'Email',
                      controller: emailController,
                      onTap: activateIsFocus,
                    ),
                    const SizedBox(height: 15),
                    LoginField(
                      isEmail: false,
                      hintText: 'Password',
                      controller: passwordController,
                      onTap: activateIsPassword,
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      text: 'Login',
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              AuthLoginRequested(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
