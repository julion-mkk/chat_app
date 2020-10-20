import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constraint.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/screens/search.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
    ChatRoomState createState()=> ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
    AuthMethods _authMethods= new AuthMethods();
    DataBaseMethod dataBaseMethod= new DataBaseMethod();
    Stream chatRoomStream;

    initState() {
        super.initState();
        getUserLoginInfo();
    }

    getUserLoginInfo() async {
        Constraints.myName = await HelperFunctions.getUsernameSharedPreference();
        dataBaseMethod.getChatRooms(Constraints.myName).then((value) {
            setState(() {
                chatRoomStream = value;
                print(chatRoomStream);
            });
        });
    }

    Widget chatRoomList() {
        return StreamBuilder(
            stream: chatRoomStream,
            builder: (context,snapshot) {
                return snapshot.hasData ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context,index) {
                        return ChatRoomTile(snapshot.data.documents[index].data['chatroomid'].toString().replaceAll('_', '').replaceAll(Constraints.myName,''),snapshot.data.documents[index].data['chatroomid']);
                    },
                ) : Container();
            },
        );
    }

    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Image.asset('assets/images/logo.png', height: 40,),
                actions: [
                    GestureDetector(
                        onTap: () {
                            _authMethods.signOut();
                            HelperFunctions.savedUserLoggedInSharedPreference(false);
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => Authenticate()
                            ));
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.exit_to_app),
                        )
                    ),

                ],
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> Search()
                    ));
                },
            ),
            body: chatRoomList(),
        );
    }
}

class ChatRoomTile extends StatelessWidget {
    final String username;
    final String chatRoomId;
    ChatRoomTile(this.username,this.chatRoomId);
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                Navigator.push(context,MaterialPageRoute(
                    builder: (context) => ConversationScreen(chatRoomId)
                ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                    children: [
                        Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.blue,
                            ),
                            child: Text('${username.substring(0,1).toUpperCase()}'),
                        ),
                        SizedBox(
                            width: 8,
                        ),
                        Text(username, style: simpleTextStyle(),)
                    ],
                ),
            ),
        );
    }
}