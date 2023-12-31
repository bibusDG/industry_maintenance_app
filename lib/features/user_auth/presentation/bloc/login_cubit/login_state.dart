part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loginProgress() = _LoginProgress;
  const factory LoginState.loginSuccess(String uid) = _LoginSuccess;
  const factory LoginState.loginFailure(String message) = _LoginFailure;
}
