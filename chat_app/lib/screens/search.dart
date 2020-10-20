import 'package:chat_app/helper/constraint.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/conversation_screen.dart';

class Search extends StatefulWidget {
    SearchState createState()=> SearchState();
}

class SearchState extends State<Search> {
    TextEditingController searchController= new TextEditingController();
    DataBaseMethod dataBaseMethod = new DataBaseMethod();
    QuerySnapshot snapshot;
    bool haveUserSearched= false;

    searchUsers() async {
        await dataBaseMethod.getUserByUsername(searchController.text).then((value){
            setState(() {
              snapshot = value;
            });
        });
    }

    initState() {
        super.initState();

    }



    Widget build(BuildContext context) {
        return Scaffold(
            appBar: appBarMain(),
            body: Container(
                child : Column(
                    children: <Widget>[
                        Container(
                            color: Color(0x54FFFFFF),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Row(
                                children: <Widget>[
                                    Expanded(child: TextField(
                                        controller: searchController,
                                        style: simpleTextStyle(),
                                        decoration: InputDecoration(
                                            hintText: 'Search username',
                                            hintStyle: TextStyle(
                                                color: Colors.white54,
                                            ),
                                            border: InputBorder.none,
                                        ),
                                    ),
                                    ),
                                    IconButton(icon: Icon(Icons.search,color: Colors.white54,), onPressed: (){
                                        searchUsers();
                                    }),
                                ],
                            ),
                        ),
                        searchList()
                    ],
                ),
            )
        );
    }

    Widget searchList() {
        return snapshot != null ? ListView.builder(
            itemCount: snapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context,index) {
            return SearchTile(snapshot.documents[index].data['name'], snapshot.documents[index].data['email']);
        }) : Container();
    }
}

createChatRoomAndStartConversation({BuildContext context,String username}) async {
    print('blah blah');
    print('blah $username');
    print(Constraints.myName);
    if(username != Constraints.myName) {
        String chatRoomId= username +'_' + Constraints.myName;
        List<String> users = [username, Constraints.myName];
        Map<String, dynamic> chatRoomMap = {
            'users' : users,
            'chatroomid' : chatRoomId
        };

        await DataBaseMethod().createChatRoom(chatRoomId, chatRoomMap);
        Navigator.push(context,MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId)));
    }
    else {
        print('you cannot send message to yourself');
    }
}

class SearchTile extends StatelessWidget {
    final String username;
    final String email;
    SearchTile(this.username,this.email);


    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child : Row(
                children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text(username, style: simpleTextStyle(),),
                            Text(email, style: simpleTextStyle(),)
                        ],
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                            createChatRoomAndStartConversation(context: context, username: username);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Text('message',style: simpleTextStyle(),),

                        ),
                    )

                ],
            )
        );
    }
}