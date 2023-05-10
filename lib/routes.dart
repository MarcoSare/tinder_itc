import 'package:flutter/material.dart';
import 'package:tinder_itc/screens/forgot_password_screen.dart';
import 'package:tinder_itc/screens/login.dart';
import 'package:tinder_itc/screens/register_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    '/login':(BuildContext context) => const Login(),
    '/register':(BuildContext context) => const RegisterScreen(),
    '/forgot_password':(BuildContext context) => const ForgotPasswordScreen(),
  };
}