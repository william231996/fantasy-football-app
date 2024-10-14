import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerCard extends StatelessWidget {
  final snapshot;
  const PlayerCard(this.snapshot, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 375.w,
          height: 54.h,
          color: Colors.grey[300],
          child: Center(
            child: ListTile(
              leading: ClipOval(
                child: SizedBox(
                    width: 35.w,
                    height: 35.h,
                    child: Image.asset(
                        'https://static-00.iconduck.com/assets.00/profile-default-icon-2048x2045-u3j7s5nj.png')),
              ),
              title: Text(snapshot['PlayerName'], style: TextStyle(fontSize: 16.sp)),
              subtitle: Text(snapshot['Team'], style: TextStyle(fontSize: 14.sp)),
              trailing: Icon(Icons.more_vert),
            ),
          ),
        ),
      ],
    );
  }
}
