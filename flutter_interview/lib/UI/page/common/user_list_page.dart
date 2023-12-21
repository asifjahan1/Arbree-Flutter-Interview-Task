import 'package:flutter/material.dart';
import 'package:flutter_interview/UI/Theme/theme.dart';
import 'package:flutter_interview/UI/page/common/widget/userListWidget.dart';
import 'package:flutter_interview/model/user.dart';
import 'package:flutter_interview/state/search_state.dart';
import 'package:flutter_interview/widgets/NewWidget/emptyList.dart';
import 'package:flutter_interview/widgets/custom_appbar.dart';
import 'package:flutter_interview/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({
    Key? key,
    this.pageTitle = "",
    required this.emptyScreenText,
    required this.emptyScreenSubTileText,
    this.userIdsList,
    this.onFollowPressed,
    this.isFollowing,
  }) : super(key: key);

  final String pageTitle;
  final String emptyScreenText;
  final String emptyScreenSubTileText;
  final bool Function(UserModel user)? isFollowing;
  final List<String>? userIdsList;
  final Function(UserModel user)? onFollowPressed;

  @override
  Widget build(BuildContext context) {
    List<UserModel>? userList;
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          pageTitle,
        ),
      ),
      body: Consumer<SearchState>(
        builder: (context, state, child) {
          if (userIdsList != null && userIdsList!.isNotEmpty) {
            userList = state.getuserDetail(userIdsList!);
          }
          return userList != null && userList!.isNotEmpty
              ? UserListWidget(
                  list: userList!,
                  emptyScreenText: emptyScreenText,
                  emptyScreenSubTileText: emptyScreenSubTileText,
                  onFollowPressed: onFollowPressed,
                  isFollowing: isFollowing,
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 0, left: 30, right: 30),
                  child: NotifyText(
                    title: emptyScreenText,
                    subTitle: emptyScreenSubTileText,
                  ),
                );
        },
      ),
    );
  }
}
