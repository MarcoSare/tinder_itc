import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tinder_itc/firebase/users_firebase.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;
  final String? device;
  final String name;

  MessageTextField(this.currentId, this.friendId, this.device, this.name);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            maxLines: null, // Permite un número ilimitado de líneas
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25))),
          )),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(widget.currentId)
                  .collection('matchs')
                  .doc(widget.friendId)
                  .collection('chats')
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(widget.currentId)
                    .collection('matchs')
                    .doc(widget.friendId)
                    .set({
                  'last_msg': message,
                });
              });

              await FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(widget.friendId)
                  .collection('matchs')
                  .doc(widget.currentId)
                  .collection("chats")
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(widget.friendId)
                    .collection('matchs')
                    .doc(widget.currentId)
                    .set({"last_msg": message});
              });
              if (widget.device != null) {
                print(widget.device);
                UsersFireBase.sendNoti(data: {
                  'to': widget.device!,
                  'notification': {
                    'body': message,
                    'OrganizationId': '2',
                    "content_available": true,
                    "priority": "high",
                    "subtitle": 'Nuevo mensaje',
                    "title": widget.name
                  },
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFB61F39),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
