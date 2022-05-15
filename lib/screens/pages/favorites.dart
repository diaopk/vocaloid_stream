// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocaloid_stream/screens/all.dart';
import '../../models/all.dart';

class FavoritesPage extends StatelessWidget {
  static String routeName = '/favorites';
  static String tiileName = 'My favs';

  Widget _getFutureFavorites(
      BuildContext context, AsyncSnapshot<List<VocalImage>> snapshot) {
    if (snapshot.hasData) {
      return GridView.count(
        crossAxisCount: 2,
        children: _favChild(context, snapshot.data),
      );
    } else if (snapshot.hasError) {
      print('favPage - build - err: ${snapshot.error}');
      return Center(child: Text('Please try again later'));
    } else {
      return Center(child: Text('Find your favorites'));
    }
  }

  List<Widget> _favChild(BuildContext context, List<VocalImage> vocalImages) {
    return vocalImages.asMap().entries.map((map) {
      return Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        clipBehavior: Clip.antiAlias,
        child: ImageSection(
          map.value,
          true,
          vocalImages: vocalImages,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My favs')),
      body: Consumer<Favorites>(
        builder: (context, value, child) => FutureBuilder(
          future: value.items,
          builder: _getFutureFavorites,
        ),
      ),
    );
  }
}

class FavoriteItemTile extends StatelessWidget {
  final VocalImage vocalImage;

  const FavoriteItemTile(this.vocalImage);

  _onTap(BuildContext context) {
    Navigator.pushNamed(context, ImageDetail.routeName, arguments: vocalImage);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: GestureDetector(
            onTap: () => _onTap(context),
            child: CircleAvatar(
              backgroundImage:
                  this.vocalImage.network != null && this.vocalImage.network
                      ? NetworkImage(this.vocalImage.url)
                      : AssetImage(this.vocalImage.url),
            )),
        trailing: IconButton(
          key: Key('remove_icon_${this.vocalImage.index}'),
          icon: Icon(Icons.close),
          onPressed: () {
            Provider.of<Favorites>(context, listen: false)
                .remove(this.vocalImage);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed from favorites.'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}
