import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool hasNavigation;

  const ProfileListItem({
    // Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
  });

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: deviceSize.width, maxHeight: deviceSize.height),
        designSize: Size(deviceSize.width, deviceSize.height),
        allowFontScaling: true);
    return Container(
      // width: 0.73.sw,
      height: 0.07.sh,
      margin: EdgeInsets.symmetric(
        horizontal: 0.08.sw,
      ).copyWith(
        bottom: 0.05.sw,
      ),
      // padding: EdgeInsets.symmetric(
      //   horizontal: 100.w,
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: Theme.of(context).backgroundColor,
      ),
      child: (Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 0.05.sw),
          Icon(
            this.icon,
            size: 0.08.sw,
          ),
          SizedBox(width: 0.05.sw),
          Text(this.text,
              style: TextStyle(
                fontSize: 16.ssp,
                fontWeight: FontWeight.w600,
              )),

          // Spacer(),
          /*if (this.hasNavigation)
            Icon(
              LineAwesomeIcons.angle_right,
              size: kSpacingUnit.w * 2.5,
            ),*/
        ],
      )),
    );
  }
}
