import 'package:birds_view/utils/colors.dart';
import 'package:birds_view/widgets/custom_button/custom_button.dart';
import 'package:birds_view/widgets/custom_textfield/custom_textfield.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../widgets/custom_image_picker_bottom_sheet/custom_image_picker_bottom_sheet.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final List<String> genders = ['Male', 'Female', 'Other'];

  get pickedFile => null;
  // ignore: prefer_typing_uninitialized_variables
  var selectedDate;
  // ignore: prefer_typing_uninitialized_variables
  var gender;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: CustomButton(
          text: 'Create Account',
          ontap: () {},
        ),
      ),
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
        title: RichText(
          text: TextSpan(
            text: "Create ",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.03,
                color: whiteColor),
            children: [
              TextSpan(
                text: 'An ',
                style:
                    TextStyle(fontSize: size.height * 0.03, color: whiteColor),
              ),
              TextSpan(
                text: 'Account ',
                style: TextStyle(
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: size.width * 0.4,
                height: size.height * 0.16,
                color: Colors.black,
                child: Stack(
                  children: [
                    pickedFile != null
                        ? Center(
                            child: CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: size.height * 0.075,
                            backgroundImage: FileImage(pickedFile!),
                          ))
                        : Center(
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: size.height * 0.075,
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
                                    cameraontap: () {},
                                    galleryontap: () {},
                                  ));
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            CupertinoIcons.camera,
                            color: Colors.black,
                          ),
                        ),
                      ),
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
                    child: const CustomTextField(
                        obsecure: false,
                        textEditingController: null,
                        hintText: "First Name",
                        labelText: "First Name")),
                //

                SizedBox(
                  width: size.width * 0.45,
                  child: const CustomTextField(
                      obsecure: false,
                      textEditingController: null,
                      hintText: "Last Name",
                      labelText: "Last Name"),
                ),
                //
              ],
            ),
            //

            const CustomTextField(
                obsecure: false,
                textEditingController: null,
                hintText: "Email",
                labelText: "Email"),

            //
            CustomTextField(
                iconOnTap: () {},
                icon: const Icon(
                  Icons.visibility,
                  color: Colors.white60,
                ),
                obsecure: false,
                textEditingController: null,
                hintText: "Password",
                labelText: "Password"),

            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
              width: size.width,
              height: size.height * 0.09,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  BottomPicker.date(
                    backgroundColor: Colors.black,
                    pickerTitle: Text(
                      'Select Date Of Birth',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                    dateOrder: DatePickerDateOrder.dmy,
                    initialDateTime: DateTime(1996, 10, 22),
                    maxDateTime: DateTime.now(),
                    minDateTime: DateTime(1980),
                    pickerTextStyle: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    buttonSingleColor: Colors.black,
                    closeIconColor: primaryColor,
                    buttonStyle: BoxDecoration(color: primaryColor),
                    onChange: (index) {},
                    onSubmit: (date) {},
                  ).show(context);
                },
                child: SizedBox(
                  width: size.width,
                  height: size.height * 0.07,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Date Of Birth',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: selectedDate != null
                                ? size.height * 0.015
                                : size.height * 0.018,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          selectedDate != null
                              ? '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}'
                              : '',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: size.height * 0.018,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
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
                  style: TextStyle(
                    fontSize: size.height * 0.02,
                    color: Colors.white60,
                  ),
                ),
                items: genders
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ))
                    .toList(),
                value: gender,
                onChanged: (String? value) {
                  gender = value;
                  setState(() {});
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
              height: size.height * 0.01,
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
                    value: true,
                    onChanged: (val) {}),
                SizedBox(
                  width: size.width * 0.015,
                ),
                RichText(
                  text: const TextSpan(
                    text: "I accept the term of ",
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: 'use ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'and ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'privacy policy',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
