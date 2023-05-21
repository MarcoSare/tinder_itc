import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinder_itc/firebase/database.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/user_preferences_dev.dart';

class EmailAuth {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createUserWithEmailAndPass({
    required String email, 
    required String password
    }
  ) async {
    try{
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      userCredential.user!.sendEmailVerification();
      return 'user-registered';
    }on FirebaseAuthException catch (e){
      return e.code;
    }
  }

  Future<String> signInWithEmailAndPass({
    required email, 
    required password
  }) async{
    try{
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      if(userCredential.user!.emailVerified){
        /* userCredential.user!.sendEmailVerification(); */
        //agregar información del usuario al provider o preferencias de usuario (SharedPreferences)

        await Database.saveUserPrefs(userCredential);

        return 'logged-in-successfully';
      } return 'email-not-verified';
    } on FirebaseAuthException catch (e){
      return e.code;
    }
  }

  Future<String> resendVerification({
    required email,
    required password
  }) async{
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );

      if(userCredential.user!.emailVerified==false){
        userCredential.user!.sendEmailVerification();
        return 'email-resent';
      } return 'email-already-verified';
    } catch (e) {
      return 'error';
    }
  }


  Future<String> signOutFromEmail() async {
    try{
      await FirebaseAuth.instance.signOut();
      return 'successful-sign-out';
    } on FirebaseAuthException catch (e){
      return e.code;
    }
  }

}