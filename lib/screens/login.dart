import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:tinder_itc/firebase/email_auth.dart';
import 'package:tinder_itc/firebase/github_auth.dart';
import 'package:tinder_itc/firebase/google_auth.dart';
import 'package:tinder_itc/models/user_model.dart';
import 'package:tinder_itc/responsive.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEmailWidget txtEmail = TextEmailWidget(
        'Correo', 'Ingresa tu correo', 'Ingresa un correo valido');
    TextPassWidget txtPass = TextPassWidget();
    EmailAuth _emailAuth = EmailAuth();
    GoogleAuth _googleAuth = GoogleAuth();
    GithubAuth _githubAuth = GithubAuth();
    al = AlertWidget(context: context);

    final btnResend = TextButton(
        onPressed: () {
          _emailAuth
              .resendVerification(
                  email: txtEmail.controlador, password: txtPass.controlador)
              .then((value) {
            if (value == 'email-resent') {
              Fluttertoast.showToast(
                  msg: 'Email reenviado correctamente',
                  gravity: ToastGravity.CENTER_RIGHT,
                  backgroundColor: Colors.black);
              print('resent');
            }
          });
        },
        child: const Text('Reenviar verificación'));

    final btnOk = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Ok'));

    final btnRedirectReg = ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register');
        },
        child: const Text('Completar registro'));

    List<Widget> optionsResend = [btnResend, btnOk];

    final btnGoogle = SocialLoginButton(
      buttonType: SocialLoginButtonType.google,
      mode: SocialLoginButtonMode.multi,
      onPressed: () {
        _googleAuth.signInWithGoogle().then((value) {
          if (value == 'logged-successful') {
            //redireccionar al dashboard
            AlertWidget.showMessage(
                context, 'Acceso exitoso', 'Has ingresado a tu cuenta');
          } else if (value == 'logged-without-info') {
            //redireccionar al register_screen - RegisterScreen debe
            AlertWidget.showMessageWithActions(
                context,
                'Creación exitoso',
                'Tu cuenta de google ha sido creada correctamente, procede a completar el registro porfavor',
                [btnRedirectReg]);
          }
        });
      },
      borderRadius: 15,
    );

    List<String> careers = [
      'Ing. Sistemas Computacionales',
      'Ing. Mecatrónica',
      'Lic. Administración de Empresas',
      'Ing. Gestión Emprearial',
      'Ing. Bioquímica',
      'Ing. Qímica ',
      'Ing. Ambiental',
      'Ing. Industrial',
      'Ing. Mecánica'
    ];

    List<String> about = [
      'Viajero empedernido, amante de la fotografía y la naturaleza. Siempre en busca de nuevas aventuras y experiencias.',
      'Foodie en constante búsqueda del mejor plato de comida y del vino perfecto para acompañarlo. ¿Alguna recomendación?',
      'Amante de los animales y defensor de los derechos de los animales. Siempre dispuesto a apoyar a las causas que luchan por su bienestar.',
      'Emprendedor y soñador que cree en hacer realidad sus ideas y en crear un impacto positivo en el mundo.',
      'Fanático del cine y de las series, ¿cuál es tu película o serie favorita? ¡Cuéntame en los comentarios!',
      'Apasionado de la música y la guitarra. Siempre en busca de nuevos acordes y melodías para expresar mis sentimientos.',
      'Deportista y amante del fitness, siempre buscando nuevos retos para superarme a mí mismo.',
      'Curioso por naturaleza, me gusta aprender sobre diferentes temas y culturas. ¿Tienes alguna recomendación de un libro o un lugar para visitar?',
      'Amante del arte en todas sus formas, desde la pintura hasta el teatro y la danza. Siempre en busca de nuevas expresiones artísticas para inspirarme.',
      'Socialmente comprometido y activista, luchando por un mundo más justo y equitativo para todos. ¿Cuál es tu causa social favorita? ¡Comparte tus ideas en los comentarios!'
    ];

    List<String> getInter() {
      var rng = Random();
      int r = rng.nextInt(3);
      List<String> interests = [
        'cafe',
        'fiesta',
        'estudio',
        'comida',
        'películas',
        'deporte',
        'tv',
        'novelas',
        'musica',
        'pareja',
        'amigos',
        'casual',
        'cena',
        'gracioso',
        'libros',
        'netflix',
        'atardecer'
      ];
      List<String> filteredStrings = interests.where((item) {
        int r = rng.nextInt(3);
        return r == 0;
      }).toList();

      for (String name in filteredStrings) {
        print(name + "\n");
      }
      return filteredStrings;
    }

    final dio = Dio();
    final btnFacebook = SocialLoginButton(
      buttonType: SocialLoginButtonType.facebook,
      mode: SocialLoginButtonMode.multi,
      onPressed: () async {
        var rng = Random();
        final response = await dio.get('https://randomuser.me/api/');
        final data = response.data;
        //print(data['results'][0]['gender']);
        String name = data['results'][0]['name']['first'] +
            " " +
            data['results'][0]['name']['last'];
        String email = data['results'][0]['email'];
        String carrer = careers[rng.nextInt(8) + 1];
        int semester = rng.nextInt(11) + 1;
        String aboutMe = about[rng.nextInt(9) + 1];
        List<String> lista = getInter();
        String profile = data['results'][0]['picture']['large'];
        String gender = data['results'][0]['gender'];
        String birthdate = data['results'][0]['dob']['date'];
        createUser(name, email, carrer, semester, aboutMe, lista, profile,
            gender, birthdate);
      },
      borderRadius: 15,
    );

    final btnGithub = SocialLoginButton(
      buttonType: SocialLoginButtonType.github,
      mode: SocialLoginButtonMode.multi,
      onPressed: () {
        _githubAuth.signInWithGitHub(context).then((value) {
          if (value == 'logged-succesful') {
            AlertWidget.showMessage(context, 'Inicio de sesión exitoso',
                'Continua con tu experiencia...');
          } else if (value == 'logged-without-info') {
            AlertWidget.showMessageWithActions(context, 'Registro exitoso',
                'Tu cuenta  ha sido creada correctamente', [btnRedirectReg]);
          } else if (value == 'account-exists-with-different-credential') {
            AlertWidget.showMessage(context, 'Error al iniciar sesión',
                'Parece que el correo que estas intentando utilizar ya esta vinculada con otra cuenta...');
          }
        });
      },
      borderRadius: 15,
    );

    final btnEmail = SocialLoginButton(
      buttonType: SocialLoginButtonType.generalLogin,
      mode: SocialLoginButtonMode.single,
      onPressed: () {
        txtEmail.formKey.currentState!.save();
        txtPass.formKey.currentState!.save();
        if (txtEmail.controlador == '' || txtPass.controlador == '') {
          AlertWidget.showMessage(context, 'Error',
              'Porfavor, rellena todos los campos antes de poder continuar.');
        } else if (txtEmail.error == true) {
          AlertWidget.showMessage(context, 'Error',
              'Porfavor, ingresa una dirección de correo válida');
        } else if (txtPass.error == true) {
          AlertWidget.showMessage(
              context, 'Error', 'Porfavor, ingresa tu contraseña');
        } else {
          _emailAuth
              .signInWithEmailAndPass(
                  email: txtEmail.controlador, password: txtPass.controlador)
              .then((value) {
            switch (value) {
              case 'wrong-password':
                break;

              case 'invalid-email':
                break;

              case 'user-not-found':
                break;

              case 'email-not-verified':
                AlertWidget.showMessageWithActions(context, 'Error',
                    'Parece que aún no vertificas tu email...', optionsResend);
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
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: const Text('Crear cuenta')),
        TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/forgot_password');
            },
            child: const Text('Recuperar contraseña')),
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
        child: SingleChildScrollView(
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
              /* ElevatedButton(onPressed: (){ _googleAuth.signOutFromGoogle();}, child: Text('logout google')),
              ElevatedButton(onPressed: (){ _githubAuth.signOutFromGitHub();}, child: Text('logout git')) */
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Responsive(
          mobile: MobileViewScreen(
              formLogin: formLogin(
                  context, formEmailPass, rowSocial, rowDivider, rowOptions)),
          desktop: DesktopViewScreen(
              formLogin: formLogin(
                  context, formEmailPass, rowSocial, rowDivider, rowOptions))),
    );
  }

  Future createUser(name, email, carrer, semester, aboutMe, interest, profile,
      gender, birthday) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('usuarios').doc();
      final user = UserModel(
          name: name,
          email: email,
          carrer: carrer,
          semester: semester,
          aboutMe: aboutMe,
          interests: interest,
          gender: gender,
          birthdate: birthday,
          profilePicture: profile);
      final userJson = user.toJson();

      await docUser.set(userJson).then((value) {});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('La contraseña es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        print('El correo electrónico ya está en uso.');
      }
    } catch (e) {
      print(e);
    }
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
