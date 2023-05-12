import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:tinder_itc/keys.dart' as keys;

class GithubAuth {
  bool? hasData;

  Future<String> signInWithGitHub(BuildContext context) async {
    final GitHubSignIn gitSignIn = GitHubSignIn(
      clientId: keys.GIT_CLIENT_ID, 
      clientSecret: keys.GIT_CLIENT_SECRET, 
      redirectUrl: 'https://tinder-itc.firebaseapp.com/__/auth/handler'
    );

    final result = await gitSignIn.signIn(context);

    switch(result.status){
      case GitHubSignInResultStatus.ok:{
        try {
          final gitAuthCredential = GithubAuthProvider.credential(result.token!);
          final user = await FirebaseAuth.instance.signInWithCredential(gitAuthCredential);
          if(await hasUserData(user.user!.uid)){
            return 'logged-succesful';
          } return 'logged-without-info';
        } on FirebaseAuthException catch (e) {
          return e.code;
        }
      }

      case GitHubSignInResultStatus.cancelled:{
        return 'sign-in-cancelled';
      }

      case GitHubSignInResultStatus.failed:{
        return 'sign-in-failed';
      }

    }
  }

  Future<String> signOutFromGitHub() async {
    try{
      await FirebaseAuth.instance.signOut();
      return 'successful-sign-out';
    } on FirebaseAuthException catch (e){
      return e.code;
    }
  }

  Future<bool> hasUserData(String idUser) async {
    final userDoc = FirebaseFirestore.instance.collection('usuarios').doc(idUser);
    final snapshot = await userDoc.get();
    if(snapshot.exists){
      return true;
    } return false;
  }
}