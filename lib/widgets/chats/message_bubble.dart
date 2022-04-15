import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.message, this.isMe, this.userName, this.usrImage,
      {Key? key})
      : super(key: key);

  final String message;
  final bool
      isMe; // To differentiate between the chats that  are written by me & someone else
  final String userName;
  final String
      usrImage; // Stores the url to the image, fetched from each chat meessage

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          //* So that ListView respects the width assign to the container of 140. If you dont use row, ListView will ignore the width assigned to container and just assign it double.infinity
          //* Also Row will help us to render our chats on right side
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
              ),
              width: 140,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                        color: isMe ? Colors.blue : Colors.lightGreen,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(usrImage),
          ),
        ),
      ],
      clipBehavior: Clip
          .none, // This will not hide the circle if it run out of height, it will still reder the overflowed widget
    );
  }
}
