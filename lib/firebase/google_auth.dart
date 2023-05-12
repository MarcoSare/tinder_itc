import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuth{
 GoogleSignIn? _googleSignIn;
 bool? hasData;

 Future<String> signInWithGoogle() async {
  try {
    _googleSignIn =GoogleSignIn();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );

    //verificar si existe registro de usuario en Firestorage, si existe solo iniciar ssesión. si no existe redirigir a register_screen
    final user = await FirebaseAuth.instance.signInWithCredential(credential);//agregar credenciales a preferencias de usuario 
    
    if(await hasUserData(user.user!.uid)){
      return 'logged-successful';
    } return 'logged-without-info';

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

  Future<bool> hasUserData(String id) async {
    final docUser = FirebaseFirestore.instance.collection('usuarios').doc(id);
    final doc = await docUser.get();
    if(doc.exists){
        return true;
      }else{
        return false;
    }
  }
}