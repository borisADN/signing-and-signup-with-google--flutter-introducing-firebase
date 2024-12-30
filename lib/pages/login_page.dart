import 'package:ecommerce/services/firebase/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  bool isLoading = false;
  bool _forLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.yellow,
        elevation: 12,
        title: Text(_forLogin ? "Login Page " : "Register Page"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter password' : null,
                ),
                SizedBox(height: 16),
                //confirmation password text field here
                if (!_forLogin)
                  TextFormField(
                    obscureText: true,
                    controller: _passwordConfirmationController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) return 'Confirm password';
                      // return value!.isEmpty ? 'Confirm password' : null;
                      if (_passwordController.text != value) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                // Perform login logic here
                                try {
                                  if (_forLogin) {
                                    await Auth().signInWithEmailAndPassword(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  } else {
                                    await Auth().registerWithEmailAndPassword(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("${e.message}"),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.red,
                                      showCloseIcon: true,
                                    ),
                                  );
                                }
                              }
                            },
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(_forLogin ? "Login" : "Register"),
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _emailController.text = "";
                        _passwordController.text = "";
                        _passwordConfirmationController.text = "";
                        setState(() {
                          _forLogin = !_forLogin;
                        });
                      },
                      child: Text(_forLogin
                          ? "No account? Sign up"
                          : "Already have an account? Log in"),
                    )
                  ],
                ),
                Divider(color: Colors.black),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    Auth().signInWithGoogle();

                    // final GoogleSignInAccount? googleUser =
                    //     await GoogleSignIn().signIn();
                    // final GoogleSignInAuthentication? googleAuth =
                    //     await googleUser?.authentication;
                    // final credential = GoogleAuthProvider.credential(
                    //   accessToken: googleAuth?.accessToken,
                    //   idToken: googleAuth?.idToken,
                    // );
                    // await FirebaseAuth.instance
                    //     .signInWithCredential(credential);
                  },
                  icon: Image.asset("assets/images/google.png", height: 30),
                  label: Text("Login with Google"),
                ),
              ],
            )),
      ),
    );
  }
}
