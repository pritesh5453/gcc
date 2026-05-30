import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models_nServices/verify_otp/verify_model.dart';


class PreferencesService {
  static Future<void> saveVerifyOtpModel(VerifyOtpModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferencesKey.isLoggedIn, model.status ?? false);
    if (model.token != null) {
      await prefs.setString(PreferencesKey.authToken, model.token!);
    }

    final user = model.user;
    if (user != null) {
      if (user.id != null) await prefs.setInt(PreferencesKey.userId, user.id!);
      if (user.name != null) await prefs.setString(PreferencesKey.userName, user.name!);
      if (user.email != null) await prefs.setString(PreferencesKey.userEmail, user.email!);
      if (user.phone != null) await prefs.setString(PreferencesKey.userMobile, user.phone!);
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PreferencesKey.isLoggedIn) ?? false;
  }

  static Future<Map<String, dynamic>?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(PreferencesKey.isLoggedIn) ?? false;
    if (!loggedIn) return null;

    return {
      'token': prefs.getString(PreferencesKey.authToken),
      'id': prefs.getInt(PreferencesKey.userId),
      'name': prefs.getString(PreferencesKey.userName),
      'email': prefs.getString(PreferencesKey.userEmail),
      'phone': prefs.getString(PreferencesKey.userMobile),
    };
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(PreferencesKey.isLoggedIn);
    await prefs.remove(PreferencesKey.authToken);
    await prefs.remove(PreferencesKey.userId);
    await prefs.remove(PreferencesKey.userName);
    await prefs.remove(PreferencesKey.userEmail);
    await prefs.remove(PreferencesKey.userMobile);
    await prefs.remove(PreferencesKey.userGender);
    await prefs.remove(PreferencesKey.userProfileImage);
  }
}
