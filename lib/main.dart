import 'package:early_warning_system/screens/home_page.dart';
import 'package:early_warning_system/screens/signin_signup_page.dart';
import 'package:early_warning_system/services/firebase_auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Firebase Auth",
      home: new MyAppHome(auth: new MyAuth()),
    );
  }
}
//hey

class MyAppHome extends StatefulWidget{
  MyAppHome({this.auth});
  AuthFunc auth;

  @override
  State<StatefulWidget> createState() => new _MyAppHomeState();
}

enum AuthStatus{
  NOT_LOGIN,
  NOT_DETERMINED,
  LOGIN
}

class _MyAppHomeState extends State<MyAppHome>{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "", _userEmail = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getCurrentUser().then((user)
    {
      setState(() {
        if(user != null){
          _userId = user?.uid;
          _userEmail = user?.email;
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch (authStatus)
    {
      case AuthStatus.NOT_DETERMINED:
        return _showLoading();
        break;
      case AuthStatus.NOT_LOGIN:
        return  new SignInSignUpPage(auth: widget.auth, onSignedIn: _onSignedIn);
        break;
      case AuthStatus.LOGIN:
        if(_userId.length > 0 && _userId != null)
          return new HomePage(
              userId: _userId,
              userEmail: _userEmail,
              auth:widget.auth,
              onSignOut: _onSignOut
          );
        else
          return _showLoading();
        break;
      default:
        return _showLoading();
    }
  }

  void _onSignOut(){
    setState(() {
      authStatus = AuthStatus.NOT_LOGIN;
      _userId = _userEmail = "";
    });
  }

  void _onSignedIn(){
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
        _userEmail = user.email.toString();
      });

      setState(() {
        authStatus = AuthStatus.LOGIN;
      });
    });
  }
}

Widget _showLoading() {
  return Scaffold(body: Container(
    alignment: Alignment.center, child: CircularProgressIndicator(),),);
}




