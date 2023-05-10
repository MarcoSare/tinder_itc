import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:tinder_itc/responsive.dart';
import 'package:tinder_itc/widgets/text_email_widget.dart';
import 'package:tinder_itc/widgets/text_form_widget.dart';
import 'package:tinder_itc/widgets/text_pass_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  @override
  Widget build(BuildContext context) {

    TextEmailWidget txtEmail = TextEmailWidget('Email', 'email', 'Ingresa un email válido');
    final ValueNotifier<bool> _sent = ValueNotifier<bool>(false);

    final btnRecovery = SocialLoginButton(
      buttonType: SocialLoginButtonType.generalLogin, 
      onPressed: () async {
        if(txtEmail.formKey.currentState!.validate()){
          await FirebaseAuth.instance.sendPasswordResetEmail(email: txtEmail.controlador).then((value) => _sent.value=true);
        }
      },
      borderRadius: 15,
      mode: SocialLoginButtonMode.single,
      text: 'Recuperar contraseña',
    );

    final form = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        txtEmail,
        btnRecovery
      ],
    );


    Widget recoveryData (Column form){
      return SizedBox(
        child: ValueListenableBuilder(
          valueListenable: _sent,
          builder: (context, value, _){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (_sent.value)?
                [
                  LottieBuilder.asset('assets/animation/email-sent.json', repeat: false,),
                  const Text(
                    'Hemos enviado un link a tu correo electrónico para restablecer tu contraseña!',
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  )
                ]:
                [
                  Container(
                    width: 250,
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo_tinder_itc.png'),
                        fit: BoxFit.fill
                      )
                    ),
                  ),
                  form
                ]
            );
          }
        ),
      );
    }

    return Scaffold(
      body: Responsive(
        mobile: MobileViewWidget(
          recoveryData: recoveryData(form),
        ),
        desktop: MobileViewWidget(recoveryData: recoveryData(form)),
      ),
    );
  }
}

class MobileViewWidget extends StatelessWidget {
  MobileViewWidget({super.key, required this.recoveryData});

  Widget recoveryData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Center(
        child: SingleChildScrollView(
          child: recoveryData,
        ),
      ),
    );
  }
}