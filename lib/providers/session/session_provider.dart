import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:narrativa/models/models.dart';
import 'package:narrativa/services/services.dart';
import 'package:narrativa/static/static.dart';

class SessionProvider extends ChangeNotifier {
  SessionProvider({required this.sessionService, required this.apiService});

  final SessionService sessionService;
  final ApiService apiService;

  SessionState _state = SessionState();
  SessionState get state => _state;

  Future<bool> register(RegisterPayload payload) async {
    _updateState(state.copyWith(status: SessionStatus.loadingRegister));
    try {
      final registerResult = await apiService.register(payload);

      if (registerResult.error) {
        _updateState(
          state.copyWith(
            status: SessionStatus.error,
            errorMessage: registerResult.message,
          ),
        );

        return false;
      }

      final loginPayload = LoginPayload(
        email: payload.email,
        password: payload.password,
      );
      final isLoggedIn = await login(loginPayload);
      if (!isLoggedIn) {
        _updateState(
          state.copyWith(
            status: SessionStatus.error,
            errorMessage: "Failed to login after registration.",
          ),
        );

        return false;
      }

      return true;
    } on DioException catch (de) {
      _updateState(
        state.copyWith(
          status: SessionStatus.error,
          errorMessage: apiService.parseDioException(de),
        ),
      );

      return false;
    } catch (e) {
      _updateState(
        state.copyWith(status: SessionStatus.error, errorMessage: e.toString()),
      );

      return false;
    }
  }

  Future<bool> login(LoginPayload payload) async {
    _updateState(state.copyWith(status: SessionStatus.loadingLogin));
    try {
      final login = await apiService.login(payload);
      
      if (login.error) {
        _updateState(
          state.copyWith(
            status: SessionStatus.error,
            errorMessage: login.message,
          ),
        );

        return false;
      }

      final loginResult = login.loginResult;
      await sessionService.saveSession(loginResult);
      _updateState(
        state.copyWith(
          status: SessionStatus.loggedIn,
          loginResult: loginResult,
        ),
      );

      return true;
    } on DioException catch (de) {
      _updateState(
        state.copyWith(
          status: SessionStatus.error,
          errorMessage: apiService.parseDioException(de),
        ),
      );

      return false;
    } catch (e) {
      _updateState(
        state.copyWith(status: SessionStatus.error, errorMessage: e.toString()),
      );

      return false;
    }
  }

  void _updateState(SessionState state) {
    _state = state;
    notifyListeners();
  }
}
