import 'package:chatting_app/firebase_auth.dart';
import 'package:chatting_app/widgets/custom_button.dart';
import 'package:chatting_app/widgets/formcontainer_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _phoneController =TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  bool isSigningUp=false;
  final List<String> countryCodes = ['+1', '+20', '+44', '+91', '+234'];

  // Default selected country code
  String selectedCountryCode = '+20';


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
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
                 Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Icon(
                    Icons.message_outlined,
                    size: 50,
                    color: Theme.of(context).colorScheme.inversePrimary),
                ),
                const Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Text(AppStrings.signUp,style: TextStyle(fontSize: 19,color: Colors.black),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedCountryCode,
                  items: countryCodes.map((code) {
                    return DropdownMenuItem(
                      value: code,
                      child: Text(code),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCountryCode = value!;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: "Phone Number"),
                    keyboardType: TextInputType.phone,
                  ),
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
                      onPressed: _signUp,
                    title: 'Sign Up',
                    child: isSigningUp ? const CircularProgressIndicator(): const Text(AppStrings.signUp),
                    ),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
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
                    ),
                  )

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      isSigningUp = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email sent for verification')),
      );

    });

    try {
      String phoneNumber = _phoneController.text;
      // String phoneNumber = '$selectedCountryCode${_phoneController.text}';
      print('Attempting to sign up with phone: $phoneNumber');

      await _auth.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
        phoneNumber,
      );

      await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).set({
        'phone': phoneNumber,
        'email': _emailController.text,
      });


      Navigator.pushReplacementNamed(context, Routes.loginRoute);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing up: $e')),
      );
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }

}
