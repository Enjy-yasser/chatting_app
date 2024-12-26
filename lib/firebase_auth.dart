
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
//
// class FirebaseAuthService{
//   // Instance of auth
//   final FirebaseAuth  _auth= FirebaseAuth.instance;
//   User? get currentUser => _auth.currentUser;
//
//   // create instance ll firestore
//   final FirebaseFirestore _firestore=FirebaseFirestore.instance;
//
//   Future <User?> signUpWithEmailAndPassword(String email , String password,String phone)async{
//     try{
//       UserCredential credential=await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//       );
//       // collections
//      await _firestore.collection('users').doc(credential.user!.uid).set(
//         {
//           'uid':credential.user!.uid,
//           'email':credential.user!.email,
//           'phone':phone,
//         }
//       );
//       print("User document successfully written with phone $phone.");
//       return credential.user;
//     }catch(firestoreError){
//       print("Failed to write to Firestore: $firestoreError");
//     }
//     return null;
//   }
//   Future<User?> signInWithEmailAndPassword (String email, String password)async{
//     try{
//       UserCredential credential=await _auth.signInWithEmailAndPassword(
//           email: email,
//           password: password
//       );
//       User ? user=credential.user;
//       if(user!=null && !user.emailVerified){
//         throw Exception("Email not verified. please check your email ");
//       }
//       // ne3mlha add 3lshn law mesh mwgoda
//       _firestore.collection('users').doc(credential.user!.uid).set(
//           {
//             // 'uid':credential.user!.uid,
//             'email':credential.user!.email,
//             'phone':credential.user!.phoneNumber,
//           },SetOptions(merge: true),
//       );
//     return user;
//     }catch(e){
//       print("Error $e");
//       rethrow;
//     }
//   }
//
//   Future <void> sendEmailVerification(User user) async{
// try{
//   await user.sendEmailVerification();
// }catch(e){
//   print("Error sending email verification $e");
//   rethrow;
// }
// }  Future <void> resendEmailVerification(User user) async{
//   if (!user.emailVerified){
//     await sendEmailVerification(user);
//   }
//   else{
//     throw Exception("Email is already verified");
//   }
// }
//
//   Future <void> signOut() async{
//     await _auth.signOut();
//   }
// }
//////////////////
// class FirebaseAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? get currentUser => _auth.currentUser;
//
//   Future<User?> signUpWithEmailAndPassword(String email, String password, String phone) async {
//     try {
//       UserCredential credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       await _firestore.collection('users').doc(credential.user!.uid).set(
//           {
//             'uid': credential.user!.uid,
//             'email': credential.user!.email,
//             'phone': phone,
//           }
//       );
//       print("User document successfully written with phone $phone.");
//       return credential.user;
//     } catch (e) {
//       print("Failed to write to Firestore: $e");
//       rethrow;
//     }
//   }
//
//   Future<User?> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       UserCredential credential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       User? user = credential.user;
//       if (user != null && !user.emailVerified) {
//         throw Exception("Email not verified. Please check your email.");
//       }
//
//       DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
//       if (userDoc.exists) {
//         String? phone = userDoc.get('phone');
//         if (phone != null) {
//           // Ensure phone number is set in Firestore user document
//           // await _firestore.collection('users').doc(user.uid).set(
//           //   {
//           //     'phone': phone,
//           //   },
//           //   SetOptions(merge: true),
//           // );
//           await _storePhoneNumberLocally(phone);
//
//         }
//       }
//       return user;
//     } catch (e) {
//       print("Error $e");
//       rethrow;
//     }
//   }
//   Future<void> _storePhoneNumberLocally(String phone) async {
//     // Store the phone number locally using shared preferences or any other local storage
//     // Example using shared_preferences:
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userPhoneNumber', phone);
//   }
//
//   Future<String?> _getPhoneNumberLocally() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userPhoneNumber');
//   }
//
//   Future<void> sendEmailVerification(User user) async {
//     try {
//       await user.sendEmailVerification();
//     } catch (e) {
//       print("Error sending email verification $e");
//       rethrow;
//     }
//   }
//
//   Future<void> resendEmailVerification(User user) async {
//     if (!user.emailVerified) {
//       await sendEmailVerification(user);
//     } else {
//       throw Exception("Email is already verified");
//     }
//   }
//
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }
// }

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String phone) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(credential.user!);

      await _firestore.collection('users').doc(credential.user!.uid).set(
        {
          'uid': credential.user!.uid,
          'email': credential.user!.email,
          'phone': phone,
        },
      );
      print("User document successfully written with phone $phone.");
      return credential.user;
    } catch (e) {
      print("Failed to write to Firestore: $e");
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user != null && !user.emailVerified) {
        throw Exception("Email not verified. Please check your email.");
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        String? phone = userDoc.get('phone');
        if (phone != null) {
          await _storePhoneNumberLocally(phone);
        }
      }
      return user;
    } catch (e) {
      print("Error $e");
      rethrow;
    }
  }

  Future<void> _storePhoneNumberLocally(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userPhoneNumber', phone);
  }

  Future<String?> _getPhoneNumberLocally() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userPhoneNumber');
  }

  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      print("Error sending email verification $e");
      rethrow;
    }
  }

  Future<void> resendEmailVerification(User user) async {
    if (!user.emailVerified) {
      await sendEmailVerification(user);
    } else {
      throw Exception("Email is already verified");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}