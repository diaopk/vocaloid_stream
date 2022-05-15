import 'package:flutter/material.dart';
import 'package:vocaloid_stream/models/all.dart';
import 'package:provider/provider.dart';
import 'all.dart';

// ignore: must_be_immutable
class ImageGrid extends StatefulWidget {
  _ImageGridState createState() => _ImageGridState();
}

class _ImageGridState extends State<ImageGrid> {
  ScrollController _controller = ScrollController();
  BuildContext _context;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.position.pixels) {
        print(
            'imageGrid - initState - _controller - listener: ${_controller.offset} - _context: $_context');
        _context.read<ImageStageModel>().append();
      }
    });
  }

  List<Widget> _imageGridItems(
      BuildContext context, List<VocalImage> vocalImages) {
    return vocalImages != null
        ? vocalImages
            .asMap()
            .entries
            .map((map) => Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ImageGridItem(map.value, false),
                ))
            .toList()
        : [];
  }

  Widget build(BuildContext context) {
    if (_context == null) _context = context;

    return Container(
      color: Colors.black,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        crossAxisCount: 2,
        controller: _controller,
        children: _imageGridItems(
            context, context.watch<ImageStageModel>().vocalImages),
      ),
    );
  }
}
