import 'package:flutter/material.dart';
import 'package:flutter_interview/UI/Theme/theme.dart';
import 'package:flutter_interview/UI/page/profile/profilePage.dart';
import 'package:flutter_interview/UI/page/profile/widget/circular_image.dart';
import 'package:flutter_interview/model/user.dart';
import 'package:flutter_interview/state/chats/chatState.dart';
import 'package:flutter_interview/widgets/NewWidget/rippleButton.dart';
import 'package:flutter_interview/widgets/custom_appbar.dart';
import 'package:flutter_interview/widgets/custom_widgets.dart';
import 'package:flutter_interview/widgets/url_text/customUrlText.dart';
import 'package:provider/provider.dart';

class ConversationInformation extends StatelessWidget {
  const ConversationInformation({Key? key}) : super(key: key);

  Widget _header(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: SizedBox(
                height: 80,
                width: 80,
                child: RippleButton(
                  onPressed: () {
                    Navigator.push(
                        context, ProfilePage.getRoute(profileId: user.userId!));
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: CircularImage(path: user.profilePic, height: 80),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UrlText(
                text: user.displayName!,
                style: TextStyles.onPrimaryTitleText.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              user.isVerified!
                  ? customIcon(
                      context,
                      icon: AppIcon.blueTick,
                      isTwitterIcon: true,
                      iconColor: AppColor.primary,
                      size: 18,
                      paddingIcon: 3,
                    )
                  : const SizedBox(width: 0),
            ],
          ),
          customText(
            user.userName,
            style: TextStyles.onPrimarySubTitleText.copyWith(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<ChatState>(context).chatUser ?? UserModel();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Conversation information',
        ),
      ),
    );
  }
}
