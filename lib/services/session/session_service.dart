import 'package:shared_preferences/shared_preferences.dart';
import 'package:narrativa/models/models.dart';

class SessionService {
  const SessionService({required this.prefs});

  final SharedPreferences prefs;

  static final String _tokenKey = "token";
  static final String _nameKey = "name";

  Future<void> saveSession(LoginResult loginResult) async {
    await prefs.setString(_tokenKey, loginResult.token);
    await prefs.setString(_nameKey, loginResult.name);
  }

  LoginResult? loadSession() {
    final token = prefs.getString(_tokenKey);
    final name = prefs.getString(_nameKey);

    if (token != null && name != null) {
      return LoginResult(userId: null, name: name, token: token);
    }

    return null;
  }

  Future<bool> clearSession() async {
    final tokenRemoved = await prefs.remove(_tokenKey);
    final nameRemoved = await prefs.remove(_nameKey);
    return tokenRemoved && nameRemoved;
  }
}
