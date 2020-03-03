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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _signIn() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _auth.signInWithCredential(credential);
    print("User Signed In");
  }

  void _signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    print("User Signed Out");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active)
            return CircularProgressIndicator();

          var user = snapshot.data;
          if (user == null)
            return FlatButton(
                child: Text("Sign In", style: TextStyle(color: Colors.white)),
                onPressed: () => _signIn());

          return FlatButton(
            child: Row(children: <Widget>[
              // TODO make dropdown menu
              Text("${user.displayName}  ",
                  style: TextStyle(color: Colors.white)),
              new CircleAvatar(
                  backgroundImage: NetworkImage("${user.photoUrl}")),
            ]),
            onPressed: () => _signOut(),
          );
        });
  }
}
