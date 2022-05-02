import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocaloid_stream/models/all.dart';
import 'package:vocaloid_stream/models/favorites.dart';
import './screens/all.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Favorites()),
        ChangeNotifierProvider(create: (_) => ImageStageModel())
      ],
      child: MaterialApp(
        title: 'Hololive EN',
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        routes: {
          HomePage.routeName: (context) => HomePage(title: 'Hololive Home'),
          FavoritesPage.routeName: (context) => FavoritesPage(),
          ImageDetail.routeName: (context) => ImageDetail(),
          ImageStage.routeName: (_) => ImageStage(),
        },
      ),
    );
  }
}
