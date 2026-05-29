

import 'package:flutter/material.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';



class SplashServices {
  void checkAuthentication(BuildContext context) async {
    Future.delayed(const Duration(seconds: 1), () {
      if (AppPreference().getString(PreferencesKey.authToken).isEmpty ||
          AppPreference().getString(PreferencesKey.authToken) == "") {
        //Get.to(LangvangeSelection());
        
        // Navigator.pushReplacement( 
        //   context,
        //   MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
        // );
      } else {
      //  Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
      //     );
      
      }
      // Navigator.popAndPushNamed(context, RoutesName.loginscreen);
    });
  }
}
