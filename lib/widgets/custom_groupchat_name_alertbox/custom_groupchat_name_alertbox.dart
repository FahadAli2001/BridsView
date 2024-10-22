import 'package:birds_view/controller/chat_controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


void customGroupChatNameAlertBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer<ChatController>(
        builder: (context, value, child) {
          return AlertDialog(
            backgroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: GestureDetector(
              onTap: () {
                value.pickGroupImage();
              },
              child: CircleAvatar(
                backgroundImage: value.groupImageFile != null
                    ? FileImage(value.groupImageFile!)
                    : null,
                radius: 40,
                child: value.groupImageFile != null
                    ? null
                    : const Icon(
                        Icons.image,
                        color: Colors.black,
                      ),
              ),
            ),
            content: TextField(
              controller: value.groupNameController,
              style: GoogleFonts.urbanist(color: whiteColor),
              decoration: InputDecoration(
                  hintText: "Group Name",
                  hintStyle: GoogleFonts.urbanist(color: whiteColor)),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: CustomButton(
                  text: 'Create',
                  ontap: () {
                    value.createGroup(context);
                  },
                )),
              )
            ],
          );
        },
      );
    },
  );
}
