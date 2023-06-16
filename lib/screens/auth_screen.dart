import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

enum AuthMode { signUp, signIn }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              width: deviceSize.width,
              height: deviceSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 94,
                      ),
                      transform: Matrix4.rotationZ(-8 * pi / 100)
                        ..translate(-10.0), // must be double value
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Anton',
                          color: Theme.of(context)
                              .accentTextTheme
                              .headline6!
                              .color,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  AuthCardState createState() => AuthCardState();
}

class AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.signIn;
  final _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  //! Remember to make it Future to display the Loading Spinner
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    if (_authMode == AuthMode.signIn) {
      // Log user in
      await Provider.of<Auth>(context, listen: false).signIn(
        email: _authData['email']!,
        password: _authData['password']!,
      );
    } else {
      // Sign user up
      await Provider.of<Auth>(context, listen: false).signUp(
        email: _authData['email']!,
        password: _authData['password']!,
      );
    }

    setState(() => _isLoading = false);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.signIn) {
      setState(() => _authMode = AuthMode.signUp);
    } else {
      setState(() => _authMode = AuthMode.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8,
      child: Container(
        height: _authMode == AuthMode.signUp ? 320 : 260,
        width: deviceSize.width * 0.75,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signUp ? 320 : 260),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['email'] = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['password'] = value!,
                ),
                if (_authMode == AuthMode.signUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.signUp,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.signUp
                        ? (value) {
                            return value != _passwordController.text
                                ? 'Passwords do not match!'
                                : null;
                          }
                        : null,
                  ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          _authMode == AuthMode.signIn ? 'SIGN IN' : 'SIGN UP',
                        ),
                      ),
                TextButton(
                  onPressed: _switchAuthMode,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 4,
                    ),
                  ),
                  child: Text(
                    '${_authMode == AuthMode.signIn ? 'SIGN UP' : 'SIGN IN'} INSTEAD',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
