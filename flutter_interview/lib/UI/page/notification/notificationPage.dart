// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_interview/UI/Theme/theme.dart';
import 'package:flutter_interview/UI/page/notification/widget/follow_notification_tile.dart';
import 'package:flutter_interview/UI/page/notification/widget/post_like_tile.dart';
import 'package:flutter_interview/helper/enum.dart';
import 'package:flutter_interview/model/feedModel.dart';
import 'package:flutter_interview/model/notificationModel.dart';
import 'package:flutter_interview/state/authState.dart';
import 'package:flutter_interview/state/notificationState.dart';
import 'package:flutter_interview/widgets/NewWidget/emptyList.dart';
import 'package:flutter_interview/widgets/custom_appbar.dart';
import 'package:flutter_interview/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, required this.scaffoldKey})
      : super(key: key);

  /// scaffoldKey used to open sidebar drawer
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var state = Provider.of<NotificationState>(context, listen: false);
      var authState = Provider.of<AuthState>(context, listen: false);
      state.getDataFromDatabase(authState.userId);
    });
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/NotificationPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      appBar: CustomAppBar(
        scaffoldKey: widget.scaffoldKey,
        title: customTitleText(
          'Notifications',
        ),
        icon: AppIcon.settings,
        onActionPressed: onSettingIconPressed,
      ),
      body: NotificationPageBody(scaffoldKey: widget.scaffoldKey),
    );
  }
}

class NotificationPageBody extends StatelessWidget {
  const NotificationPageBody({Key? key, required this.scaffoldKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  Widget _notificationRow(BuildContext context, NotificationModel model) {
    var state = Provider.of<NotificationState>(context);
    if (model.type == NotificationType.Follow.toString()) {
      return FollowNotificationTile(
        model: model,
      );
    }
    return FutureBuilder(
      future: state.getTweetDetail(model.tweetKey!),
      builder: (BuildContext context, AsyncSnapshot<FeedModel?> snapshot) {
        if (snapshot.hasData) {
          return PostLikeTile(model: snapshot.data!);
        } else if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return const SizedBox(
            height: 4,
            child: LinearProgressIndicator(),
          );
        } else {
          /// remove notification from firebase db if tweet in not available or deleted.
          var authState = Provider.of<AuthState>(context);
          state.removeNotification(authState.userId, model.tweetKey!);
          return const SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<NotificationState>(context);
    var list = state.notificationList;
    if (state.isbusy) {
      return const SizedBox(
        height: 3,
        child: LinearProgressIndicator(),
      );
    } else if (list == null || list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: EmptyList(
          'No Notification available yet',
          subTitle: 'When new notification found, they\'ll show up here.',
        ),
      );
    }
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) => _notificationRow(context, list[index]),
      itemCount: list.length,
    );
  }
}
