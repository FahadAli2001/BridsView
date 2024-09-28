import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:birds_view/model/firebase_friendreq_model/firebase_friendreq_model.dart';
import 'package:birds_view/model/firebase_user_model/firebase_user_model.dart';
import 'package:birds_view/model/friend_model/friend_model.dart';
import 'package:birds_view/model/message_model/message_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../model/chat_room_model/chat_room_model.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();
  var uuid = const Uuid();
  // ignore: prefer_typing_uninitialized_variables
  var imageUrl;
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
      log(firebaseUserModel.toString());
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
 
     if (await isFriend(userModel[index].id!)) {
      log("You are already friends.");
      return; // Exit if they are already friends
    }

     if (await hasSentRequest(userModel[index].id!)) {
      log("Friend request already sent.");
      return; // Exit if a request is already pending
    }

    try {
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
  // issue
  void acceptFriendRequest(List<FriendRequestModel?> requesterModel, int index,
    UserModel? currentUser) async {
  
  String requesterId = requesterModel[index]!.requesterId!; // Requester's ID
  String currentUserId = currentUser!.data!.id!.toString(); // Current User's ID

  // Step 1: Delete the friend request from the current user's friendRequests collection
  await _firestore
      .collection("users")
      .doc(currentUserId)
      .collection("friendRequests")
      .doc(requesterId)
      .delete()
      .then((_) {
    log("Friend request deleted from current user.");
  }).catchError((error) {
    log("Error deleting friend request: $error");
  });

  // Step 2: Add the requester to the current user's friend list
  await _firestore
      .collection("users")
      .doc(currentUserId)
      .collection("friendList")
      .doc(requesterId)
      .set({
    "friendId": requesterId,
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

  // Step 3: Add the current user to the requester's friend list
  await _firestore
      .collection("users")
      .doc(requesterId) // Requester's document
      .collection("friendList")
      .doc(currentUserId) // Use the current user's ID here
      .set({
    "friendId": currentUserId,
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

  // Step 4: Remove the friend request from the local list and notify listeners
  friendRequests.removeAt(index);
  notifyListeners();

  log("Friend request accepted.");
}


  // void acceptFriendRequest(List<FriendRequestModel?> requesterModel, int index,
  //     UserModel? currentUser) async {
    
  //   await _firestore
  //       .collection("users")
  //       .doc(userId)
  //       .collection("friendRequests")
  //       .doc(requesterModel[index]!.requesterId)
  //       .delete()
  //       .then((_) {
  //     log("Friend request deleted from current user.");
  //   }).catchError((error) {
  //     log("Error deleting friend request: $error");
  //   });

  //   // Add the requester to the current user's friend list
  //   await _firestore
  //       .collection("users")
  //       .doc(userId)
  //       .collection("friendList")
  //       .doc(requesterModel[index]!.requesterId)
  //       .set({
  //     "friendId": requesterModel[index]!.requesterId,
  //     "firstName": requesterModel[index]!.requesterFirstName,
  //     "lastName": requesterModel[index]!.requesterLastName,
  //     "email": requesterModel[index]!.requesterEmail,
  //     "image": requesterModel[index]!.requesterImage,
  //     "status": "friends",
  //   }).then((_) {
  //     log("Requester added to current user's friend list.");
  //   }).catchError((error) {
  //     log("Error adding requester to friend list: $error");
  //   });

     
  //   await _firestore
  //       .collection("users")
  //       .doc(requesterModel[index]!.requesterId)
  //       .collection("friendList")
  //       .doc(userId)
  //       .set({
  //     "friendId": currentUser!.data!.id,
  //     "firstName": currentUser.data!.firstName,
  //     "lastName": currentUser.data!.lastName,
  //     "email": currentUser.data!.email,
  //     "image": currentUser.data!.image,
  //     "status": "friends",
  //   }).then((_) {
  //     log("Current user added to requester's friend list.");
  //   }).catchError((error) {
  //     log("Error adding current user to requester's friend list: $error");
  //   });

    
  //   friendRequests.removeAt(index);
  //   notifyListeners();

  //   log("Friend request accepted.");
  // }

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

  Future<ChatRoomModel?> getChatRoomModel(String targetUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.$userId', isEqualTo: true)
        .where('participants.$targetUser', isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // fetch exsisting
      var docs = snapshot.docs[0].data();

      ChatRoomModel exsistingRoom =
          ChatRoomModel.fromJson(docs as Map<String, dynamic>);

      chatRoom = exsistingRoom;
    } else {
      // create new one

      ChatRoomModel newChatRoomModel = ChatRoomModel(
          roomId: uuid.v1(),
          lastMessage: '',
          participants: {userId.toString(): true, targetUser.toString(): true});

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoomModel.roomId)
          .set(newChatRoomModel.toJson());

      chatRoom = newChatRoomModel;
    }

    return chatRoom;
  }

  void sendMessage(
      [String? imageUrl,
      ChatRoomModel? chatRoomModel,
      String? messageType,
      String? videoUrl]) async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg.isNotEmpty || imageUrl != null) {
      String? textToSend;
      if (messageType == "video") {
        textToSend = "";
      } else if (messageType == "image") {
        textToSend = " ";
      } else {
        textToSend = msg;
      }

      MessageModel newMessage = MessageModel(
          messageId: uuid.v1(),
          sender: userId,
          createdOn: DateTime.now().microsecondsSinceEpoch,
          text: textToSend,
          seen: false, // Set seen to false for new messages
          imageUrl: imageUrl,
          videoUrl: videoUrl);

      try {
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(chatRoomModel!.roomId)
            .collection("messages")
            .doc(newMessage.messageId)
            .set(newMessage.toJson())
            .then((value) {});

        chatRoomModel.lastMessage = msg;
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(chatRoomModel.roomId)
            .set(chatRoomModel.toJson());

        log("Message Sent!");
      } catch (e) {
        log("Error sending message: $e");
      }
    }
  }

  String formatTime(String createdOn) {
    int timestamp = int.parse(createdOn);
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format time as HH:mm (24-hour format) or hh:mm a (12-hour format)
    return DateFormat('hh:mm ').format(dateTime);
  }

  void pickImage(ChatRoomModel? chatRoomModel) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    log("picked file : $pickedImage");
    if (pickedImage != null) {
      uploadImage(File(pickedImage.path), chatRoomModel);
    }
  }

  void uploadImage(File imageFile, ChatRoomModel? chatRoomModel) async {
    try {
      var reference =
          FirebaseStorage.instance.ref().child('chat_images/${uuid.v1()}');

      var uploadTask = reference.putFile(imageFile);

      // Listen to the task events to get progress or capture failure
      uploadTask.snapshotEvents.listen((event) {
        switch (event.state) {
          case TaskState.running:
            log("Upload is running...");
            break;
          case TaskState.paused:
            log("Upload is paused.");
            break;
          case TaskState.success:
            log("Upload completed successfully.");
            break;
          case TaskState.canceled:
            log("Upload was canceled.");
            break;
          case TaskState.error:
            log("An error occurred during upload.");
            break;
        }
      });

      // Get the image URL after upload completes
      imageUrl = await uploadTask.then((taskSnapshot) {
        return taskSnapshot.ref.getDownloadURL();
      });

      log("Image uploaded: $imageUrl");
      sendMessage(imageUrl, chatRoomModel, "image", null);
    } catch (e) {
      log("Error uploading image: $e");
    }
  }

  void pickVideo(ChatRoomModel? chatRoomModel) async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    log("Picked video: $pickedVideo");

    if (pickedVideo != null) {
      uploadVideo(File(pickedVideo.path), chatRoomModel);
    }
  }

  void uploadVideo(File videoFile, ChatRoomModel? chatRoomModel) async {
    
    try {
       var reference =
          FirebaseStorage.instance.ref().child('chat_videos/${uuid.v1()}');

       UploadTask uploadTask = reference.putFile(videoFile);

       TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

       String videoUrl = await taskSnapshot.ref.getDownloadURL();

       log("Video uploaded successfully: $videoUrl");

       notifyListeners();
      sendMessage(null, chatRoomModel, 'video', videoUrl);
    } catch (e) {
      // Catch and log any errors
      log("Error uploading video: $e");
    }
  }
}
