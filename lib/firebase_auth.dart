
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{
  final FirebaseAuth  _auth= FirebaseAuth.instance;
  Future <User?> signUpWithEmailAndPassword(String email , String password)async{
    try{
      UserCredential credential=await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      return credential.user;
    }catch(e){
      print ("Error $e");
      rethrow;
    }
  }
  Future<User?> signInWithEmailAndPassword (String email, String password)async{
    try{
      UserCredential credential=await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User ? user=credential.user;
      if(user!=null && !user.emailVerified){
        throw Exception("Email not verified. please check your email ");
      }
    return user;
    }catch(e){
      print("Error $e");
      rethrow;
    }
  }

  Future <void> sendEmailVerification(User user) async{
try{
  await user.sendEmailVerification();
}catch(e){
  print("Error sending email verification $e");
  rethrow;
}
}  Future <void> resendEmailVerification(User user) async{
  if (!user.emailVerified){
    await sendEmailVerification(user);
  }
  else{
    throw Exception("Email is already verified");
  }
}

  Future <void> signOut() async{
    await _auth.signOut();
  }
}