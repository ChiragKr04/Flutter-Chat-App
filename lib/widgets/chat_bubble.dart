import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String userName;
  final String userImage;
  ChatBubble(this.message, this.isMe, this.userName, this.userImage,
      {this.key});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final key = GlobalKey();
  final ValueNotifier<double> _contHeight = ValueNotifier<double>(-100);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _contHeight.value = key.currentContext.size.width;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _contHeight.value = key.currentContext.size.width;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 15, left: 5.0, right: 5.0, bottom: 10),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: [
              ValueListenableBuilder<double>(
                valueListenable: _contHeight,
                builder: (ctx, height, child) {
                  print(_contHeight.value);
                  return Container(
                    key: key,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isMe
                          ? Colors.deepOrangeAccent[200]
                          : Colors.grey[700],
                      borderRadius: BorderRadius.only(
                        topLeft: !widget.isMe
                            ? Radius.circular(0.0)
                            : Radius.circular(10.0),
                        bottomRight: !widget.isMe
                            ? Radius.circular(10.0)
                            : Radius.circular(10.0),
                        topRight: !widget.isMe
                            ? Radius.circular(10.0)
                            : Radius.circular(0.0),
                        bottomLeft: !widget.isMe
                            ? Radius.circular(10.0)
                            : Radius.circular(10.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: widget.isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                        ),
                        Text(
                          widget.message,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign:
                              widget.isMe ? TextAlign.end : TextAlign.start,
                        ),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                top: widget.isMe ? -20 : -20,
                left: widget.isMe ? -10 : _contHeight.value - 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(widget.userImage),
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
