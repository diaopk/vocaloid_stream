import 'package:vocaloid_stream/models/all.dart';

class ImageStageArguments {
  final VocalImage vocalImage;
  final List<VocalImage> vocalImages;
  final bool fromFav;

  ImageStageArguments(this.vocalImage, this.fromFav, {this.vocalImages});

  String toString() {
    return 'imageStageArguments - vocalImage: ${this.vocalImage}, vocalImages: $vocalImages, fromFav: $fromFav';
  }
}
