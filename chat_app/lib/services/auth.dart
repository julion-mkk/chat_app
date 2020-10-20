import 'package:chat_app/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User _user(FirebaseUser user) {
        return user != null ? User(userId : user.uid) : null;
    }

    Future signInWithEmailAndPassword(String email, String password) async {
        try {
            AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
            FirebaseUser user= result.user;
            return _user(user);
        }catch(e) {
            print('try catch error auth: ${e.toString()}');
        }
    }

    Future signUpWithEmailAndPassword(String email, String password) async {
        try{
            AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
            FirebaseUser user= result.user;
            return _user(user);
        }catch(e) {
            print('try catch error auth singup : ${e.toString()}');
        }
    }

    Future resetPassword(String email) async {
        try{
            return await _auth.sendPasswordResetEmail(email: email);
        }catch(e) {
            print(e.toString());
        }
    }

    Future signOut() async {
        try{
            await _auth.signOut();
        }catch(e) {
            print(e.toString());
        }
    }
}