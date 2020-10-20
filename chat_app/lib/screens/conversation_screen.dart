import 'package:chat_app/helper/constraint.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
    String chatRoomId;
    ConversationScreen(this.chatRoomId);
    ConversationScreenState createState()=> ConversationScreenState();
}

class ConversationScreenState extends State<ConversationScreen> {
    Stream chatMessageStream;
    DataBaseMethod dataBaseMethod= new DataBaseMethod();
    TextEditingController messageController= new TextEditingController();

    Widget chatMessageList() {
        return StreamBuilder(
            stream: chatMessageStream,
            builder: (context,snapshot) {
                return snapshot.hasData ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context,index) {
                        return MessageTile(snapshot.data.documents[index].data['message'],snapshot.data.documents[index].data['sendBy'] == Constraints.myName);
                    },
                ): Container();
            },
        );
    }

    sendMessage() {
        if(messageController.text.isNotEmpty) {
            Map<String,dynamic> messageMap= {
                'message' : messageController.text,
                'sendBy' : Constraints.myName,
                'time' : DateTime.now().millisecondsSinceEpoch,
            };
            dataBaseMethod.addConversationMessage(widget.chatRoomId,messageMap);
        }

    }

    void initState() {
        super.initState();
        dataBaseMethod.getConversationMessages(widget.chatRoomId).then((value) {
            setState(() {
              chatMessageStream = value;
              print(chatMessageStream);
            });
        });
    }

    Widget build(BuildContext context) {
        return Scaffold(
            appBar: appBarMain(),
            body: Container(
                child: Stack(
                    children: [
                        Container(
                            height: MediaQuery.of(context).size.height - 180,
                            child : chatMessageList(),
                        ),
                        Container(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Color(0x54FFFFFF),
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                child: Row(
                                    children: <Widget>[
                                        Expanded(child: TextField(
                                            controller: messageController,
                                            style: simpleTextStyle(),
                                            decoration: InputDecoration(
                                                hintText: 'Message...',
                                                hintStyle: TextStyle(
                                                    color: Colors.white54,
                                                ),
                                                border: InputBorder.none,
                                            ),
                                        ),
                                        ),
                                        IconButton(icon: Icon(Icons.send,color: Colors.white54,), onPressed: (){
                                            sendMessage();
                                            setState(() {
                                                messageController.text= '';
                                            });

                                        }),
                                    ],
                                ),
                            ),
                        )
                    ],
                ),
            ),
        );
    }
}

class MessageTile extends StatelessWidget {
    final String message;
    final bool isSendByMe;
    MessageTile(this.message, this.isSendByMe);
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.only(left: isSendByMe? 0 : 14, right:  isSendByMe? 14 :0),
            width: MediaQuery.of(context).size.width,
            alignment: isSendByMe? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: isSendByMe ? [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                        ]
                            : [
                            const Color(0x1AFFFFFF),
                            const Color(0x1AFFFFFF)
                        ],
                    ),
                    borderRadius: !isSendByMe ? BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23), bottomRight: Radius.circular(23)) :
                    BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23), bottomLeft: Radius.circular(23))
                ),
                child: Text(message,style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,),
                )
            ),
        );
    }
}