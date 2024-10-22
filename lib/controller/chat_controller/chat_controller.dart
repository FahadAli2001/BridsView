import 'dart:io';
import 'package:birds_view/model/group_model/group_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:birds_view/model/firebase_friendreq_model/firebase_friendreq_model.dart';
import 'package:birds_view/model/firebase_user_model/firebase_user_model.dart';
import 'package:birds_view/model/friend_model/friend_model.dart';
import 'package:birds_view/model/message_model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../model/chat_room_model/chat_room_model.dart';
import 'package:birds_view/views/views.dart';


class ChatController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();
  var uuid = const Uuid();
  File? groupImageFile;

  String? _groupLastMessage = '';

  // ignore: prefer_typing_uninitialized_variables
  var imageUrl;
  List<GroupModel> groupsDetail = [];
  List<MessageModel> messages = [];
  List<FirebaseUserModel>? firebaseUserModel = [];
  List<FriendRequestModel?> friendRequests = [];
  List<FriendModel?> friendsList = [];
  List<FriendModel?> friendsChatList = [];
  List<FriendModel>? selectedFriendsForGroup = [];
  Map<String, dynamic>? lastMessagesAndTime;
  String? _userId;
  int? _friendReqCount;
  String? get userId => _userId;
  int? get friendReqCount => _friendReqCount;
  String? get groupLastMessage => _groupLastMessage;

  set groupLastMessage(val) {
    _groupLastMessage = val;
    notifyListeners();
  }

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

  Future<void> handleChats() async {
    _myFriends = false;
    _groups = false;
    _chats = true;
    await fetchChattingFriendDetails();
    notifyListeners();
  }

  void handleGroups() async {
    _myFriends = false;
    _groups = true;
    _chats = false;
    await fetchUserGroups();
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

  Future<void> sendFriendRequest(List<FirebaseUserModel> userModel, int index,
      UserModel? currentUser) async {
    if (await isFriend(userModel[index].id!)) {
      log("You are already friends.");
      return; // Exit if they are already friends
    }

    if (await hasSentRequest(userModel[index].id!)) {
      log("Friend request already sent.");
      return; // Exit if a request is already pending
    }

    try {
      // Add request to receiver's friendRequests collection
      await _firestore
          .collection("users")
          .doc(userModel[index].id!)
          .collection("friendRequests")
          .doc(userId)
          .set({
        "status": "pending",
        "requesterId": userId,
        "requesterImage":
            currentUser!.data!.image, // Assuming this data is available
        "requesterFirstName":
            currentUser.data!.firstName, // Assuming currentUser is available
        "requesterLastName": currentUser.data!.lastName!,
        "requesterEmail": currentUser.data!.email,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // // Also store request in sender's "sentFriendRequests" collection
      // await _firestore
      //     .collection("users")
      //     .doc(userId)
      //     .collection("sentFriendRequests")
      //     .doc(userModel[index].id!)
      //     .set({
      //   "status": "pending",
      //   "receiverId": userModel[index].id!,
      //   "receiverImage": userModel[index].image,
      //   "receiverFirstName": userModel[index].firstName,
      //   "receiverLastName": userModel[index].lastName!,
      //   "receiverEmail": userModel[index].email,
      //   "timestamp": FieldValue.serverTimestamp(),
      // });

      log("Friend request sent successfully.");
      notifyListeners();
    } catch (e) {
      log("Error sending friend request: $e");
    }
  }

  // Future<void> sendFriendRequest(
  //     List<FirebaseUserModel> userModel, int index) async {
  //   if (await isFriend(userModel[index].id!)) {
  //     log("You are already friends.");
  //     return; // Exit if they are already friends
  //   }

  //   if (await hasSentRequest(userModel[index].id!)) {
  //     log("Friend request already sent.");
  //     return; // Exit if a request is already pending
  //   }

  //   try {
  //     await _firestore
  //         .collection("users")
  //         .doc(userModel[index].id!)
  //         .collection("friendRequests")
  //         .doc(userId)
  //         .set({
  //       "status": "pending",
  //       "requesterId": userId,
  //       "requesterImage": userModel[index].image,
  //       "requesterFirstName": userModel[index].firstName,
  //       "requesterLastName": userModel[index].lastName!,
  //       "requesterEmail": userModel[index].email,
  //       "timestamp": FieldValue.serverTimestamp(),
  //     });

  //     log("Friend request sent.");
  //     notifyListeners();
  //   } catch (e) {
  //     log("Error sending friend request: $e");
  //   }
  // }

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
    String currentUserId =
        currentUser!.data!.id!.toString(); // Current User's ID

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
      "friendId": requesterId.toString(),
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
      "friendId": currentUserId.toString(),
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
      GroupModel? groupModel,
      String? videoUrl]) async {
    String msg = messageController.text.trim();
    messageController.clear();

    // Check if it's a group or individual chat
    if (msg.isNotEmpty || imageUrl != null || videoUrl != null) {
      String? textToSend;
      if (messageType == "video") {
        textToSend = ""; // For video, send an empty message body
      } else if (messageType == "image") {
        textToSend = " "; // For images, send a space as a placeholder
      } else {
        textToSend = msg; // For text messages, send the actual message
      }

      // Create the message model
      MessageModel newMessage = MessageModel(
        messageId: uuid.v1(),
        sender: userId,
        createdOn: DateTime.now().microsecondsSinceEpoch,
        text: textToSend,
        seen: false,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
      );

      // Determine the room ID (group or individual)
      String roomId;
      if (groupModel != null) {
        roomId = groupModel.groupId;
      } else if (chatRoomModel != null && chatRoomModel.roomId != null) {
        roomId = chatRoomModel.roomId!;
      } else {
        log("Error: No valid room ID found for chat.");
        return;
      }

      try {
        // Store the message in the corresponding chat room
        await FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(roomId)
            .collection("messages")
            .doc(newMessage.messageId)
            .set(newMessage.toJson());

        // Update the last message in the chat room (individual or group)
        if (chatRoomModel != null) {
          chatRoomModel.lastMessage = textToSend;
          await FirebaseFirestore.instance
              .collection("chatrooms")
              .doc(roomId)
              .set(chatRoomModel.toJson());
        } else if (groupModel != null) {
          // groupModel.lastMessage = textToSend;
          await FirebaseFirestore.instance
              .collection("chatrooms")
              .doc(roomId)
              .set(groupModel.toJson());
        }

        log("Message Sent!");
      } catch (e) {
        log("Error sending message: $e");
      }
    }
  }

  String formatTime(String createdOn) {
    int timestamp;

    // Check if the timestamp is in microseconds or milliseconds
    if (createdOn.length > 13) {
      // It's likely in microseconds, convert to milliseconds
      timestamp =
          int.parse(createdOn) ~/ 1000; // Divide by 1000 for milliseconds
    } else {
      // It's in milliseconds
      timestamp = int.parse(createdOn);
    }

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Format time as HH:mm (24-hour format) or hh:mm a (12-hour format)
    return DateFormat('hh:mm a')
        .format(dateTime); // Change 'hh:mm a' to 'HH:mm' for 24-hour format
  }

  void pickImage(ChatRoomModel? chatRoomModel, GroupModel? groupModel) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    log("picked file : $pickedImage");
    if (pickedImage != null) {
      uploadImage(File(pickedImage.path), chatRoomModel, groupModel);
    }
  }

  void uploadImage(File imageFile, ChatRoomModel? chatRoomModel,
      GroupModel? groupModel) async {
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
      if (groupModel != null) {
        sendMessage(imageUrl, null, "image", groupModel, "");
      } else {
        sendMessage(imageUrl, chatRoomModel, "image", null, "");
      }
    } catch (e) {
      log("Error uploading image: $e");
    }
  }

  void pickVideo(ChatRoomModel? chatRoomModel, GroupModel? groupModel) async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    log("Picked video: $pickedVideo");

    if (pickedVideo != null) {
      uploadVideo(File(pickedVideo.path), chatRoomModel, groupModel);
    }
  }

  void uploadVideo(File videoFile, ChatRoomModel? chatRoomModel,
      GroupModel? groupModel) async {
    try {
      var reference =
          FirebaseStorage.instance.ref().child('chat_videos/${uuid.v1()}');

      UploadTask uploadTask = reference.putFile(videoFile);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

      String videoUrl = await taskSnapshot.ref.getDownloadURL();

      log("Video uploaded successfully: $videoUrl");

      notifyListeners();
      if (groupModel != null) {
        sendMessage(null, null, 'video', groupModel, videoUrl);
      } else {
        sendMessage(null, chatRoomModel, 'video', null, videoUrl);
      }
    } catch (e) {
      // Catch and log any errors
      log("Error uploading video: $e");
    }
  }

  Future<void> fetchChattingFriendDetails() async {
    if (userId == null) {
      log("Error: userId is null.");
      return;
    }

    try {
      log("Fetching chatrooms for userId: $userId");

      _firestore
          .collection("chatrooms")
          .where("participants.$userId", isEqualTo: true)
          .snapshots()
          .listen((chatRoomSnapshot) async {
        if (chatRoomSnapshot.docs.isNotEmpty) {
          friendsChatList.clear(); // Clear existing list

          for (var doc in chatRoomSnapshot.docs) {
            Map<String, dynamic>? participants = doc.get("participants");

            if (participants == null) {
              log("Error: Participants data is null for doc: ${doc.id}");
              continue;
            }

            String? friendId = participants.keys.firstWhere(
              (id) => id != userId,
            );

            String? roomId = doc.get("roomId");

            if (roomId != null) {
              log("Fetching last message and time for roomId: $roomId");
              await fetchLastMessageAndTime(roomId, friendId);
            } else {
              log("Error: roomId is null for doc: ${doc.id}");
              continue;
            }

            notifyListeners();

            _firestore
                .collection("users")
                .doc(userId)
                .collection("friendList")
                .doc(friendId)
                .snapshots()
                .listen(
              (friendSnapshot) {
                if (friendSnapshot.exists) {
                  var friendData =
                      friendSnapshot.data() as Map<String, dynamic>;

                  friendsChatList.removeWhere((friend) =>
                      friend!.friendId.toString() == friendId.toString());

                  friendsChatList.add(FriendModel.fromJson(friendData));

                  // Add last message details to the friend model
                  if (lastMessagesAndTime != null) {
                    friendData['lastMessage'] = lastMessagesAndTime!['text'];
                    friendData['lastMessageTime'] =
                        lastMessagesAndTime!['createdOn'];
                  }

                  notifyListeners();
                } else {
                  log("Friend not found in users collection for id: $friendId");
                }
              },
            );
          }
        } else {
          log("No chatrooms found for userId: $userId");
        }
      }).onError((error) {
        log("Error fetching friend's details: $error");
      });
    } catch (e) {
      log("Exception while fetching chatting friend details: $e");
    }
  }

  Future<void> fetchLastMessageAndTime(
      String chatroomId, String friendId) async {
    try {
      QuerySnapshot lastMessageSnapshot = await _firestore
          .collection("chatrooms")
          .doc(chatroomId)
          .collection("messages")
          .orderBy("createdOn", descending: true)
          .limit(1)
          .get();

      if (lastMessageSnapshot.docs.isNotEmpty) {
        lastMessagesAndTime =
            lastMessageSnapshot.docs.first.data() as Map<String, dynamic>;

        lastMessagesAndTime!['sender'];

        notifyListeners();
      } else {
        log("No messages found in chatroom: $chatroomId");
      }
    } catch (e) {
      log("Error fetching last message: $e");
    }
  }

  Future<ChatRoomModel?> getGroupChatRoomModel(
      {required List<String> participantIds,
      required String groupName,
      required String groupImage,
      e}) async {
    ChatRoomModel? chatRoom;

    try {
      if (participantIds.length < 2) {
        log("Error: Group must have at least 2 friends and the current user.");
        showCustomErrorToast(
            message: "You need at least 2 friends to create a group.");
        return null;
      }

      if (!participantIds.contains(userId)) {
        participantIds.add(userId!);
      }

      Map<String, bool> participantsMap = {
        for (var id in participantIds) id: true
      };

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('chatrooms')
          .where('isGroup', isEqualTo: true)
          .where('participants', isEqualTo: participantsMap)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var docs = snapshot.docs[0].data();
        ChatRoomModel existingRoom =
            ChatRoomModel.fromJson(docs as Map<String, dynamic>);
        chatRoom = existingRoom;
        log("Existing group chatroom found with ID: ${existingRoom.roomId}");
      } else {
        // Create new group chatroom
        ChatRoomModel newGroupChatRoom = ChatRoomModel(
          roomId: uuid.v1(),
          lastMessage: '',
          participants: participantsMap,
          groupName: groupName,
          groupImage: groupImage,
        );

        await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(newGroupChatRoom.roomId)
            .set(newGroupChatRoom.toJson());

        chatRoom = newGroupChatRoom;
        log("New group chatroom created with ID: ${newGroupChatRoom.roomId}");
      }

      return chatRoom;
    } catch (e) {
      log("Error in getGroupChatRoomModel: $e");
      return null;
    }
  }

  Future<void> pickGroupImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      groupImageFile = File(pickedFile.path);

      log("Image picked: ${groupImageFile!.path}");
      notifyListeners();
    } else {
      log("No image selected");
    }
  }

  Future<String?> uploadGroupImage() async {
    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child('group_images/${uuid.v1()}');

      UploadTask uploadTask = storageRef.putFile(groupImageFile!);

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      log("Image uploaded successfully: $downloadUrl");

      return downloadUrl;
    } catch (e) {
      log("Error uploading image: $e");
      return null;
    }
  }

  Future<void> createGroup(context) async {
    try {
      String? imageUrl = await uploadGroupImage();
      String groupName = groupNameController.text.trim();

      if (groupName.isEmpty) {
        showCustomErrorToast(message: "Please enter a group name.");
        return;
      }

      if (selectedFriendsForGroup!.length < 2) {
        log("Error: You need at least 2 friends to create a group");
        showCustomErrorToast(
            message: "You need at least 2 friends to create a group.");
        return;
      }

      List<String> groupMembers =
          selectedFriendsForGroup!.map((friend) => friend.friendId!).toList();
      groupMembers.add(userId!);

      ChatRoomModel? chatRoomModel = await getGroupChatRoomModel(
          participantIds: groupMembers,
          groupName: groupName,
          groupImage: imageUrl!);
      GroupModel newGroup = GroupModel(
        groupId: chatRoomModel!.roomId!,
        groupName: groupName,
        groupImage: imageUrl,
        memberIds: groupMembers,
      );

      await FirebaseFirestore.instance
          .collection('groups')
          .doc(newGroup.groupId)
          .set(newGroup.toJson());
      selectedFriendsForGroup!.clear();
      Navigator.pop(context);
      log("Group created successfully with ID: ${newGroup.groupId}");
      showCustomSuccessToast(message: "Group created successfully!");
    } catch (e) {
      log("Error creating group: $e");
      showCustomErrorToast(message: "Error creating group. Please try again.");
    }
  }

  Future<void> fetchUserGroups() async {
    try {
      // Fetch groups where the current user is present in the 'memberIds' field
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('groups')
          .where('memberIds', arrayContains: userId)
          .get();

      // Check if any groups are found
      if (snapshot.docs.isNotEmpty) {
        // Map the snapshot documents to a list of GroupModel objects
        groupsDetail = snapshot.docs.map((doc) {
          return GroupModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();

        log("Fetched ${groupsDetail.length} groups for user $userId.");
      } else {
        log("No groups found for user $userId.");
      }
    } catch (e) {
      log("Error fetching groups: $e");
    }
  }
}
