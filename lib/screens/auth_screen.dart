import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  /// We pass and use this in [auth_form.dart], coz the buttons are managed there, but the state is managed here so we will pass [isLoading] value to that file and use it to show circularProgressIndicator or Elevated button
  var isLoading = false;
  final _auth = FirebaseAuth
      .instance; // FirebaseAuth instance which will handle all firebase features

  // This values are passed in auth_form widget
  void _submitAuthForm(String email, String username, String password,
      File image, bool isLogin, BuildContext widgetContext) async {
    UserCredential
        authResult; // to store auth Result returned from signup & login
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // before storing user data we store the image so that we can use also store the image path in  user data
        //  .ref() -> create a refernce to path in the  bucket.
        // .child() -> Creates a folder named user_image
        // .child() -> Creates a file names as userID + .jpg
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');
        // We want to await this, since putFile doesn't return any future we use .then to get a future then await the whole process to finish up
        await ref.putFile(image).then((p0) => null);
        // Getting the url which we going to store in meta-data with users collection
        final url = await ref.getDownloadURL();

        /// * Coz firebase supports only email and password and i also want to store userName.
        /// * Here we create 'users' collection on a fly
        /// * We dont use .add() becuase we dont want to have new id geenerated by firebase instead i wanted to use the same userId returned by the firebase as document id here
        /// * So we used .doc(current UID passed)
        /// * we set data using set, i passed email also just incase you to know exactly whos username it is, it is mandatory
        //to store some extra data during signup like usrname,etc
        //store the data in cloudFireStore immediatley after signup.
        //.collection()->creates a collection if not exists
        //.doc()->create a document with  an id
        //.set()->a Map to set the fields inside user documents
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'imageUrl': url,
        });
      }
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'An error ocurred. Please check your credentials.';
      if (error.message != null) {
        errorMessage = error.message!;
      }
      // stop the spinner if error eccured
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: widgetContext,
          builder: (widgetContext) => AlertDialog(
                content: Text(errorMessage),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(widgetContext).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ));
    } catch (error) {
      // Stop the spinner if error occured
      setState(() {
        isLoading = false;
      });
      // Write error logic here.... print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthFormWidget(_submitAuthForm, isLoading),
    );
  }
}
