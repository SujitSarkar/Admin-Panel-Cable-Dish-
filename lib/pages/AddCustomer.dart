import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dip_dish/SharedPages/FormDecoration.dart';
import 'package:dip_dish/SharedPages/LoadingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddNewCustomer extends StatefulWidget {
  @override
  _AddNewCustomerState createState() => _AddNewCustomerState();
}

class _AddNewCustomerState extends State<AddNewCustomer> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String mobile = '';
  String address = '';
  String nid = '';
  String state = "বিল বকেয়া";
  String lastPaid;

  final List<String> items = ["বিল বকেয়া", "বিল পরিশোধ"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("দ্বীপ ক্যাবল ভিশন"),
        centerTitle: true,
      ),
      body: fromBody(),
    );
  }

  Widget fromBody() {
    return isLoading
        ? Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  greenLoadingBar(),
                  Text(
                    "গ্রাহকের তথ্য সংরক্ষন করা হচ্ছে, অপেক্ষা করুন",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            color: Colors.transparent,
          )
        : Form(
            key: _formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "গ্রাহক নিবন্ধন ফরম",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.green[700], fontSize: 25.0),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.text,
                          decoration: textInputDecoration,
                          validator: (value) =>
                              value.isEmpty ? "গ্রাহকের নাম দিন" : null,
                          onChanged: (value) {
                            setState(() => name = value);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          //textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration.copyWith(
                              hintText: "গ্রাহকের মোবাইল নাম্বার"),
                          validator: (value) => value.isEmpty
                              ? "গ্রাহকের মোবাইল নাম্বার দিন"
                              : null,
                          onChanged: (value) {
                            setState(() => mobile = value);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          //textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration.copyWith(
                              hintText: "গ্রাহকের NID নাম্বার"),
                          validator: (value) => value.isEmpty
                              ? "গ্রাহকের NID নাম্বার দিন"
                              : null,
                          onChanged: (value) {
                            setState(() => nid = value);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),

                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: textInputDecoration.copyWith(
                              hintText: "গ্রাহকের ঠিকানা"),
                          validator: (value) =>
                              value.isEmpty ? "গ্রাহকের ঠিকানা দিন" : null,
                          onChanged: (value) {
                            setState(() => address = value);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            value: state,
                            items: items.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() => state = val);
                            },
                            iconEnabledColor: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlineButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() => isLoading = true);
                                  saveCustomerToDatabase();
                                }
                              },
                              highlightedBorderColor: Colors.green,
                              focusColor: Colors.green,
                              splashColor: Colors.green[200],
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2.0),
                              child: Text(
                                "সংরক্ষণ করুন",
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            OutlineButton(
                              onPressed: () => Navigator.of(context).pop(),
                              highlightedBorderColor: Colors.red,
                              focusColor: Colors.red,
                              splashColor: Colors.red[200],
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2.0),
                              child: Text(
                                "বাতিল করুন",
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Future saveCustomerToDatabase() async {
    String entryDate = DateTime.now().millisecondsSinceEpoch.toString();
    String temp;
    if (state == "বিল পরিশোধ") {
      temp = "paid";
      lastPaid = entryDate;
    } else {
      temp = "unpaid";
    }


    Firestore.instance.collection("Customer").document(mobile).setData({
      "name": name,
      "mobile": mobile,
      "address": address,
      "NID": nid,
      "state": temp,
      "entryDate": entryDate,
      "password": "1234",
      "last paid": lastPaid,
    }).then((value) async {
        this.setState(() => isLoading = false);
        Fluttertoast.showToast(msg: "তথ্য সংরক্ষন সম্পন্ন হয়েছে");
        Navigator.of(context).pop();
      }, onError: (errorMgs) {
        setState(() => isLoading = false);
        Fluttertoast.showToast(msg: errorMgs.toString());
      });
  }
}
