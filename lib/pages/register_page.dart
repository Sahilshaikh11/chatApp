import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmedPwController = TextEditingController();
  // toggle to register page
  final void Function()? onTap;
  RegisterPage({super.key, this.onTap});

  void register(BuildContext context) {
    final _auth = AuthService();

    if (_pwController.text == _confirmedPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } 
    
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // logo
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 50),

          // welcome text
          Text(
            "Let's create an account for you!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 25),

          // email text field
          MyTextfield(
            hintText: 'Email',
            obscureText: false,
            controller: _emailController,
          ),

          const SizedBox(height: 10),

          // password text field
          MyTextfield(
              hintText: 'Password',
              obscureText: true,
              controller: _pwController),

          const SizedBox(height: 10),

          // confirm pw text field
          MyTextfield(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmedPwController),

          const SizedBox(height: 25),

          // login button
          MyButton(
            text: 'Register',
            onTap: () => register(context),
          ),

          const SizedBox(height: 25),

          // register button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already a member? ",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: const Text(
                  "Login now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
