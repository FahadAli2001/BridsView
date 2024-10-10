import 'package:birds_view/controller/signup_controller/signup_controller.dart';
import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:birds_view/widgets/custom_heading_text/custom_heading_text.dart';
import 'package:birds_view/widgets/custom_textfield/custom_textfield.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_image_picker_bottom_sheet/custom_image_picker_bottom_sheet.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  get pickedFile => null;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: Consumer<SignUpController>(
            builder: (context, value, child) {
              return SizedBox(
                width: size.width,
                height: size.height * 0.1,
                child: Stack(
                  children: [
                    value.isCreatingAccount == true
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
                                  child: const CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15),
                            child: Center(
                              child: CustomButton(
                                text: 'Create Account',
                                ontap: () {
                                  value.checkSignUpConditions(context);
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          )),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
            )),
        centerTitle: true,
        title: const CustomHeadingText(
          heading: 'Create An Account',
        ),
        //  Center(
        //   child: RichText(
        //     text: TextSpan(
        //       text: "Create ",
        //       style: GoogleFonts.urbanist(
        //           fontWeight: FontWeight.bold,
        //           fontSize: size.height * 0.026,
        //           color: Colors.white),
        //       children: [
        //         WidgetSpan(
        //             child: Text(
        //           'An ',
        //           style: GoogleFonts.urbanist(
        //               fontSize: size.height * 0.026, color: Colors.white70),
        //         )),
        //         WidgetSpan(
        //           alignment: PlaceholderAlignment.baseline,
        //           baseline: TextBaseline.alphabetic,
        //           child: ShaderMask(
        //             shaderCallback: (bounds) => const LinearGradient(
        //               colors: [
        //                 Color(0xFFC59241),
        //                 Color(0xFFFEF6D1),
        //                 Color(0xFFC49138),
        //               ],
        //               begin: Alignment.centerLeft,
        //               end: Alignment.centerRight,
        //               stops: [0.0, 0.5, 1.0],
        //             ).createShader(
        //                 Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        //             child: Text(
        //               'Account ',
        //               style: GoogleFonts.urbanist(
        //                   fontSize: size.height * 0.026,
        //                   fontWeight: FontWeight.w900,
        //                   color: whiteColor),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: Consumer<SignUpController>(builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: size.width * 0.4,
                  height: size.height * 0.16,
                  color: Colors.black,
                  child: Stack(
                    children: [
                      value.pickedFile != null
                          ? Center(
                              child: CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: size.height * 0.075,
                              backgroundImage: FileImage(value.pickedFile!),
                            ))
                          : Center(
                              child: CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: size.height * 0.075,
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: size.height * 0.06,
                                  ),
                                ),
                              ),
                            ),
                      Positioned(
                        right: size.width * 0.06,
                        top: size.height * 0.1,
                        child: GestureDetector(
                            onTap: () {
                              showCupertinoModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      CustomImagePickerBottomSheet(
                                        cameraontap: () {
                                          value.pickedProfileImage(
                                              ImageSource.camera, context);
                                        },
                                        galleryontap: () {
                                          value.pickedProfileImage(
                                              ImageSource.gallery, context);
                                        },
                                      ));
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
              //
              SizedBox(
                height: size.height * 0.03,
              ),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: size.width * 0.45,
                      child: CustomTextField(
                          obsecure: false,
                          textEditingController: value.firstNameController,
                          hintText: "First Name",
                          labelText: "First Name")),
                  //

                  SizedBox(
                    width: size.width * 0.45,
                    child: CustomTextField(
                        obsecure: false,
                        textEditingController: value.lastNameController,
                        hintText: "Last Name",
                        labelText: "Last Name"),
                  ),
                  //
                ],
              ),
              //

              CustomTextField(
                  obsecure: false,
                  textEditingController: value.emailController,
                  hintText: "Email",
                  labelText: "Email"),

              //
              CustomTextField(
                  iconOnTap: () {
                    if (value.isHidePassword == true) {
                      value.isHidePassword = false;
                    } else {
                      value.isHidePassword = true;
                    }
                  },
                  icon: value.isHidePassword == true
                      ? const Icon(
                          Icons.visibility_off,
                          color: Colors.white60,
                        )
                      : const Icon(
                          Icons.visibility,
                          color: Colors.white60,
                        ),
                  obsecure: value.isHidePassword == true ? true : false,
                  textEditingController: value.passwordController,
                  hintText: "Password",
                  labelText: "Password"),

              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                color: Colors.transparent,
                width: size.width,
                height: size.height * 0.071,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    BottomPicker.date(
                      backgroundColor: Colors.black,
                      pickerTitle: Text(
                        'Select Date Of Birth',
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: whiteColor,
                        ),
                      ),
                      dateOrder: DatePickerDateOrder.dmy,
                      initialDateTime: DateTime(1996, 10, 22),
                      maxDateTime: DateTime.now(),
                      minDateTime: DateTime(1980),
                      pickerTextStyle: GoogleFonts.urbanist(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      buttonSingleColor: Colors.black,
                      closeIconColor: primaryColor,
                      buttonStyle: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      onChange: (index) {},
                      onSubmit: (date) {
                        value.selectedDate = date;
                      },
                    ).show(context);
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Date Of Birth',
                            style: GoogleFonts.urbanist(
                              color: Colors.white60,
                              fontSize: value.selectedDate != null
                                  ? size.height * 0.015
                                  : size.height * 0.018,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            value.selectedDate != null
                                ? '${value.selectedDate!.year}-${value.selectedDate!.month}-${value.selectedDate!.day}'
                                : '',
                            style: GoogleFonts.urbanist(
                              color: Colors.white60,
                              fontSize: size.height * 0.018,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.white60),
                      ],
                    ),
                  ),
                ),
              ),

              //
              // const CustomTextField(hintText: "Gender", labelText: "Gender"),
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  hint: Text(
                    'Gender',
                    style: GoogleFonts.urbanist(
                      fontSize: size.height * 0.02,
                      color: Colors.white60,
                    ),
                  ),
                  items: value.gendersList
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: GoogleFonts.urbanist(
                                color: Colors.white60,
                                fontSize: size.height * 0.02,
                              ),
                            ),
                          ))
                      .toList(),
                  value: value.pickedGender,
                  onChanged: (String? val) {
                    value.pickedGender = val!;
                  },
                  dropdownStyleData: const DropdownStyleData(
                      decoration: BoxDecoration(color: Colors.black)),
                  buttonStyleData: ButtonStyleData(
                    height: 40,
                    width: size.width,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.001,
              ),
              SizedBox(
                  width: size.width,
                  child: const Divider(
                    color: Colors.white60,
                  )),
              //
              SizedBox(
                height: size.height * 0.015,
              ),
              //

              //
              Row(
                children: [
                  CupertinoCheckbox(
                      activeColor: primaryColor,
                      value: value.acceptPrivacyPolicy,
                      onChanged: (val) {
                        value.acceptPrivacyPolicy = val!;
                      }),
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "I accept the term of ",
                      style: GoogleFonts.urbanist(color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'use ',
                          style: GoogleFonts.urbanist(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'and ',
                          style: GoogleFonts.urbanist(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'privacy policy',
                          style: GoogleFonts.urbanist(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        })),
      ),
    );
  }
}
