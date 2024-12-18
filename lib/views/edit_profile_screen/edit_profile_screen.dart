import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:birds_view/views/views.dart';


class EditProfileScreen extends StatefulWidget {
  final UserModel? user;
  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();

    final editProfileController =
        Provider.of<EditProfileController>(context, listen: false);

    if (widget.user != null) {
      editProfileController.callExistingValue(widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Dismissible(
        key: const Key("Edit Profile"),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          Navigator.pop(context);
        },
        child: Scaffold(
          bottomNavigationBar: Consumer<EditProfileController>(
            builder: (context, editController, child) {
              return SizedBox(
                width: size.width,
                height: size.height * 0.1,
                child: Stack(
                  children: [
                    editController.isUpdating == true
                        ? Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: SizedBox(
                                  width: size.width * 0.1,
                                  child:const LoadingWidget(),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: CustomButton(
                                text: 'Update Profile',
                                ontap: () {
                                  if (widget.user != null) {
                                    editController.updateUser(
                                        widget.user, context);
                                  } else {
                                    showCustomErrorToast(
                                        message: 'Sign In To Continue');
                                  }
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
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
              title: const CustomHeadingText(
                heading: "Edit Profile",
              )),
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(child: Consumer<EditProfileController>(
              builder: (context, value, child) {
                return Column(
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
                            if (widget.user == null ||
                                widget.user!.data!.image == '')
                              CircleAvatar(
                                radius: size.height * 0.07,
                                backgroundColor: Colors.white,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                              )
                            else if (value.pickedFile != null)
                              CircleAvatar(
                                radius: size.height * 0.07,
                                backgroundImage: FileImage(value.pickedFile!),
                              )
                            else if (widget.user != null &&
                                widget.user!.data!.image != '')
                              CircleAvatar(
                                radius: size.height * 0.07,
                                backgroundImage: CachedNetworkImageProvider(
                                    widget.user!.data!.image!),
                              ),
                            Positioned(
                              top: size.height * 0.1,
                              left: size.width * 0.17,
                              child: GestureDetector(
                                  onTap: () {
                                    if (widget.user == null) {
                                      showCustomErrorToast(
                                          message: 'Sign In To Continue');
                                    } else {
                                      showCupertinoModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              CustomImagePickerBottomSheet(
                                                cameraontap: () {
                                                  value.pickedProfileImage(
                                                      ImageSource.camera,
                                                      context);
                                                },
                                                galleryontap: () {
                                                  value.pickedProfileImage(
                                                      ImageSource.gallery,
                                                      context);
                                                },
                                              ));
                                    }
                                  },
                                  child: Container(
                                    width: 45,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: gradientColor),
                                    child: const Center(
                                      child: Icon(
                                        CupertinoIcons.camera,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )),
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
                        text: widget.user == null ||
                                widget.user!.data!.firstName == ''
                            ? "Guest "
                            : '${widget.user!.data!.firstName} ',
                        style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.026,
                            color: Colors.white),
                        children: [
                          TextSpan(
                            text: widget.user == null ||
                                    widget.user!.data!.lastName == ''
                                ? ''
                                : widget.user!.data!.lastName,
                            style: GoogleFonts.urbanist(
                                fontSize: size.height * 0.026,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    //
                    CustomTextField(
                        textEditingController: value.firstNameController,
                        obsecure: false,
                        hintText: "First Name",
                        labelText: "First Name"),
                    //

                    CustomTextField(
                        textEditingController: value.lastNameController,
                        obsecure: false,
                        hintText: "Last Name",
                        labelText: "Last Name"),
                    //
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        readOnly: true,
                        style: const TextStyle(color: Colors.white60),
                        controller: value.emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: GoogleFonts.urbanist(color: Colors.black),
                          labelText: "Email",
                          labelStyle:
                              GoogleFonts.urbanist(color: Colors.white60),
                        ),
                      ),
                    ),
                    //

                    //
                    CustomTextField(
                        textEditingController: value.passwordController,
                        obsecure: true,
                        hintText: "Password",
                        labelText: "Password"),
                  ],
                );
              },
            )),
          ),
        ));
  }
}
