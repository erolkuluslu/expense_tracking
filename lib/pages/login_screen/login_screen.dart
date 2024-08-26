import 'package:expense_tracking/pages/login_screen/widgets/gradient_button.dart';
import 'package:expense_tracking/pages/login_screen/widgets/login_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

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

  /// transition to the "is focus" state, and when it is deactivated, the
  /// animation will transition to the "is not focus" state.
  Future<void> loadRiveFile() async {
    try {
      final data = await rootBundle.load(animationURL);
      final file = RiveFile.import(data);

      if (file != null) {
        final artboard = file.mainArtboard;
        var controller = StateMachineController.fromArtboard(
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
          debugPrint("StateMachineController not found.");
        }
      } else {
        debugPrint("Rive file is null or couldn't be loaded.");
      }
    } catch (e) {
      debugPrint('Error loading Rive file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'Sign in.',
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
                    : const CircularProgressIndicator(), // Shows a loading indicator while the artboard is loading
              ),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Email',
                controller: emailController,
                onTap: activateIsFocus,
              ),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Password',
                controller: passwordController,
                onTap: activateIsPassword,
              ),
              const SizedBox(height: 20),
              const GradientButton(),
            ],
          ),
        ),
      ),
    );
  }
}
