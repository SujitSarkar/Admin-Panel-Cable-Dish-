import 'package:dip_dish/pages/AboutUs.dart';
import 'package:dip_dish/pages/AddCustomer.dart';
import 'package:dip_dish/pages/AllCustomer.dart';
import 'package:dip_dish/pages/ArrearsCustomer.dart';
import 'package:dip_dish/pages/CustomerComplain.dart';
import 'package:dip_dish/pages/LoginPage.dart';
import 'package:dip_dish/pages/PaidCustomer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("দ্বীপ ক্যাবল ভিশন"),
        elevation: 0.0,
        //centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: signOut,
          )
        ],
      ),
      body: homeBody(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget homeBody() {
    return GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      children: [

        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNewCustomer()));
          },
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person_add_alt_1, size: 50.0,color: Colors.green),
                Text("নতুন গ্রাহক নিবন্ধন করুন", style: TextStyle(fontSize: 18.0, color: Colors.green),textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AllCustomerList()));
          },
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 50.0,color: Colors.green),
                Text("সকল গ্রাহকের তালিকা", style: TextStyle(fontSize: 18.0, color: Colors.green),textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ArrearsCustomerList()));
          },
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person_remove_outlined, size: 50.0,color: Colors.green),
                Text("বকেয়া বিল গ্রাহকের তালিকা", style: TextStyle(fontSize: 18.0, color: Colors.green),textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PaidCustomerList()));
          },
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 50.0,color: Colors.green),
                Text("পরিশোধিত বিল গ্রাহকের তালিকা", style: TextStyle(fontSize: 18.0, color: Colors.green),textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerComplainList()));
          },
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.report_problem_outlined, size: 50.0,color: Colors.green),
                Text("গ্রাহকের সমস্যার তালিকা", style: TextStyle(fontSize: 18.0, color: Colors.green),textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>About()));
          },
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.details_outlined, size: 50.0,color: Colors.green),
                Text("আমাদের সম্পর্কে বিস্তারিত", style: TextStyle(fontSize: 18.0, color: Colors.green),textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),

      ],
    );
  }

  Future<Null> signOut() async {
    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LogIn()),
            (Route<dynamic> route) => false);
  }
}
