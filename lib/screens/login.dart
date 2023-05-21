import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:tinder_itc/app_preferences.dart';
import 'package:tinder_itc/firebase/email_auth.dart';
import 'package:tinder_itc/firebase/github_auth.dart';
import 'package:tinder_itc/firebase/google_auth.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/provider/user_provider.dart';
import 'package:tinder_itc/responsive.dart';
import 'package:tinder_itc/user_preferences_dev.dart';
import 'package:tinder_itc/widgets/alert_widget.dart';
import 'package:tinder_itc/widgets/text_email_widget.dart';
import 'package:tinder_itc/widgets/text_pass_widget.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late AlertWidget al;
  DateTime? currenBackTime;

  @override
  Widget build(BuildContext context) {
    TextEmailWidget txtEmail = TextEmailWidget(
        'Correo', 'Ingresa tu correo', 'Ingresa un correo valido');
    TextPassWidget txtPass = TextPassWidget();
    EmailAuth _emailAuth = EmailAuth();
    GoogleAuth _googleAuth = GoogleAuth();
    GithubAuth _githubAuth = GithubAuth();
    al = AlertWidget(context: context);

    final userProvider = Provider.of<UserProvider>(context,listen: false);
    

    final btnResend = TextButton(
      onPressed: (){
        _emailAuth.resendVerification(
          email: txtEmail.controlador, 
          password: txtPass.controlador
        ).then((value) {
          if(value=='email-resent'){
            Fluttertoast.showToast(
              msg: 'Email reenviado correctamente',
              gravity: ToastGravity.CENTER_RIGHT,
              backgroundColor: Colors.black
            );
            print('resent');
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


    final btnRedirectReg = ElevatedButton(
      onPressed: (){
        Navigator.pushNamed(context, '/register');
      },
      child: const Text('Completar registro')
    );


    List<Widget> optionsResend = [
      btnResend,
      btnOk
    ];

    final btnGoogle = SocialLoginButton(
      buttonType: SocialLoginButtonType.google,
      mode:SocialLoginButtonMode.multi, 
      onPressed: (){
        _googleAuth.signInWithGoogle().then((value) {
          if(value=='logged-successful'){
            //redireccionar al dashboard
            AlertWidget.showMessage(context, 'Acceso exitoso', 'Has ingresado a tu cuenta');
            userProvider.setUserData(UserPreferencesDev.getUserObject());
            
          }else if(value=='logged-without-info'){
            //redireccionar al register_screen - RegisterScreen debe 
            AlertWidget.showMessageWithActions(context, 'Creación exitoso', 'Tu cuenta de google ha sido creada correctamente, procede a completar el registro porfavor', [btnRedirectReg]);
          }
        });
      },
      borderRadius: 15,
    );

    final btnFacebook = SocialLoginButton(
      buttonType: SocialLoginButtonType.facebook,
      mode: SocialLoginButtonMode.multi,
      onPressed: () {},
      borderRadius: 15,
    );

    final btnGithub = SocialLoginButton(
      buttonType: SocialLoginButtonType.github, 
      mode:SocialLoginButtonMode.multi,
      onPressed: (){
        _githubAuth.signInWithGitHub(context).then((value) {
          if(value=='logged-succesful'){
            AlertWidget.showMessage(context, 'Inicio de sesión exitoso', 'Continua con tu experiencia...');
            userProvider.setUserData(UserPreferencesDev.getUserObject());
          }else if(value=='logged-without-info'){
            AlertWidget.showMessageWithActions(context, 'Registro exitoso', 'Tu cuenta  ha sido creada correctamente', [btnRedirectReg]);
          }else if(value=='account-exists-with-different-credential'){
            AlertWidget.showMessage(context, 'Error al iniciar sesión', 'Parece que el correo que estas intentando utilizar ya esta vinculada con otra cuenta...');
          }
        });
      },
      borderRadius: 15,
    );

    final btnEmail =  SocialLoginButton(
      buttonType: SocialLoginButtonType.generalLogin,
      mode: SocialLoginButtonMode.single,
      onPressed: () {
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
                AlertWidget.showMessage(context, 'Error', 'Tus credenciales de inicio de sesión no coinciden con ninguna cuenta en nuestro sistema... ');
              break;

              case 'invalid-email':
                AlertWidget.showMessage(context, 'Error', 'Tus credenciales de inicio de sesión no coinciden con ninguna cuenta en nuestro sistema... ');
              break;

              case 'user-not-found':
                AlertWidget.showMessage(context, 'Error', 'Tus credenciales de inicio de sesión no coinciden con ninguna cuenta en nuestro sistema... ');
              break;

              case 'email-not-verified':
                AlertWidget.showMessageWithActions(context, 'Error', 'Parece que aún no vertificas tu email...', optionsResend);
              break;

              default:
                userProvider.setUserData(UserPreferencesDev.getUserObject());
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
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Text('Crear cuenta')),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/forgot_password');
          }, 
          child: const Text('Recuperar contraseña')
        ),
      ],
    );

    final formEmailPass = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [txtEmail, txtPass, btnEmail],
    );

    final rowSocial = SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [btnGoogle, btnFacebook, btnGithub],
      ),
    );

    final rowDivider = Row(
      children: const <Widget>[
        Expanded(child: Divider()),
        Text('Or continue with:'),
        Expanded(child: Divider()),
      ],
    );

    Widget formLogin(BuildContext context, Column form, SizedBox social,
        Row divider, Row options) {
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
                      image: AssetImage('assets/images/logo_tinder_itc.png'),
                      fit: BoxFit.fill)),
            ),
            form,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: options,
            ),
            divider,
            social,
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/update_profile');
            }, child: Text('update profile')),
            ElevatedButton(onPressed: (){ 
              UserModel model = userProvider.getUserData() ?? UserModel();
              print(model.toJson());
            }, child: Text('USER Pefs'))
          ],
        ),
      );
    }

    Future<bool> onWillPop() async {
      DateTime now = DateTime.now();
      if(currenBackTime == null || now.difference(currenBackTime!)> const Duration(seconds: 15)){
        currenBackTime = now;
        Fluttertoast.showToast(msg: '¿Seguro que quieres salir?');
        return false;
      }else{
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return false;
      }
    }

    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Responsive(
            mobile: MobileViewScreen(
              formLogin: formLogin(
                context, formEmailPass, rowSocial, rowDivider, rowOptions
                )
              ),
            desktop: DesktopViewScreen(
              formLogin: formLogin(
                context, formEmailPass, rowSocial, rowDivider, rowOptions
              ) 
            )
          ),
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
                        fit: BoxFit.fill)),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: formLogin,
                ),
              ))
        ],
      ),
    );
  }
}
