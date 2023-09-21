import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_role.dart';

class SharedPreferencesService {
  late SharedPreferences _prefs;

  SharedPreferencesService(UserRole userRole) {
    _userRole = userRole;
  }

  late UserRole _userRole;

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool isLoggedIn() {
    return _prefs.getBool('isLoggedIn') ?? false;
  }

  void saveUserDataToPrefs(String uid, String email, String identifier) {
    _prefs.setString('uid', uid);
    _prefs.setString('email', email);
    _prefs.setString('identifier', identifier);
    _prefs.setString('userRole', userRoleToString(_userRole));
  }
}
