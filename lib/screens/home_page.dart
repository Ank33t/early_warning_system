import 'package:early_warning_system/services/firebase_auth_utils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{

  AuthFunc auth;
  VoidCallback onSignOut;
  String userId,userEmail;

  HomePage({Key key, this.auth, this.onSignOut, this.userId, this.userEmail}):super(key:key);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>{
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _emailVerified = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text('Flutter Authentication Email'),
        actions: <Widget>[FlatButton(child: Text('SignOut'), onPressed: _signOut),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: Text('Hello ' + widget.userEmail),),
          new Center(
            child: Text('Id:  ' + widget.userId),)
        ],
      ),
    );
  }

  void _checkEmailVerification() async {
    _emailVerified = await widget.auth.emailVerified();
    if(!_emailVerified)
      _showVerifyEmailDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: new Text('Please verify your email'),
        content: new Text('We need you to verify your email to continue use this app'),
        actions: <Widget>[
          new FlatButton(onPressed: (){
            Navigator.of(context).pop();
            _sendVerifyEmail();
          }, child: Text('Send')),
          new FlatButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text('Dismiss'))
        ],
      );
    });
  }

  void _sendVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailSentDialog() {
    showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text('Thank you'),
            content: new Text('Verification link has been sent to your email'),
            actions: <Widget>[
              new FlatButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('OK'))
            ],
          );
        });
  }

  void _signOut() async{
    try{
      await widget.auth.signOut();
      widget.onSignOut();
    }catch(e){
      print(e);
    }
  }
}