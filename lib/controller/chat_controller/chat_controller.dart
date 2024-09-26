import 'dart:developer';

import 'package:birds_view/model/firebase_user_model/firebase_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<FirebaseUserModel>? firebaseUserModel = [];
  String? _userId;

  String? get userId => _userId;

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

  late Map<String, dynamic> _userSearchedMap;
  bool _isSearching = false;

  TextEditingController searchController = TextEditingController();

  Map<String, dynamic> get userSearchedMap => _userSearchedMap;
  bool get isSearching => _isSearching;


 Future<void> getUserCredential() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _userId = sp.getString("user_id")!;
    log("user id : $userId");
  
    notifyListeners();
  }

 void searchUser() async {
  _isSearching = true;
  notifyListeners();

  String searchQuery = searchController.text.trim().toLowerCase();
  
  await _firestore
      .collection("users")
      .where("first_name", isGreaterThanOrEqualTo: searchQuery)
      .where("first_name", isLessThan: '${searchQuery}z')
      .get()
      .then((val) {
    // Filter out the current user's data from the results
    firebaseUserModel = val.docs
        .where((doc) => doc.id != userId) // Exclude the current user
        .map((doc) => FirebaseUserModel.fromJson(doc.data()))
        .toList();

    notifyListeners();
    
    _isSearching = false;
    notifyListeners();
  }).catchError((error) {
    _isSearching = false;
    log("Error occurred while searching: $error");
    notifyListeners();
  });
}


  void sendFriendRequest(List<FirebaseUserModel> userModel, int index) async {
   
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel[index].id)
        .collection("friendRequests")
        .doc(userId)
        .set({
      "status": "pending",
      "requesterId": userId,
      "requesterName":
          "${userModel[index].firstName} ${userModel[index].lastName!}",
      "requesterEmail": userModel[index].email,
      "timestamp": FieldValue.serverTimestamp(),
    });
    log("Friend request sent.");
  }

  Future<bool> hasSentRequest(String recipientId) async {
  

  final snapshot = await FirebaseFirestore.instance
      .collection("users")
      .doc(recipientId)
      .collection("friendRequests")
      .doc(userId)
      .get();

  return snapshot.exists;  
}

}
