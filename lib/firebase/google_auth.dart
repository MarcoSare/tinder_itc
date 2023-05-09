import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth{
 GoogleSignIn? _googleSignIn;

 Future<String> signInWithGoogle() async {
  try {
    _googleSignIn =GoogleSignIn();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    
    await FirebaseAuth.instance.signInWithCredential(credential);//agregar credenciales a preferencias de usuario 

    return 'successful-register';
  } on FirebaseAuthException catch (e) {
      return e.code;
  }
 }

  Future<String> signOutFromGoogle() async{
    _googleSignIn=GoogleSignIn();
    try{
      await _googleSignIn?.disconnect();
      await FirebaseAuth.instance.signOut();
      //Limpiar preferencias de usuario?
      return 'succesful-sign-out';
    }on FirebaseAuthException catch (e){
      return e.code;
    }
  }

}