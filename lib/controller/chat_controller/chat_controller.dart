import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  late Map<String,dynamic> _userMap;
   bool _isSearching = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();

  Map<String,dynamic> get userMap => _userMap;
  bool get isSearching => _isSearching;

  void searchUser() async {
    _isSearching = true;
    notifyListeners();
    await _firestore
        .collection("users")
        .where("email", isEqualTo: searchController.text)
        .get()
        .then((val) {
          _userMap = val.docs[0].data();
          _isSearching = false;
          notifyListeners();
        });
  }
}
