import 'dart:io';
import 'package:flutter/material.dart';

import 'package:flutter_14_firebase/widgets/user_image_picker.dart';

class AuthFormWidget extends StatefulWidget {
  const AuthFormWidget(this.submitFn, this.isLoading, {Key? key})
      : super(key: key);

  final bool isLoading; // To show CircularProgressIndicator
// This is function is used to pass values to function created in auth_Screen
  final void Function(String email, String username, String password,
      File _finalImg, bool isLogin, BuildContext ctx) submitFn;

  @override
  State<AuthFormWidget> createState() => _AuthFormWidgetState();
}

class _AuthFormWidgetState extends State<AuthFormWidget> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true; // For changing state according to login & signup
  var userEmail = ''; // to store user email from form
  var userName = ''; // to store user name from form
  var userPassword = ''; // to store user password from form
  File?
      _passedImg; // To store the image passed by user_image_picker.dart & send to DB

  void _storingForwadedImg(File img) {
    _passedImg = img;
  }

  void _trySubmitting() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context)
        .unfocus(); // This is remove focus from all texField & hide the soft keybaord
    if (_passedImg == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('PLease pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return; // Dont save the form, coz the image is empty
    }

    if (isValid) {
      _formKey.currentState!.save();
// Passing the requred args by the func...
      widget.submitFn(
        userEmail
            .trim(), // * So that we dont send any white spaces from start and end and stop unwanted error
        userName.trim(),
        userPassword.trim(),
        _passedImg!,
        isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (!isLogin) UserImagePicker(_storingForwadedImg),
                TextFormField(
                  key: const ValueKey(
                      'email'), // * so that when we switch to login from signup the username value should not be placed in password field, key will help flutter differentiate between them
                  autocorrect: false,
                  textCapitalization:
                      TextCapitalization.none, // Dont capitalize anything
                  enableSuggestions: false,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userEmail = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                ),
                if (!isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter 4 characters username';
                      }
                      return null;
                    },
                    autocorrect: true,
                    textCapitalization:
                        TextCapitalization.words, // Make the first word capital
                    enableSuggestions: false,
                    onSaved: (value) {
                      userName = value!;
                    },
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be atleast 7 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    userPassword = value!;
                  },
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: _trySubmitting,
                    child: Text(isLogin ? 'Login' : 'Signup'),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    child: Text(isLogin
                        ? 'Create a new account'
                        : 'I alreay have a account'),
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                  ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
