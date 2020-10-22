import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dip_dish/SharedPages/FormDecoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProblemDetails extends StatefulWidget {
  String name,mobile,address,problem;
  ProblemDetails({this.name, this.mobile, this.address, this.problem});

  @override
  _ProblemDetailsState createState() => _ProblemDetailsState();
}

class _ProblemDetailsState extends State<ProblemDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("দ্বীপ ক্যাবল ভিশন"),
        centerTitle: true,
      ),

      body: ProblemDetailsForm(),
    );
  }

  ProblemDetailsForm(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "গ্রাহকের সমস্যার বিবরণ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green[800],fontSize: 25),
                  ),
                ),
                SizedBox(height: 30,),

                Container(
                  child: Text("নাম", style: TextStyle(color: Colors.green),),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  color: Colors.grey[300],
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700],fontSize: 18),
                  ),
                ),
                SizedBox(height: 30,),

                Container(
                  child: Text("মোবাইল নাম্বার", style: TextStyle(color: Colors.green),),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  color: Colors.grey[300],
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.mobile,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700],fontSize: 18),
                  ),
                ),
                SizedBox(height: 30,),

                Container(
                  child: Text("ঠিনাকা", style: TextStyle(color: Colors.green),),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  color: Colors.grey[300],
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.address,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700],fontSize: 18),
                  ),
                ),
                SizedBox(height: 30,),

                Container(
                  child: Text("সমস্যার বিবরণ", style: TextStyle(color: Colors.green),),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  color: Colors.grey[300],
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    widget.problem,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700],fontSize: 18),
                  ),
                ),
                SizedBox(height: 30,),


                OutlineButton(
                  onPressed: () {
                    solveConfirmation(context);
                  },
                  highlightedBorderColor: Colors.green,
                  focusColor: Colors.green,
                  splashColor: Colors.green[200],
                  borderSide:
                  BorderSide(color: Colors.green, width: 2.0),
                  child: Text(
                    "সমাধান করা হয়েছে",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void solveConfirmation(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 115,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30.0),
            decoration: modalDecoration,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "গ্রাহক এর সমস্যা সমাধান করা হয়েছে?",
                        style:
                        TextStyle(fontSize: 18.0, color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 30.0,
                        ),
                        onPressed: () {
                          Firestore.instance
                              .collection("ComplainList")
                              .document(widget.mobile)
                              .delete();
                          Fluttertoast.showToast(
                              msg: "সমস্যার তথ্য মুছে ফেলা হয়েছে");
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30.0,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}

