import 'package:birds_view/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../widgets/custom_button/custom_button.dart';
import '../../widgets/custom_image_picker_bottom_sheet/custom_image_picker_bottom_sheet.dart';
import '../../widgets/custom_textfield/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomButton(
          text: 'Update Profile',
          ontap: () {},
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            text: "Edit ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.03,
                color: Colors.white70),
            children: [
              TextSpan(
                text: 'Profile ',
                style: TextStyle(
                    fontSize: size.height * 0.03, color: primaryColor),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: size.height * 0.03,
            ),
            Center(
              child: Container(
                width: size.width * 0.3,
                height: size.height * 0.15,
                color: Colors.black,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: size.height * 0.07,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.1,
                      left: size.width * 0.17,
                      child: GestureDetector(
                        onTap: () {
                          showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  CustomImagePickerBottomSheet(
                                    cameraontap: () {},
                                    galleryontap: () {},
                                  ));
                        },
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: const Icon(
                            CupertinoIcons.camera,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(
              height: size.height * 0.01,
            ),
            RichText(
              text: TextSpan(
                text: 'Guest ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.03,
                    color: Colors.white),
                children: [
                  TextSpan(
                    text: 'User',
                    style: TextStyle(
                        fontSize: size.height * 0.03, color: primaryColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            //
            const CustomTextField(
                textEditingController: null,
                obsecure: false,
                hintText: "First Name",
                labelText: "First Name"),
            //

            const CustomTextField(
                textEditingController: null,
                obsecure: false,
                hintText: "Last Name",
                labelText: "Last Name"),
            //
            TextField(
              enabled: false,
              style: const TextStyle(color: Colors.white60),
              controller: null,
              decoration: InputDecoration(
                fillColor: primaryColor.withOpacity(0.4),
                filled: true,
                hintText: 'Email',
                hintStyle: const TextStyle(color: Colors.black),
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white60),
              ),
            ),
            SizedBox(
                width: size.width,
                child: const Divider(
                  color: Colors.white54,
                )),

            //
            const CustomTextField(
                textEditingController: null,
                obsecure: true,
                hintText: "Password",
                labelText: "Password"),
          ],
        )),
      ),
    );
  }
}
