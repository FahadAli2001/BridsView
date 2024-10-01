import 'package:birds_view/model/group_model/group_model.dart';
import 'package:birds_view/model/user_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGroups extends StatelessWidget {
  final UserModel? userModel;
  final int index;
  final List<GroupModel> groupDetail;
  const CustomGroups({super.key,required this.index,required this.groupDetail,required this.userModel});

  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      child: ListTile(
        leading:   CircleAvatar(
          backgroundColor: Colors.grey.shade500,
          backgroundImage: NetworkImage(groupDetail[index].groupImage),
        ),
        title: Text(
          groupDetail[index].groupName,
          style: GoogleFonts.urbanist(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.02),
        ),
        subtitle: Text(
          "you sent an message",
          style: GoogleFonts.urbanist(
            color: Colors.white,
          ),
        ),
        trailing: Text(
          "9:03",
          style: GoogleFonts.urbanist(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}