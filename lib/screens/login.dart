import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:tinder_itc/firebase/email_auth.dart';
import 'package:tinder_itc/firebase/github_auth.dart';
import 'package:tinder_itc/firebase/google_auth.dart';
import 'package:tinder_itc/responsive.dart';
import 'package:tinder_itc/widgets/alert_widget.dart';
import 'package:tinder_itc/widgets/text_email_widget.dart';
import 'package:tinder_itc/widgets/text_pass_widget.dart';


class Login extends StatelessWidget {
  const Login({super.key});
  
  @override
  Widget build(BuildContext context) {
  
    TextEmailWidget txtEmail = TextEmailWidget('Email', 'Escribe email', 'Escribe email válido');
    TextPassWidget txtPass = TextPassWidget();
    EmailAuth _emailAuth = EmailAuth();
    GoogleAuth _googleAuth = GoogleAuth();
    GithubAuth _githubAuth = GithubAuth();

    final btnGoogle = SocialLoginButton(
      buttonType: SocialLoginButtonType.google,
      mode:SocialLoginButtonMode.multi, 
      onPressed: (){
        _googleAuth.signInWithGoogle().then((value) {
          if(value=='successful-register'){
            AlertWidget.showMessage(context, 'Registro exitoso', 'Tu cuenta de google ha sido creada correctamente');
          }else{
            print(value);
          }
        });
      },
      borderRadius: 15,
    );

    final btnFacebook = SocialLoginButton(
      buttonType: SocialLoginButtonType.facebook, 
       mode:SocialLoginButtonMode.multi,
      onPressed: (){

      },
      borderRadius: 15,
    );

    final btnGithub = SocialLoginButton(
      buttonType: SocialLoginButtonType.github, 
      mode:SocialLoginButtonMode.multi,
      onPressed: (){
        _githubAuth.signInWithGitHub(context).then((value) {
          if(value=='successful-register'){
            AlertWidget.showMessage(context, 'Registro exitoso', 'Tu cuenta de google ha sido creada correctamente');
          }else if(value=='account-exists-with-different-credential'){
            AlertWidget.showMessage(context, 'Error al iniciar sesión', 'Parece que el correo que estas intentando utilizar ya esta vinculada con otra cuenta...');
          }
        });
      },
      borderRadius: 15,
    );

    final btnResend = TextButton(
      onPressed: (){
        _emailAuth.resendVerification(
          email: txtEmail.controlador, 
          password: txtPass.controlador
        ).then((value) {
          if(value=='email-resent'){
            AlertWidget.showMessage(context, 'Exitoso', 'Correo de verificación reenviado correctamente');
          }
        });
      }, 
      child: const Text('Reenviar verificación')
    );

    final btnOk = TextButton(
      onPressed: (){
        Navigator.pop(context);
      }, 
      child: const Text('Ok')
    );

    final btnEmail =  SocialLoginButton(
      buttonType: SocialLoginButtonType.generalLogin,
      mode:SocialLoginButtonMode.single,
      onPressed: (){
        txtEmail.formKey.currentState!.save();
        txtPass.formKey.currentState!.save();
        if(txtEmail.controlador=='' || txtPass.controlador==''){
          AlertWidget.showMessage(context, 'Error', 'Porfavor, rellena todos los campos antes de poder continuar.');
        }else if(txtEmail.error==true){
          AlertWidget.showMessage(context, 'Error', 'Porfavor, ingresa una dirección de correo válida');
        }else if(txtPass.error==true){
          AlertWidget.showMessage(context, 'Error', 'Porfavor, ingresa tu contraseña');
        }else{
          _emailAuth.signInWithEmailAndPass(
            email: txtEmail.controlador, 
            password: txtPass.controlador
          ).then((value){
            switch(value){
              case 'wrong-password':

              break;

              case 'invalid-email':
              
              break;

              case 'user-not-found':

              break;

              case 'email-not-verified':

              break;
            }
          });
        }
      },
      borderRadius: 15,
    );

    final rowOptions = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: (){
            Navigator.pushNamed(context, '/register');
          }, 
          child: const Text('Crear cuenta')
        ),
        TextButton(
          onPressed: (){}, 
          child: const Text('Recuperar contraseña')
        ),
      ],
    );

    final formEmailPass = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        txtEmail,
        txtPass,
        btnEmail
      ],
    );

    final rowSocial = SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          btnGoogle,
          btnFacebook,
          btnGithub
        ],
      ),
    );

    final rowDivider = Row(
      children: const <Widget>[
        Expanded(child: Divider()),
        Text('Or continue with:'),
        Expanded(child: Divider()),
      ],
    );

    Widget formLogin(BuildContext context, Column form, SizedBox social, Row divider, Row options ){
      return SizedBox(
        width: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 200,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.fill
                )
              ),
            ),
            form,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: options,
            ),
            divider,
            social,
            ElevatedButton(onPressed: (){ _googleAuth.signOutFromGoogle();}, child: Text('logout google'))
          ],
        ),
      );
    }
  
    return Scaffold(
      body: Responsive(
        mobile: MobileViewScreen(
          formLogin: formLogin(context, formEmailPass, rowSocial, rowDivider, rowOptions)
        ), 
        desktop: DesktopViewScreen(
          formLogin: formLogin(context, formEmailPass, rowSocial, rowDivider, rowOptions)
        )
      ),
    );
  }
}

class MobileViewScreen extends StatelessWidget {
  const MobileViewScreen({super.key, required this.formLogin});

  final Widget formLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromARGB(85, 76, 175, 79),
      padding: const EdgeInsets.all(10),
      child: Center(
        child: SingleChildScrollView(
          child: formLogin,
        ),
      ),
    );
  }
}

class DesktopViewScreen extends StatelessWidget {
  const DesktopViewScreen({super.key, required this.formLogin});

  final Widget formLogin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo.png'),
                  fit: BoxFit.fill
                )
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: formLogin,
              ),
            )
          )
        ],
      ),
    );
  }
}