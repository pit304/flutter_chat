import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/auth/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  final bool isLoading;

  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImageFile == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      // Use values to send auth request
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (!_isLogin) UserImagePicker(_pickedImage),
            TextFormField(
              autofillHints: _isLogin
                  ? [AutofillHints.username]
                  : [AutofillHints.newUsername],
              key: ValueKey('email'),
              validator: (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address.';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email address',
              ),
              onSaved: (value) {
                _userEmail = value;
              },
            ),
            if (!_isLogin)
              TextFormField(
                key: ValueKey('username'),
                validator: (value) {
                  if (value.isEmpty || value.length < 4) {
                    return 'Please enter at least 4 characters.';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Username'),
                onSaved: (value) {
                  _userName = value;
                },
              ),
            TextFormField(
              autofillHints: _isLogin
                  ? [AutofillHints.password]
                  : [AutofillHints.newPassword],
              key: ValueKey('password'),
              validator: (value) {
                if (value.isEmpty || value.length < 7) {
                  return 'Password must be at least 7 characters long.';
                }
                return null;
              },
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSaved: (value) {
                _userPassword = value;
              },
            ),
            SizedBox(
              height: 12,
            ),
            if (widget.isLoading) CircularProgressIndicator(),
            if (!widget.isLoading)
              RaisedButton(
                onPressed: _trySubmit,
                child: Text(_isLogin ? 'Login' : 'Signup'),
              ),
            if (!widget.isLoading)
              FlatButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                textColor: Theme.of(context).primaryColor,
                child: Text(_isLogin
                    ? 'Create new account'
                    : 'I already have an account'),
              ),
          ],
        ),
      ),
    );
  }
}
