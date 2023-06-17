import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  static const apiKey = '?key=AIzaSyCCZrB4cUxYue1WNE7s8xjrgn0j32rogmk';
  static const signUpUrlSegment = 'signUp';
  static const signInUrlSegment = 'signInWithPassword';
  static const authenticateUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:';

  String? _token;
  DateTime? _expiryDate;
  late String _userId;

  bool get isAuthenticated => token != null;

  String? get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now())) return _token;

    return null;
  }

  String? get userId => _userId;

  Future<void> _authenticate({
    required String email,
    required String password,
    required String urlSegment,
  }) async {
    try {
      final response = await post(
        Uri.parse('$authenticateUrl$urlSegment$apiKey'),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseBody = json.decode(response.body);

      if (responseBody['error'] != null) {
        // What's the idea behind throwing an exception here?
        // We can of course now manage or handle that exception in the AuthScreen
        // which is where we're in the widget and where we can present something
        // to the user, show an alert to the user for example.
        final String error = responseBody['error']['message'];
        var errorMessage = 'Authentication failed!';

        if (error.contains('EMAIL_EXISTS')) {
          errorMessage = 'This email address is already in use!';
        } else if (error.contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        } else if (error.contains('INVALID_EMAIL')) {
          errorMessage = 'This is not a valid email address.';
        } else if (error.contains('INVALID_PASSWORD')) {
          errorMessage = 'Invalid password!';
        } else if (error.contains('WEAK_PASSWORD')) {
          errorMessage = 'This password is too weak.';
        }

        throw HttpException(message: errorMessage);
      }

      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.tryParse(responseBody['expiresIn']) ?? 0));
      notifyListeners();
    } on HttpException {
      rethrow;
    } catch (error) {
      throw HttpException(
        message: 'Could not authenticate you. Please try again later!',
      );
    }
  }

  // We return this future because this is the future which actually wraps our
  // HTTP request and waits for it to complete.
  // So, in order to have our loading spinner work correctly, we want to return
  // the future which actually does the work.
  // Without return, we would also return a future but this wouldn't wait for
  // the future of authenticate to do its job.
  Future<void> signUp({
    required String email,
    required String password,
  }) async =>
      _authenticate(
        email: email,
        password: password,
        urlSegment: signUpUrlSegment,
      );

  Future<void> signIn({
    required String email,
    required String password,
  }) async =>
      _authenticate(
        email: email,
        password: password,
        urlSegment: signInUrlSegment,
      );

  void signOut() {
    _token = null;
    _expiryDate = null;
    notifyListeners();
  }
}
