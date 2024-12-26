import 'package:chatting_app/firebase_auth.dart';
import 'package:chatting_app/widgets/custom_button.dart';
import 'package:chatting_app/widgets/formcontainer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
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
          // leading: IconButton(onPressed: (){ Navigator.pushNamed(context, Routes.signUpRoute);}, icon: const Icon(Icons.arrow_back,size: 20,)),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Icon(
                      Icons.message_outlined,
                      size: 50,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                const Padding(
                  padding: EdgeInsets.all(1.0),
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
                RichText(
                  text: TextSpan( text: AppStrings.dontHaveAccount, style: const TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: AppStrings.signUp,
                            style: TextStyle(color: Colors.blue[200],),
                            recognizer:TapGestureRecognizer()
                              ..onTap =(){
                                Navigator.pushReplacementNamed(context, Routes.signUpRoute);
                              })

                      ] ),
                )

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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _smsCodeController = TextEditingController();
//   String? _verificationId;
//   bool _isSendingCode = false;
//   bool _isVerifying = false;
//
//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _smsCodeController.dispose();
//     super.dispose();
//   }
//
//   // Method to handle phone authentication
//   Future<User?> signInWithPhone(String verificationId, String smsCode) async {
//     try {
//       // Create a PhoneAuthCredential
//       final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: smsCode,
//       );
//
//       // Sign in with the credential
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//       User? user = userCredential.user;
//
//       // Save user information to Firestore
//       await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
//         {
//           'uid': user.uid,
//           'email': user.email,
//           'phone': user.phoneNumber,
//         },
//         SetOptions(merge: true),
//       );
//
//       return user;
//     } catch (e) {
//       print("Error during phone sign-in: $e");
//       rethrow;
//     }
//   }
//
//   Future<void> _sendVerificationCode() async {
//     setState(() {
//       _isSendingCode = true;
//     });
//
//     try {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: _phoneController.text,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // Auto-sign in when verification is completed
//           await FirebaseAuth.instance.signInWithCredential(credential);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           print("Verification failed: $e");
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Verification failed: ${e.message}")),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _verificationId = verificationId;
//             _isSendingCode = false;
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           setState(() {
//             _verificationId = verificationId;
//           });
//         },
//       );
//     } catch (e) {
//       print("Error sending verification code: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error sending verification code")),
//       );
//     } finally {
//       setState(() {
//         _isSendingCode = false;
//       });
//     }
//   }
//
//   Future<void> _verifyCode() async {
//     if (_verificationId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Verification ID is missing")),
//       );
//       return;
//     }
//
//     setState(() {
//       _isVerifying = true;
//     });
//
//     try {
//       User? user = await signInWithPhone(_verificationId!, _smsCodeController.text);
//       if (user != null) {
//         Navigator.pushReplacementNamed(context, '/home'); // Replace with your home route
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Verification failed: $e")),
//       );
//     } finally {
//       setState(() {
//         _isVerifying = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Phone Login"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: "Phone Number",
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (_verificationId != null)
//               TextField(
//                 controller: _smsCodeController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "SMS Code",
//                 ),
//               ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _isSendingCode
//                   ? null
//                   : _verificationId == null
//                   ? _sendVerificationCode
//                   : _verifyCode,
//               child: _isSendingCode
//                   ? const CircularProgressIndicator()
//                   : Text(_verificationId == null ? "Send Code" : "Verify Code"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
