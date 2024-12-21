import 'package:ecommerce/pages/home_page.dart';
import 'package:ecommerce/pages/login_page.dart';
import 'package:ecommerce/services/firebase/auth.dart';
import 'package:flutter/material.dart';

class RedirectionPage extends StatefulWidget {
  const RedirectionPage({Key? key}) : super(key: key);

  @override
  _RedirectionPageState createState() => _RedirectionPageState();
}

class _RedirectionPageState extends State<RedirectionPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        });
  }
}
