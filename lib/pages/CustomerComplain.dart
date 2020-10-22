import 'package:dip_dish/SharedPages/DatabaseManager.dart';
import 'package:dip_dish/SharedPages/LoadingPage.dart';
import 'package:dip_dish/pages/CustomerProblemDetails.dart';
import 'package:flutter/material.dart';

class CustomerComplainList extends StatefulWidget {
  @override
  _CustomerComplainListState createState() => _CustomerComplainListState();
}

class _CustomerComplainListState extends State<CustomerComplainList> {

  List complainList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchComplainList();
  }

  fetchComplainList() async {
    dynamic result = await DatabaseManager().geComplainList();

    if (result == null) {
      print("No data in database");
      setState(() => isLoading = false);
    } else {
      setState(() {
        complainList = result;
        setState(() => isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("খালি সমস্যার তালিকা"),
      ),
      body: isLoading
          ? greenLoadingBar()
          : complainList.length == 0
          ? noDataFoundMgs()
          : mainList(context),
    );
  }

  Widget noDataFoundMgs() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
            size: 70.0,
          ),
          Text(
            "খালি গ্রাহক তালিকা",
            style: TextStyle(color: Colors.grey, fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Widget mainList(BuildContext context) {
    fetchComplainList();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
        itemCount: complainList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ProblemDetails(
                  name: complainList[index]["name"],
                  mobile: complainList[index]["mobile"],
                  address: complainList[index]["address"],
                  problem: complainList[index]["problem"],
                )));
              },
              title: Text(complainList[index]["mobile"]),
              subtitle: Text(complainList[index]["name"]),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image(
                  image: AssetImage("assets/image/profile.png"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
