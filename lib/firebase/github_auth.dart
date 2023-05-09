import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:tinder_itc/keys.dart' as keys;

class GithubAuth {

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
          await FirebaseAuth.instance.signInWithCredential(gitAuthCredential);
          return 'successful-register';
        } on FirebaseAuthException catch (e) {
          return e.code;
        }
      } break;

      case GitHubSignInResultStatus.cancelled:{
        return 'sign-in-cancelled';
      }

      case GitHubSignInResultStatus.failed:{
        return 'sign-in-failed';
      }

    }
  }
}