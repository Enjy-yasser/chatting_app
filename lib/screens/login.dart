import 'package:chatting_app/firebase_auth.dart';
import 'package:chatting_app/widgets/custom_button.dart';
import 'package:chatting_app/widgets/formcontainer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/app_routes.dart';
import '../constants/app_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth=FirebaseAuthService();
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool isLoggingIn=false;
  bool emailVerified = false;

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
          leading: IconButton(onPressed: (){ Navigator.pushNamed(context, Routes.signUpRoute);}, icon: const Icon(Icons.arrow_back,size: 20,)),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(100.0),
                  child: Text(AppStrings.login,style: TextStyle(fontSize: 19,color: Colors.black),),
                ),
                Padding(
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
                    onPressed: _login, title: "Login",

                    // ),ElevatedButton(
                    // onPressed: _login,
                    // style:ElevatedButton.styleFrom(
                    //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    //   padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   elevation: 10,
                    // ),
                    child: isLoggingIn ? const CircularProgressIndicator(): const Text(AppStrings.login),
                  ),),
                if(!emailVerified)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:MyButton(
                        onPressed: _resendVerificationEmail,
                      title: AppStrings.resendEmailVerification,
                      child: const Text(AppStrings.resendEmailVerification),
                    ),
                    // ),ElevatedButton(
                    //     onPressed: _resendVerificationEmail,
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    //       padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       elevation: 10,
                    //     ),
                    //   child: const Text("Resend verification email"),
                    // ),),

            ),
          ],),
        ),
      ),
    ),);
  }
  void _login()async{
    setState((){
      isLoggingIn=true;
    });
    try{
      String email= _emailController.text;
      String password=_passwordController.text;
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      if (user !=null)
      {
        if(user.emailVerified)
          {
            Navigator.pushReplacementNamed(context, Routes.homeRoute);
          }else{
          showDialog(context: context,
              builder: (context)=>AlertDialog(
                title: const Text("Email not verified"),
                content: const Text(
                    "Your email is not verified. Please verify your email or resend the verification link."),
              actions: [
                TextButton(onPressed: () async{
                  await _auth.resendEmailVerification(user);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Verification email")),
                  );
                } , child: const Text("Resend Verification"),
                ),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: const Text("cancel"))
              ],),

          );
        }
      }
    }catch(e){
      print("Error occurred during sign up $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }finally{
      setState(() {
        isLoggingIn=false;
      });
    }

  }
  void _resendVerificationEmail() async{
    User ? user=FirebaseAuth.instance.currentUser;
    if(user!=null && !user.emailVerified) {
      try{
      await _auth.resendEmailVerification(user);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verification Email Resent")));

  }catch(e){
      print("Error resending email verification $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error resending verification email")));
  }
    } else
  {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email already verified")));
  }
}

}
