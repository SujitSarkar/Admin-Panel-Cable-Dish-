import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dip_dish/pages/HomePage.dart';
import 'file:///C:/Users/Glamworld%20IT%20Ltd/Desktop/dip_dish/lib/SharedPages/LoadingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseUser currentUser;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text("দ্বীপ ক্যাবল ভিশন"),
        centerTitle: true,
      ),
      body: logInBody(),
    );
  }

  Widget logInBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.white, Colors.green],
        ),
      ),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*.05,
            child: new MarqueeWidget(
              text:
                  "--- দ্বীপ ক্যবল ভিশন --- দ্বীপ ক্যবল ভিশন --- দ্বীপ ক্যবল ভিশন --- দ্বীপ ক্যবল ভিশন --- দ্বীপ ক্যবল ভিশন --- দ্বীপ ক্যবল ভিশন --- দ্বীপ ক্যবল ভিশন ---",
              textStyle: TextStyle(color: Colors.green[900],fontSize: 18),
              scrollAxis: Axis.horizontal,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*.65,
            child: Center(
              child: GestureDetector(
                onTap: handleSignIn,
                child: Image(
                  height: 50.0,
                  width: 200.0,
                  image: AssetImage("assets/image/google_signin_button.png"),
                ),
              )
            ),
          ),
          isLoading ? customLoadingBar() : Container(),
        ],
      ),
    );
  }

  Future<void> handleSignIn() async {
    setState(() => isLoading = true);
    SharedPreferences preferences = await SharedPreferences.getInstance();

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;

    ///SignIn Success....
    if (firebaseUser != null) {
      ///Check if already signUp....
      final QuerySnapshot resultQuery = await Firestore.instance
          .collection("Admin")
          .where("id", isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documentSnapshot = resultQuery.documents;

      ///Save data to Firestore if the new user...
      if (documentSnapshot.length == 0) {
        Firestore.instance
            .collection("Admin")
            .document(firebaseUser.uid)
            .setData({
          "name": firebaseUser.displayName,
          "photoUrl": firebaseUser.photoUrl,
          "id": firebaseUser.uid,
          "createdDate": DateTime.now().millisecondsSinceEpoch.toString(),
        });

        ///Write data to local...
        currentUser = firebaseUser;
        await preferences.setString("id", currentUser.uid);
        await preferences.setString("name", currentUser.displayName);
        await preferences.setString("photoUrl", currentUser.photoUrl);
      } else {
        ///User already exist....
        ///Write data to local....
        currentUser = firebaseUser;
        await preferences.setString("id", documentSnapshot[0]["id"]);
        await preferences.setString("nickname", documentSnapshot[0]["name"]);
        await preferences.setString(
            "photoUrl", documentSnapshot[0]["photoUrl"]);
      }

      Fluttertoast.showToast(msg: "সাইন ইন সফল হয়েছে");
      setState(() => isLoading = false);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } else {
      Fluttertoast.showToast(msg: "সাইন ইন ব্যর্থ হয়েছে, আবার চেষ্টা করুন");
      setState(() => isLoading = false);
    }
  }
}
