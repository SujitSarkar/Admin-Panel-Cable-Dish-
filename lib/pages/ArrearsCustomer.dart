import 'package:dip_dish/SharedPages/DatabaseManager.dart';
import 'package:dip_dish/SharedPages/LoadingPage.dart';
import 'package:flutter/material.dart';

class ArrearsCustomerList extends StatefulWidget {
  @override
  _ArrearsCustomerListState createState() => _ArrearsCustomerListState();
}

class _ArrearsCustomerListState extends State<ArrearsCustomerList> {

  bool isLoading = true;
  TextEditingController searchEditingController = TextEditingController();
  String searchQuery = "";
  bool isSubmitted = false;
  List customers = [];
  List searchPaidCustomers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllCustomer();
  }

  fetchAllCustomer() async {
    dynamic result = await DatabaseManager().getUnPaidCustomer();

    if (result == null) {
      setState(() => isLoading = false);
    } else {
      setState(() {
        customers = result;
        setState(() => isLoading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        title: searchBar(context),
      ),
      body: isLoading
          ? greenLoadingBar()
          : isSubmitted
          ? customSearch(context)
          : customers.length == 0
          ? noDataFoundMgs()
          : mainList(context),
    );
  }

  Widget searchBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.number,
        cursorColor: Colors.white,
        style: TextStyle(fontSize: 17, color: Colors.white),
        controller: searchEditingController,
        decoration: InputDecoration(
          hintText: 'অনুসন্ধান করুন...',
          hintStyle: TextStyle(color: Colors.grey[300]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(5),
          ),
          filled: false,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey[300],
            ),
            onPressed: () {
              searchPaidCustomers.clear();
              setState(() => isSubmitted = true);
            },
          ),
        ),
        onChanged: (value) {
          searchQuery = value;
          setState(() {
            if (searchQuery == "") {
              searchPaidCustomers.clear();
              isSubmitted = false;
            }
            searchPaidCustomers.clear();
          });
        },
        onFieldSubmitted: (value) {
          setState(() {
            searchPaidCustomers.clear();
            searchQuery = value;
            isSubmitted = true;
          });
        },
      ),
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
    fetchAllCustomer();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {},
              title: Text(customers[index]["mobile"]),
              subtitle: Text(customers[index]["name"]),
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

  Widget customSearch(BuildContext context) {
    searchPaidCustomers.clear();

    for (int i = 0; i < customers.length; i++) {
      if (customers[i]["mobile"] == searchQuery) {
        searchPaidCustomers.add(customers[i]);
      }
    }

    return searchPaidCustomers.length == 0
        ? Center(
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
            "এই মোবাইল নাম্বারধারী কোন গ্রাহক এর বিল বকেয়া নেই",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    )
        : Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
        itemCount: searchPaidCustomers.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {},
              title: Text(searchPaidCustomers[index]["mobile"]),
              subtitle: Text(searchPaidCustomers[index]["name"]),
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
