import 'package:flutter/material.dart';

class ShowUserChatImage extends StatefulWidget {
  final imageSrc;
  ShowUserChatImage(this.imageSrc);

  @override
  _ShowUserChatImageState createState() => _ShowUserChatImageState();
}

class _ShowUserChatImageState extends State<ShowUserChatImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(5),
        child: Center(
          child: Hero(
            tag: widget.imageSrc,
            child: Image.network(
              widget.imageSrc,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
