// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_interview/UI/page/Auth/select_auth_method.dart';
import 'package:flutter_interview/UI/page/Auth/signin.dart';
import 'package:flutter_interview/UI/page/Auth/signup.dart';
import 'package:flutter_interview/UI/page/Auth/verify_email.dart';
import 'package:flutter_interview/UI/page/common/splash.dart';
import 'package:flutter_interview/UI/page/feed/composeTweet/composeTweet.dart';
import 'package:flutter_interview/UI/page/feed/composeTweet/state/composeTweetState.dart';
import 'package:flutter_interview/UI/page/feed/feed_postDetail.dart';
import 'package:flutter_interview/UI/page/feed/image_view_page.dart';
import 'package:flutter_interview/UI/page/homepage.dart';
import 'package:flutter_interview/UI/page/message/chatScreenPage.dart';
import 'package:flutter_interview/UI/page/message/conversationInformation/conversationInformation.dart';
import 'package:flutter_interview/UI/page/message/newMessagePage.dart';
import 'package:flutter_interview/UI/page/notification/notificationPage.dart';
import 'package:flutter_interview/UI/page/profile/follow/followerListPage.dart';
import 'package:flutter_interview/UI/page/profile/profilePage.dart';
import 'package:flutter_interview/UI/page/search/Search_page.dart';
import 'package:flutter_interview/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

import '../helper/customRoute.dart';
import '../ui/page/Auth/forgetPasswordPage.dart';

class Routes {
  static dynamic route() {
    return {
      'SplashPage': (BuildContext context) => const SplashPage(),
    };
  }

  static void sendNavigationEventToFirebase(String? path) {
    if (path != null && path.isNotEmpty) {
      // analytics.setCurrentScreen(screenName: path);
    }
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name!.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "ComposeTweetPage":
        bool isRetweet = false;
        bool isTweet = false;
        if (pathElements.length == 3 && pathElements[2].contains('retweet')) {
          isRetweet = true;
        } else if (pathElements.length == 3 &&
            pathElements[2].contains('tweet')) {
          isTweet = true;
        }
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                ChangeNotifierProvider<ComposeTweetState>(
                  create: (_) => ComposeTweetState(),
                  child: ComposeTweetPage(
                    isRetweet: isRetweet,
                    isTweet: isTweet,
                    scaffoldKey: GlobalKey<ScaffoldState>(),
                  ),
                ));
      case "FeedPostDetail":
        var postId = pathElements[2];
        return SlideLeftRoute<bool>(
            builder: (BuildContext context) => FeedPostDetail(
                  postId: postId,
                ),
            settings: const RouteSettings(name: 'FeedPostDetail'));
      case "ProfilePage":
        String profileId;
        if (pathElements.length > 2) {
          profileId = pathElements[2];
          return CustomRoute<bool>(
              builder: (BuildContext context) => ProfilePage(
                    profileId: profileId,
                  ));
        }
        return CustomRoute(builder: (BuildContext context) => HomePage());

      case "CreateFeedPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) =>
                ChangeNotifierProvider<ComposeTweetState>(
                  create: (_) => ComposeTweetState(),
                  child: ComposeTweetPage(
                    isRetweet: false,
                    isTweet: true,
                    scaffoldKey: GlobalKey<ScaffoldState>(),
                  ),
                ));
      case "WelcomePage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => const WelcomePage());
      case "SignIn":
        return CustomRoute<bool>(builder: (BuildContext context) => SignIn());
      case "SignUp":
        return CustomRoute<bool>(builder: (BuildContext context) => Signup());
      case "ForgetPasswordPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => const ForgetPasswordPage());
      case "SearchPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => SearchPage());
      case "ImageViewPge":
        return CustomRoute<bool>(
            builder: (BuildContext context) => const ImageViewPge());
      case "ChatScreenPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => const ChatScreenPage());
      case "NewMessagePage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => NewMessagePage(),
        );
      case "NotificationPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) =>
              NotificationPage(scaffoldKey: GlobalKey<ScaffoldState>()),
        );
      case "ConversationInformation":
        return CustomRoute<bool>(
          builder: (BuildContext context) => const ConversationInformation(),
        );
      case "FollowerListPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => FollowerListPage(),
        );
      case "VerifyEmailPage":
        return CustomRoute<bool>(
          builder: (BuildContext context) => VerifyEmailPage(),
        );
      default:
        return onUnknownRoute(const RouteSettings(name: '/Feature'));
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: customTitleText(
            settings.name!.split('/')[1],
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Text('${settings.name!.split('/')[1]} Comming soon..'),
        ),
      ),
    );
  }
}
