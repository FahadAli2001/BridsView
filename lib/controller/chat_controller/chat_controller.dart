import 'dart:developer';

import 'package:birds_view/model/firebase_friendreq_model/firebase_friendreq_model.dart';
import 'package:birds_view/model/firebase_user_model/firebase_user_model.dart';
import 'package:birds_view/model/friend_model/friend_model.dart';
import 'package:birds_view/model/message_model/message_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:birds_view/views/chat_screens/chatroom_screen/chatroom_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();
  var uuid =const Uuid();
  List<MessageModel> messages = [];
  List<FirebaseUserModel>? firebaseUserModel = [];
  List<FriendRequestModel?> friendRequests = [];
  List<FriendModel?> friendsList = [];
  String? _userId;
  int? _friendReqCount;

  String? get userId => _userId;
  int? get friendReqCount => _friendReqCount;

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
      firebaseUserModel = val.docs
          .where((doc) => doc.id != userId)
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

  Future<void> sendFriendRequest(
      List<FirebaseUserModel> userModel, int index) async {
    // Get the recipient's user ID

    // Check if already friends
    if (await isFriend(userModel[index].id!)) {
      log("You are already friends.");
      return; // Exit if they are already friends
    }

    // Check if a request has already been sent
    if (await hasSentRequest(userModel[index].id!)) {
      log("Friend request already sent.");
      return; // Exit if a request is already pending
    }

    try {
      // Send a friend request
      await _firestore
          .collection("users")
          .doc(userModel[index].id!)
          .collection("friendRequests")
          .doc(userId)
          .set({
        "status": "pending",
        "requesterId": userId,
        "requesterImage": userModel[index].image,
        "requesterFirstName": userModel[index].firstName,
        "requesterLastName": userModel[index].lastName!,
        "requesterEmail": userModel[index].email,
        "timestamp": FieldValue.serverTimestamp(),
      });

      log("Friend request sent.");
      notifyListeners(); // Update UI state
    } catch (e) {
      log("Error sending friend request: $e");
    }
  }

  Future<bool> isFriend(String recipientId) async {
    try {
      final snapshot = await _firestore
          .collection("users")
          .doc(userId)
          .collection("friendList")
          .doc(recipientId)
          .get();

      return snapshot.exists; // Returns true if a friend record exists
    } catch (e) {
      log("Error checking friendship status: $e");
      return false; // Return false in case of error
    }
  }

  Future<bool> hasSentRequest(String recipientId) async {
    try {
      final snapshot = await _firestore
          .collection("users")
          .doc(recipientId)
          .collection("friendRequests")
          .doc(userId)
          .get();

      return snapshot.exists;
    } catch (e) {
      log("Error checking friend request status: $e");
      return false;
    }
  }

  Future<void> fetchFriendRequests() async {
    _firestore
        .collection("users")
        .doc(userId)
        .collection("friendRequests")
        .where("status", isEqualTo: "pending")
        .snapshots()
        .listen((snapshot) {
      friendRequests = snapshot.docs
          .map((doc) => FriendRequestModel.fromJson(doc.data()))
          .toList();
      notifyListeners();
      log("${friendRequests.length} friend requests updated");
    }, onError: (error) {
      log("Error fetching friend requests: $error");
    });
  }

  void acceptFriendRequest(List<FriendRequestModel?> requesterModel, int index,
      UserModel? currentUser) async {
    // Delete the friend request from the current user's friend requests collection
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("friendRequests")
        .doc(requesterModel[index]!.requesterId)
        .delete()
        .then((_) {
      log("Friend request deleted from current user.");
    }).catchError((error) {
      log("Error deleting friend request: $error");
    });

    // Add the requester to the current user's friend list
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("friendList")
        .doc(requesterModel[index]!.requesterId)
        .set({
      "friendId": requesterModel[index]!.requesterId,
      "firstName": requesterModel[index]!.requesterFirstName,
      "lastName": requesterModel[index]!.requesterLastName,
      "email": requesterModel[index]!.requesterEmail,
      "image": requesterModel[index]!.requesterImage,
      "status": "friends",
    }).then((_) {
      log("Requester added to current user's friend list.");
    }).catchError((error) {
      log("Error adding requester to friend list: $error");
    });

    // Now, add the current user to the requester's friend list
    await _firestore
        .collection("users")
        .doc(requesterModel[index]!.requesterId)
        .collection("friendList")
        .doc(userId)
        .set({
      "friendId": currentUser!.data!.id,
      "firstName": currentUser.data!.firstName,
      "lastName": currentUser.data!.lastName,
      "email": currentUser.data!.email,
      "image": currentUser.data!.image,
      "status": "friends",
    }).then((_) {
      log("Current user added to requester's friend list.");
    }).catchError((error) {
      log("Error adding current user to requester's friend list: $error");
    });

    // Remove the accepted request from the list and update UI
    friendRequests.removeAt(index);
    notifyListeners();

    log("Friend request accepted.");
  }

  void rejectFriendRequest(
      List<FriendRequestModel?> requesterModel, int index) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("friendRequests")
        .doc(requesterModel[index]!.requesterId)
        .delete();
    friendRequests.removeAt(index);
    notifyListeners();
    log("Friend request rejected.");
  }

  Future<void> fetchFriendList() async {
    _firestore
        .collection("users")
        .doc(userId)
        .collection("friendList")
        .snapshots()
        .listen((snapshot) {
      friendsList =
          snapshot.docs.map((doc) => FriendModel.fromJson(doc.data())).toList();
      notifyListeners();
      log("${friendsList.length} friends updated");
    }, onError: (error) {
      log("Error fetching friend list: $error");
    });
  }

  Future<void> getFriendRequestCount() async {
    try {
      _firestore
          .collection("users")
          .doc(userId)
          .collection("friendRequests")
          .snapshots()
          .listen((snapshot) {
        _friendReqCount = snapshot.docs.length;
        notifyListeners();
      });
    } catch (e) {
      log("Error fetching friend requests: $e");
      _friendReqCount = 0;
      notifyListeners();
    }
  }

  String generateChatId(String userId1, String userId2) {
    // Sort the user IDs to ensure consistent chat ID creation
    List<String> userIds = [userId1, userId2]..sort();
    return '${userIds[0]}_${userIds[1]}'; // Combine with an underscore or another delimiter
  }

  Future<String> getChatId(String userId1, String userId2) async {
    String chatId = generateChatId(userId1, userId2);
    // Check if the chat ID already exists
    final chatSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(chatId)
        .collection('chats')
        .doc(chatId) // Optionally, you can store chat metadata here
        .get();

    if (chatSnapshot.exists) {
      return chatId; // Existing chat found
    } else {
      // Create a new chat document if it does not exist
      await FirebaseFirestore.instance
          .collection('users')
          .doc(chatId)
          .collection('chats')
          .doc(chatId)
          .set({'createdAt': FieldValue.serverTimestamp()});

      return chatId; // Return new chat ID
    }
  }

  void startChat(String userId2, context, int index,
      List<FriendModel?> friendModel) async {
    String chatId = await getChatId(userId!, userId2);
    Navigator.push(
      context,
      PageTransition(
          child: ChatroomScreen(
            chatId: chatId,
            friendId: userId2,
            index: index,
            friendModel: friendModel,
          ),
          type: PageTransitionType.fade),
    );
  }

  // Fetch messages from Firestore
  Future<void> fetchMessages(String friendId, String chatId) async {
    final messageSnapshots = await _firestore
        .collection('users')
        .doc(friendId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    messages = messageSnapshots.docs
        .map((doc) => MessageModel.fromJson(doc.data()))
        .toList();
    notifyListeners();
  }

  Future<void> sendMessage(
    String content,
    String type,
    String friendId,
    String chatId, [
    String? imageUrl,
    String? videoUrl,
  ]) async {
  if (content.trim().isEmpty && imageUrl == null && videoUrl == null) {
    return;
  }

  // Determine the text to display based on the message type
  String? textToSend = content.trim();
  if (type == "image") {
    textToSend = "Image Message";
  } else if (type == "video") {
    textToSend = "Video Message";
  }

  // Create the message object
  MessageModel newMessage = MessageModel(
    messageId: uuid.v1(),  
    sender: userId!, // Use the current logged-in user's ID
    text: textToSend,
    seen: false, // Set to false since it's a new message
    createdOn: DateTime.now().microsecondsSinceEpoch, // Timestamp
    imageUrl: imageUrl, // Null for text message
    videoUrl: videoUrl, // Null for text message
  );

  try {
    // Save the message in the current user's chat collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId) // Current user's ID
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(newMessage.messageId) // Message document with the unique message ID
        .set(newMessage.toJson());

    // Save the message in the friend's chat collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(friendId) // Friend's ID
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(newMessage.messageId) // Message document with the unique message ID
        .set(newMessage.toJson());

    // Clear the message input field
    messageController.clear();

    // Optionally, send push notifications or refresh the messages
    fetchMessages(friendId, chatId); // Update the message list
  } catch (e) {
    log("Error sending message: $e");
  }
}

}
