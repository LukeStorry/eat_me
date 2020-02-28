import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserIcon extends StatefulWidget {
  @override
  _UserIconState createState() => _UserIconState();
}

class _UserIconState extends State<UserIcon> {
  final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
      clientId:
          "252348121952-v0jf8mfg96o530mo5q4ps6rfiltkvphe.apps.googleusercontent.com");
  final _auth = FirebaseAuth.instance;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    user = await _auth.currentUser();
    setState(() {});
  }

  Future<void> signIn() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _auth.signInWithCredential(credential);
    initUser();
  }

  void signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: user == null
          ? Text("Sign In")
          : new Row(children: <Widget>[
              Text("${user?.displayName}  "),
              new CircleAvatar(
                  backgroundImage: NetworkImage("${user?.photoUrl}")),
            ]),
      onPressed: () => user == null ? signIn() : signOut(),
    );
  }
}
