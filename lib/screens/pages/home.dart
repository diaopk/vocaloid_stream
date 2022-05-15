import 'package:flutter/material.dart';
import 'package:vocaloid_stream/models/all.dart';
import 'package:provider/provider.dart';
import '../all.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  static String routeName = '/';
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _onFloatingButtonPress(BuildContext context) {
    context.read<ImageStageModel>().reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          TextButton.icon(
            style: TextButton.styleFrom(primary: Colors.white),
            onPressed: () =>
                Navigator.pushNamed(context, FavoritesPage.routeName),
            icon: Icon(Icons.favorite_border),
            label: Text(FavoritesPage.tiileName),
          ),
        ],
      ),
      body: ImageGrid(),
      drawer: HomeDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFloatingButtonPress(context),
        child: const Icon(Icons.refresh_outlined),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
