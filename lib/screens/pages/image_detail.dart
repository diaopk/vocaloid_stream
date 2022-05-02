import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocaloid_stream/models/all.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ImageDetail extends StatefulWidget {
  static String routeName = '/image-detail';
  VocalImage vocalImage;
  Function onNext;

  ImageDetail({this.vocalImage, this.onNext}) {
    print('passed vocalImage: ${this.vocalImage.url}');
  }

  _ImageDetailState createState() =>
      _ImageDetailState(vocalImage: vocalImage, onNext: onNext);
}

class _ImageDetailState extends State<ImageDetail>
    with TickerProviderStateMixin {
  AnimationController controller;
  bool playing = false;
  VocalImage vocalImage;
  Function onNext;

  _ImageDetailState({this.vocalImage, this.onNext});

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // _onPlayComplete();
          onNext();
        }
      });

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _onLikeTap(BuildContext context, VocalImage vocalImage) {
    print(
        'imagePath: ${vocalImage.url}, imageIndex: ${vocalImage.index}, label: ${vocalImage.label}, context: ${context}');
    // set state - like
    setState(() {
      vocalImage.liked = vocalImage.liked != null ? !vocalImage.liked : true;
    });

    if (vocalImage.liked != null && vocalImage.liked) {
      // Provider.of<Favorites>(context, listen: false).add(vocalImage);
    } else {
      // Provider.of<Favorites>(context, listen: false).remove(vocalImage);
    }

    // final snackBar = SnackBar(
    //   content: Text(vocalImage.liked != null && vocalImage.liked
    //       ? 'Image added to favs ^_^'
    //       : 'Image removed from favs @_@'),
    //   duration: Duration(seconds: 2),
    //   action: SnackBarAction(
    //     label: 'Undo',
    //     onPressed: () {
    //       Provider.of<Favorites>(context, listen: false).remove(vocalImage);
    //     },
    //   ),
    // );

    // Scaffold.of(context).showSnackBar(snackBar);
  }

  _onPlayTap(BuildContext context) {
    setState(() {
      this.playing = !this.playing;

      if (this.playing) {
        controller.stop();
      } else {
        controller.forward();
      }
    });
  }

  Widget build(BuildContext context) {
    // final VocalImage _vocalImage = ModalRoute.of(context).settings.arguments;
    // this.vocalImage = _vocalImage != null ? _vocalImage : this.vocalImage;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Builder(
          builder: (ctx) => Stack(children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(color: Colors.black),
                margin: const EdgeInsets.all(0),
                child: vocalImage.network != null && vocalImage.network
                    ? Image.network(vocalImage.url)
                    : PhotoView(imageProvider: AssetImage(vocalImage.url)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: LinearProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: new AlwaysStoppedAnimation(Colors.white),
                value: controller.value,
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    vocalImage.liked != null && vocalImage.liked
                        ? IconButton(
                            icon: Icon(Icons.favorite),
                            color: Colors.white,
                            onPressed: () => _onLikeTap(context, vocalImage))
                        : IconButton(
                            icon: Icon(Icons.favorite_border),
                            color: Colors.white,
                            onPressed: () => _onLikeTap(context, vocalImage)),
                    IconButton(
                        icon: Icon(Icons.download_outlined),
                        color: Colors.white,
                        onPressed: () => {}),
                    IconButton(
                        icon: this.playing
                            ? Icon(Icons.play_arrow)
                            : Icon(Icons.pause),
                        color: Colors.white,
                        onPressed: () => _onPlayTap(context))
                  ],
                )),
          ]),
        ));
  }
}
