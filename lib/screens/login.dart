import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:dtmgtt/services/auth_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _resetPasswordKey = GlobalKey<FormBuilderState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 300,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 30.0, color: Colors.grey),
                            ),
                            SizedBox(height: 50.0),
                            FormBuilderTextField(
                              name: 'Email',
                              decoration: InputDecoration(labelText: 'Email'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                                FormBuilderValidators.email(context),
                              ]),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            FormBuilderTextField(
                              name: 'Password',
                              obscureText: true,
                              maxLines: 1,
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 20,
                              child: Text(
                                '$error',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Reset Password'),
                                              content: FormBuilder(
                                                key: _resetPasswordKey,
                                                child: FormBuilderTextField(
                                                  name: 'resetPassword',
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Enter your password'),
                                                ),
                                              ),
                                              actions: [
                                                FlatButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    'Reset',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                  onPressed: () {
                                                    String resetEmail = _resetPasswordKey.currentState.fields['resetPassword'].value;
                                                    if (resetEmail != null) {
                                                      AuthService()
                                                          .forgotPassword(
                                                              resetEmail);
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Password has been reset'),
                                                              content: Text(
                                                                  'Please check your email to reset your password. If you dont recieve an email please check your junk folder'),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: Text(
                                                                    'Close',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(color: Colors.grey),
                                    )),
                                FlatButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.saveAndValidate()) {
                                      setState(() {
                                        loading = true;
                                      });
                                      String email = _formKey.currentState.fields['Email'].value;
                                      String password = _formKey.currentState.fields['Password'].value;
                                      try {
                                        UserCredential result = await _auth.signInWithEmailAndPassword(email: email.trim(),password: password);
                                        User user = result.user;
                                        AuthService().userFromFirebaseUser(user);
                                      } catch (e) {
                                        setState(() {
                                          loading = false;
                                          error = 'Incorrect Login Details';
                                        });
                                      }
                                    }
                                  },
                                  color: Colors.blueAccent,
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            //  RaisedButton(
                            //       onPressed: (){
                            //         UserDatabase().createUser(
                            //           uid: 'KpxKgnC9lWeTLaG7tvKrAKtI6ge2',
                            //           name: 'Jax',
                            //           userType: 'worker',
                            //           walletValue: 100,
                            //         );
                            //       },
                            //       child: Text('Create user'),
                            //     )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}