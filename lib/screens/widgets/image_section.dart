import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../models/all.dart';
import '../all.dart';

class ImageSection extends StatelessWidget {
  final VocalImage _vocalImage;
  final List<VocalImage> vocalImages;
  final bool _fromFav;

  ImageSection(this._vocalImage, this._fromFav, {this.vocalImages});

  _detailViewTap(BuildContext context) {
    final args = new ImageStageArguments(this._vocalImage, this._fromFav,
        vocalImages: this.vocalImages);
    Navigator.pushNamed(context, ImageStage.routeName, arguments: args);
  }

  Widget detailViewBuild(BuildContext context) {
    return GestureDetector(
      onTap: () => this._detailViewTap(context),
      child: Stack(
        children: [
          Center(child: CircularProgressIndicator()),
          Container(
            constraints: BoxConstraints.expand(height: 200.0),
            decoration: BoxDecoration(color: Colors.grey[350]),
            margin: const EdgeInsets.all(0),
            child: this._vocalImage.network != null && this._vocalImage.network
                ? FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: this._vocalImage.url,
                    fit: BoxFit.cover,
                  )
                : Image.asset(this._vocalImage.url, fit: BoxFit.cover),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return detailViewBuild(context);
  }
}
