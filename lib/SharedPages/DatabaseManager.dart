import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference customerList =
      Firestore.instance.collection("Customer");

  Future getAllCustomer() async {
    List itemList = [];
    try {
      await customerList.getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          itemList.add(element.data);
        });
      });
      return itemList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getSearchedCustomer(String searchQuery) async {
    List searchList = [];
    try {
      await customerList
          .where("mobile", isGreaterThanOrEqualTo: searchQuery)
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          searchList.add(element.data);
        });
      });
      return searchList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getPaidCustomer() async {
    List paidList = [];
    try {
      await customerList
          .where("state", isEqualTo: "paid")
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          paidList.add(element.data);
        });
      });
      return paidList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getUnPaidCustomer() async {
    List unPaidList = [];
    try {
      await customerList
          .where("state", isEqualTo: "unpaid")
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          unPaidList.add(element.data);
        });
      });
      return unPaidList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future geComplainList() async {
    final CollectionReference complainList =
    Firestore.instance.collection("ComplainList");
    List problems = [];
    try {
      await complainList
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          problems.add(element.data);
        });
      });
      return problems;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
