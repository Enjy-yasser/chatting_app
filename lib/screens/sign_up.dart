import 'package:chatting_app/firebase_auth.dart';
import 'package:chatting_app/widgets/custom_button.dart';
import 'package:chatting_app/widgets/formcontainer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/app_routes.dart';
import '../constants/app_strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuthService _auth=FirebaseAuthService();
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _usernameController =TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool isSigningUp=false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(100.0),
                  child: Text(AppStrings.signUp,style: TextStyle(fontSize: 19,color: Colors.black),),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FormcontainerWidget(
                    controller: _usernameController,
                    hintText: AppStrings.usernameController,
                    isPasswordField: false,
                  )
                ),    Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FormcontainerWidget(
                    controller: _emailController,
                    hintText: AppStrings.emailController,
                    inputType: TextInputType.emailAddress,
                    isPasswordField: false,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FormcontainerWidget(
                    controller: _passwordController,
                    hintText: AppStrings.passwordController,
                    isPasswordField: true,
                  ) ,),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MyButton(
                      onPressed: _signUp,
                      // style:ElevatedButton.styleFrom(
                      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      // padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      //   elevation: 10,
                      // ),
                      // ),        child: ElevatedButton(
                      // onPressed: _signUp,
                      // style:ElevatedButton.styleFrom(
                      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                      // padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      //   elevation: 10,
                      // ),
                    // color: Theme.of(context).colorScheme.inversePrimary,
                    title: 'Sign Up',
                    child: isSigningUp ? const CircularProgressIndicator(): const Text(AppStrings.signUp),
                    ),),
                  RichText(
                    text: TextSpan( text: AppStrings.haveAccount , style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: AppStrings.login,
                              style: TextStyle(color: Colors.blue[200],),
                          recognizer:TapGestureRecognizer()
                          ..onTap =(){
                              Navigator.pushReplacementNamed(context, Routes.loginRoute);
                          })
                
                        ] ),
                  )
                
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _signUp()async{

    setState((){
    isSigningUp=true;
    });
    try {
      String email = _emailController.text;
      String password = _passwordController.text;
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        await _auth.sendEmailVerification(user);
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: const Text(AppStrings.emailVerification),
                  content: const Text(AppStrings.emailVerificationMessage),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Routes.loginRoute);
                    },
                        child: const Text("OK"))
                  ],
                ));
      }
    }catch(e){
      print("Error occurred during sign up $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error $e")));
    }finally{
      setState(() {
        isSigningUp=false;
      });
    }

  }

}
