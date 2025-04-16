import 'package:narrativa/models/models.dart';
import 'package:narrativa/static/static.dart';

class SessionState {
  const SessionState({
    this.status = SessionStatus.initial,
    this.loginResult,
    this.errorMessage,
  });

  final SessionStatus status;
  final LoginResult? loginResult;
  final String? errorMessage;

  SessionState copyWith({
    SessionStatus? status,
    LoginResult? loginResult,
    String? errorMessage,
  }) {
    return SessionState(
      status: status ?? this.status,
      loginResult: loginResult ?? this.loginResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'SessionState(status: $status, loginResult: $loginResult, errorMessage: $errorMessage)';
  }
}
