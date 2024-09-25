import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  bool _myFriends = true;
  bool get myFriends => _myFriends;

  bool _chats = false;
  bool get chats => _chats;

  bool _groups = false;
  bool get groups => _groups;

  void handleMyFriends() {
    _myFriends = true;
    _groups = false;
    _chats = false;
    
    notifyListeners();
  }

  void handleChats() {
    _myFriends = false;
    _groups = false;
    _chats = true;
    notifyListeners();
  }

  void handleGroups() {
    _myFriends = false;
    _groups = true;
    _chats = false;
    notifyListeners();
  }

  // set groups(val){
  //   _groups = val;
  //   notifyListeners();
  // }

  // set myFriends(val){
  //   _myFriends = val;
  //   notifyListeners();
  // }

  // set chats(val){
  //   _chats = val;
  //   notifyListeners();
  // }
  // late Map<String,dynamic> _userMap;
  //  bool _isSearching = false;
  // // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // TextEditingController searchController = TextEditingController();

  // Map<String,dynamic> get userMap => _userMap;
  // bool get isSearching => _isSearching;

  // void searchUser() async {
  //   _isSearching = true;
  //   notifyListeners();
  //   await _firestore
  //       .collection("users")
  //       .where("email", isEqualTo: searchController.text)
  //       .get()
  //       .then((val) {
  //         _userMap = val.docs[0].data();
  //         _isSearching = false;
  //         notifyListeners();
  //       });
  // }
}
