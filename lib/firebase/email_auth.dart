import 'package:firebase_auth/firebase_auth.dart';

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
      //agregar los datos del usuario (foto, intereses, descripción, estado civil, etc...) a Firebase
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
        //agregar información del usuario al provider o preferencias de usuario (SharedPreferences)
        return 'logged-in-successfully';
      } return 'email-not-verified';
    } on FirebaseAuthException catch (e){
      return e.code;
    }
  }
}