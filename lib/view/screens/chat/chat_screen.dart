import 'dart:io';

import 'package:emarket_user/data/model/response/order_model.dart';
import 'package:emarket_user/helper/responsive_helper.dart';
import 'package:emarket_user/localization/language_constrants.dart';
import 'package:emarket_user/notification/my_notification.dart';
import 'package:emarket_user/provider/auth_provider.dart';
import 'package:emarket_user/provider/chat_provider.dart';
import 'package:emarket_user/provider/profile_provider.dart';
import 'package:emarket_user/provider/splash_provider.dart';
import 'package:emarket_user/utill/dimensions.dart';
import 'package:emarket_user/utill/images.dart';
import 'package:emarket_user/utill/styles.dart';
import 'package:emarket_user/view/base/custom_snackbar.dart';
import 'package:emarket_user/view/base/not_logged_in_screen.dart';
import 'package:emarket_user/view/base/web_header/web_app_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../../base/custom_app_bar_2.dart';
import 'widget/message_bubble.dart';
import 'widget/message_bubble_shimmer.dart';

class ChatScreen extends StatefulWidget {
  final OrderModel orderModel;
  const ChatScreen({Key key,@required this.orderModel}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputMessageController = TextEditingController();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _isLoggedIn;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    if(!kIsWeb){
      var androidInitialize = const AndroidInitializationSettings('notification_icon');
      var iOSInitialize = const IOSInitializationSettings();
      var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationsSettings);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        MyNotification.showNotification(message, flutterLocalNotificationsPlugin, false);

        Provider.of<ChatProvider>(context, listen: false).getMessages(context, 1, widget.orderModel, false);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        Provider.of<ChatProvider>(context, listen: false).getMessages(context, 1, widget.orderModel, false);
      });
    }
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();


    if(_isLoggedIn){
      if(_isFirst) {

        Provider.of<ChatProvider>(context, listen: false).getMessages(context, 1, widget.orderModel, true);
      }else {
        Provider.of<ChatProvider>(context, listen: false).getMessages(context, 1, widget.orderModel, false);
        _isFirst = false;
      }
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }

  }
  @override
  Widget build(BuildContext context) {
    //
    final bool _isAdmin = widget.orderModel == null ? true : false;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))
          : AppBar(title: _isAdmin ? Text('${Provider.of<SplashProvider>(context,listen: false).configModel.ecommerceName}')
          : CustomAppBar2(
        title: getTranslated('help_and_support', context), )
      )  ,

      body: _isLoggedIn? Center(
        child: Container(
          width: ResponsiveHelper.isDesktop(context) ?1170:MediaQuery.of(context).size.width,
          child: Column(
            children: [

              Consumer<ChatProvider>(
                  builder: (context, chatProvider,child) {
                    return  Expanded(
                      child: chatProvider.messageList != null ? chatProvider.messageList.length > 0 ? ListView.builder(
                          reverse: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: chatProvider.messageList.length,
                          itemBuilder: (context, index){
                            return MessageBubble(messages: chatProvider.messageList[index], isAdmin: _isAdmin);
                          }):SizedBox():MessageBubbleShimmer(isMe: false),
                    );
                  }
              ),

              Container(
                color: Theme.of(context).cardColor,
                child: Column(
                  children: [
                    Consumer<ChatProvider>(
                        builder: (context, chatProvider,_) {
                          return chatProvider.chatImage.length>0?
                          Container(height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: chatProvider.chatImage.length,
                              itemBuilder: (BuildContext context, index){
                                return  chatProvider.chatImage.length > 0?
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Container(width: 100, height: 100,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
                                          child: ResponsiveHelper.isWeb()? Image.network(chatProvider.chatImage[index].path, width: 100, height: 100,
                                            fit: BoxFit.cover,
                                          ):Image.file(File(chatProvider.chatImage[index].path), width: 100, height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ) ,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                      ),
                                      Positioned(
                                        top:0,right:0,
                                        child: InkWell(
                                          onTap :() => chatProvider.removeImage(index),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT))
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Icon(Icons.clear,color: Colors.red,size: 15,),
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ):SizedBox();

                              },),
                          ):SizedBox();
                        }
                    ),
                    Row(children: [
                      InkWell(
                        onTap: () async {
                          Provider.of<ChatProvider>(context, listen: false).pickImage(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Image.asset(Images.image, width: 25, height: 25, color: Theme.of(context).hintColor),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        child: VerticalDivider(width: 0, thickness: 1, color: Theme.of(context).hintColor),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                      Expanded(
                        child: TextField(
                          inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.MESSAGE_INPUT_LENGTH)],
                          controller: _inputMessageController,
                          textCapitalization: TextCapitalization.sentences,
                          style: rubikRegular,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type here',
                            hintStyle: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                          onSubmitted: (String newText) {
                            if(newText.trim().isNotEmpty && !Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                              Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                            }else if(newText.isEmpty && Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                              Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                            }
                          },
                          onChanged: (String newText) {
                            if(newText.trim().isNotEmpty && !Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                              Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                            }else if(newText.isEmpty && Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                              Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                            }
                          },

                        ),
                      ),




                      InkWell(
                        onTap: () async {
                          if(Provider.of<ChatProvider>(context, listen: false).isSendButtonActive){
                              Provider.of<ChatProvider>(context, listen: false).sendMessage(_inputMessageController.text, context, Provider.of<AuthProvider>(context, listen: false).getUserToken(), widget.orderModel);
                              _inputMessageController.clear();
                            Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();

                          }else{
                            showCustomSnackBar(getTranslated('write_somethings', context), context);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Provider.of<ChatProvider>(context, listen: false).isLoading ? SizedBox(
                            width: 25, height: 25,
                            child: CircularProgressIndicator(),
                          ) : Image.asset(Images.send, width: 25, height: 25,
                            color: Provider.of<ChatProvider>(context).isSendButtonActive ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                          ),
                        ),
                      ),

                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ): NotLoggedInScreen(),
    );
  }
}
