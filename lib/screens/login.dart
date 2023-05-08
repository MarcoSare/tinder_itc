import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:tinder_itc/responsive.dart';
import 'package:tinder_itc/widgets/alert_widget.dart';
import 'package:tinder_itc/widgets/text_email_widget.dart';
import 'package:tinder_itc/widgets/text_pass_widget.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEmailWidget txtEmail = TextEmailWidget(
        'Correo', 'Ingresa tu correo', 'Ingresa un correo valido');
    TextPassWidget txtPass = TextPassWidget();

    final btnGoogle = SocialLoginButton(
      buttonType: SocialLoginButtonType.google,
      mode: SocialLoginButtonMode.multi,
      onPressed: () {},
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
      mode: SocialLoginButtonMode.multi,
      onPressed: () {},
      borderRadius: 15,
    );

    final btnEmail = SocialLoginButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      text: "Iniciar sesión",
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
          print(
              '''correo: ${txtEmail.controlador}\ncontraseña: ${txtPass.controlador}''');
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
        TextButton(onPressed: () {}, child: const Text('Recuperar contraseña')),
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
          ],
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
