import 'package:flutter/material.dart';

class CustomerComplainList extends StatefulWidget {
  @override
  _CustomerComplainListState createState() => _CustomerComplainListState();
}

class _CustomerComplainListState extends State<CustomerComplainList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("গ্রাহকের সমস্যার তালিকা"),
      ),
    );
  }
}
