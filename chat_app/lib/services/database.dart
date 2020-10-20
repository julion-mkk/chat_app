import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethod {
    getUserByUsername(String username) async {
        return await Firestore.instance.collection('users').where("name", isEqualTo: username).getDocuments();
    }

    getUserByEmail(String email) async {
        return await Firestore.instance.collection('users').where("email", isEqualTo: email).getDocuments();
    }

    uploadUserInfo(userMap) {
        Firestore.instance.collection('users').add(userMap);
    }

    createChatRoom(String chatRoomId, chatRoomMap) {
        Firestore.instance.collection('chatroom').document(chatRoomId).setData(chatRoomMap).catchError((e) {
            print(e.toString());
        });
    }

    addConversationMessage(String chatRoomId,messageMap) {
        Firestore.instance.collection('chatroom').document(chatRoomId).collection('chats').add(messageMap).then((value) => print(value));
    }

    getConversationMessages(String chatRoomId) async {
        return await Firestore.instance.collection('chatroom').document(chatRoomId).collection('chats').orderBy('time', descending: false).snapshots();
    }

    getChatRooms(String username) async {
        return await Firestore.instance.collection('chatroom').where('users', arrayContains: username).snapshots();
    }
}