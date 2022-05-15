import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:vocaloid_stream/services/all.dart';
import 'package:vocaloid_stream/utils/vocal_image_mapper.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../models/all.dart';

// ignore: must_be_immutable
class ImageStage extends StatefulWidget {
  static final routeName = '/image-stage';
  static final routeFavName = '/image-fav-stage';
  static final int playDuration = 5;
  List<VocalImage> _images;

  ImageStage({List<VocalImage> images}) {
    this._images = images != null ? images : null;
  }

  _ImageStageState createState() => _ImageStageState(images: this._images);
}

class _ImageStageState extends State<ImageStage> with TickerProviderStateMixin {
  List<VocalImage> _images; // passed faved
  int _currentIndex = 0;
  bool _playing = false;
  bool _fromFav = false;
  AnimationController controller;

  _ImageStageState({List<VocalImage> images}) {
    if (images != null) {
      setState(() {
        this._images = images;
        this._fromFav = true;
      });
    }
  }

  @override
  void initState() {
    this._playing = true;

    controller = AnimationController(
        duration: new Duration(seconds: ImageStage.playDuration), vsync: this)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _onNext();
        }
      });

    if (this._playing) controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _getVocalImage() {
    final VocalImage vocalImage = this._images != null
        ? this._images[this._currentIndex]
        : new VocalImage('assets/images/pic1.jpg', 'pic1', 0, network: false);

    return vocalImage;
  }

  _setStateFromBuildContext(BuildContext context) {
    final ImageStageArguments args = ModalRoute.of(context).settings.arguments;

    if (_images == null) _setFromArgs(args);
  }

  _setImages({List<VocalImage> vocalImages}) async {
    if (vocalImages != null) {
      setState(() {
        this._images = vocalImages;
      });
    } else {
      // final urls = await ImageFetcher.fetchRemote();
      final urls = await ImageCacher.read(toObject: false);
      print('imageStage - _setImages - urls: $urls');

      if (this._images == null) {
        final _images =
            await mapFromURLs(urls, network: true, checkLikes: true);
        setState(() {
          this._images = _images;
        });
      }
    }
  }

  _setFromArgs(ImageStageArguments args) async {
    if (_images == null) await _setImages(vocalImages: args.vocalImages);

    setState(() {
      if (args.fromFav != null && args.fromFav) {
        this._fromFav = args.fromFav;
        this._playing = false;
        this.controller.reset();
      }

      this._currentIndex = args.vocalImage.index;
    });
  }

  _onPrevious() {
    setState(() {
      controller.reset();
      int next = this._currentIndex - 1 >= 0 ? this._currentIndex - 1 : 0;
      this._currentIndex = next;
      if (_playing && !_fromFav) controller.forward();
    });
  }

  _onNext() {
    setState(() {
      controller.reset();
      int next = _currentIndex + 1 < _images.length ? _currentIndex + 1 : 0;
      _currentIndex = next;
      if (_playing && !_fromFav) controller.forward();
    });
  }

  _onPlayTap(BuildContext context) {
    if (!this._fromFav) {
      setState(() {
        this._playing = !this._playing;

        if (this._playing) {
          controller.forward();
        } else {
          controller.stop();
        }
      });
    }
  }

  _onLikeTap(BuildContext context, VocalImage vocalImage) {
    setState(() {
      vocalImage.liked = vocalImage.liked != null ? !vocalImage.liked : true;
      if (vocalImage.liked != null && vocalImage.liked) {
        Provider.of<Favorites>(context, listen: false).add(vocalImage);
      } else {
        Provider.of<Favorites>(context, listen: false).remove(vocalImage);
      }
    });

    // nav from fav
    if (this._fromFav) Navigator.pop(context);
  }

  _onSwipe(DragEndDetails details) {
    print('_onSwipe - detials: ${details.velocity.pixelsPerSecond}');
    // print('_onSwipe - detials: ${dragEndDetails.primaryVelocity}');
    if (details.primaryVelocity > 50.0) {
      _onPrevious();
    } else if (details.primaryVelocity < -50.0) {
      _onNext();
    }
  }

  _onDragDown(DragEndDetails dragDownDetails) {
    if (dragDownDetails.primaryVelocity > 200.0) {
      print('_onDragDown - about to got back');
    }
  }

  Widget _imageStageElement(BuildContext context, VocalImage vocalImage) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      margin: const EdgeInsets.all(0),
      child: Stack(
        children: [
          Center(child: CircularProgressIndicator()),
          GestureDetector(
            onTap: () => _onPlayTap(context),
            onDoubleTap: () => _onLikeTap(context, vocalImage),
            onHorizontalDragStart: (details) {
              print('onHorizontalDragStart - detials: ${details}');
            },
            onHorizontalDragEnd: _onSwipe,
            onHorizontalDragUpdate: (details) {
              // print('onHorizontalDragUpdate - detials: ${details}');
            },
            onVerticalDragEnd: _onDragDown,
            child: InteractiveViewer(
              child: Center(
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: vocalImage.url,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _icons(BuildContext context, VocalImage vocalImage) {
    return this._fromFav
        ? [
            IconButton(
                icon: Icon(Icons.navigate_before),
                color: Colors.white,
                onPressed: () => _onPrevious()),
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
                icon: Icon(Icons.navigate_next),
                color: Colors.white,
                onPressed: () => _onNext()),
          ]
        : [
            IconButton(
                icon: Icon(Icons.navigate_before),
                color: Colors.white,
                onPressed: () => _onPrevious()),
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
                icon: this._playing
                    ? Icon(Icons.pause_circle_filled_outlined)
                    : Icon(Icons.play_arrow),
                color: Colors.white,
                onPressed: () => _onPlayTap(context)),
            IconButton(
                icon: Icon(Icons.navigate_next),
                color: Colors.white,
                onPressed: () => _onNext()),
          ];
  }

  Widget build(BuildContext context) {
    _setStateFromBuildContext(context);
    final VocalImage vocalImage = _getVocalImage();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (_) => Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: _imageStageElement(context, vocalImage),
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
                children: _icons(context, vocalImage),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
