import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dip_dish/SharedPages/DatabaseManager.dart';
import 'package:dip_dish/SharedPages/FormDecoration.dart';
import 'package:dip_dish/SharedPages/LoadingPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllCustomerList extends StatefulWidget {
  @override
  _AllCustomerListState createState() => _AllCustomerListState();
}

class _AllCustomerListState extends State<AllCustomerList> {
  List customers = [];
  List searchCustomers = [];
  bool isLoading = true;

  TextEditingController searchEditingController = TextEditingController();
  bool isSearch = false;
  String searchQuery = "";
  String mobileNumber = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllCustomer();
  }

  fetchAllCustomer() async {
    dynamic result = await DatabaseManager().getAllCustomer();

    if (result == null) {
      print("No data in database");
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
        title: searchBar(),
      ),
      body: isLoading
          ? greenLoadingBar()
          : isSearch
              ? customSearch(context)
              : customers.length == 0
                  ? noDataFoundMgs()
                  : mainList(context),
    );
  }

  Widget searchBar() {
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
              Icons.clear,
              color: Colors.grey[300],
            ),
            onPressed: () {
              searchEditingController.clear();
              setState(() {
                isSearch = false;
              });
            },
          ),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
            if (searchQuery == "") {
              isSearch = false;
            } else {
              isSearch = true;
            }
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
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    mobileNumber = customers[index]["mobile"];
                    deleteConfirmation(context);
                  });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future fetchSearch() async {
    dynamic result = await DatabaseManager().getSearchedCustomer(searchQuery);
    setState(() {
      searchCustomers = result;
    });
  }

  Widget customSearch(BuildContext context) {
    fetchSearch();
    return searchCustomers.length == 0
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
                  "এই মোবাইল নাম্বারধারী কোন গ্রাহক নেই",
                  style: TextStyle(color: Colors.grey, fontSize: 20.0),
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              itemCount: searchCustomers.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {},
                    title: Text(searchCustomers[index]["mobile"]),
                    subtitle: Text(searchCustomers[index]["name"]),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image(
                        image: AssetImage("assets/image/profile.png"),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          mobileNumber = searchCustomers[index]["mobile"];
                          deleteConfirmation(context);
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  void deleteConfirmation(BuildContext context) {
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
                        "গ্রাহক এর তথ্য মুছে ফেলতে চান?",
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
                              .collection("Customer")
                              .document(mobileNumber)
                              .delete();
                          Fluttertoast.showToast(
                              msg: "গ্রাহক এর তথ্য মুছে ফেলা হয়েছে");
                          Navigator.pop(context);
                          if (searchQuery == null) {
                            mainList(context);
                          } else {
                            customSearch(context);
                          }
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
