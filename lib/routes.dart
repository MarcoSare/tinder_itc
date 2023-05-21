import 'package:flutter/material.dart';
import 'package:tinder_itc/screens/forgot_password_screen.dart';
import 'package:tinder_itc/screens/login.dart';
import 'package:tinder_itc/screens/register_screen.dart';
import 'package:tinder_itc/screens/update_profile_screen.dart';

Map<String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    '/login':(BuildContext context) => Login(),
    '/register':(BuildContext context) => const RegisterScreen(),
    '/forgot_password':(BuildContext context) => const ForgotPasswordScreen(),
    '/update_profile':(BuildContext context) => UpdateProfileScreen(),
  };
}