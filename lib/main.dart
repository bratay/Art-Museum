import 'package:flutter/material.dart';
import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.teal[50],
        scaffoldBackgroundColor: Colors.teal[100],
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ObjectInfo> picData;

  void initState() {
    super.initState();
    requestImages().then((images) {
      setState(() => picData = images);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Art Museum'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: worksOfArt()),
          ],
        ),
      ),
    );
  }

  Widget worksOfArt() {
    final deviceSize = MediaQuery.of(context).size;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: (picData == null) ? 0 : picData.length + 1,
      itemBuilder: (context, index) {
        if (index == picData.length)
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 70.0, left: 50.0),
                child: RaisedButton(
                  child: Text('More'),
                  shape: StadiumBorder(),
                  elevation: 15,
                  onPressed: () async {
                    final images = await requestImages();
                    setState(() => picData.addAll(images));
                  },
                  color: Colors.white,
                  splashColor: Colors.brown,
                ),
              ),
            ],
          );
        var data = picData[index];
        var height = deviceSize.height * .7;
        var width = deviceSize.width * .9;

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: height,
                  maxWidth: width,
                  minHeight: deviceSize.height * .2,
                  minWidth: deviceSize.width * .3,
                ),
                child: Container(
                  child: GestureDetector(
                    onTap: () => _routeToInfo(data),
                    child: Hero(
                      tag: data.primaryImageUrl,
                      child: FadeInImage.assetNetwork(
                        fadeInDuration: const Duration(milliseconds: 500),
                        placeholder: 'assets/flutterLogo.jpg',
                        placeholderScale: 4,
                        image: data.primaryImageUrl,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 10.0,
                        spreadRadius: 3.0,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.brown,
                      width: 10.0,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                width: width,
                child: Center(
                  child: Text(data.title),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _routeToInfo(ObjectInfo picData) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ArtworkInfoScreen(picData)),
      );
    });
  }
}

class ArtworkInfoScreen extends StatelessWidget {
  final ObjectInfo picData;

  ArtworkInfoScreen(this.picData);

  @override
  Widget build(BuildContext context) {
    final imageData = (picData.images == null) ? null : picData.images[0];
    final artistData = (picData.people == null) ? null : picData.people[0];
    return Scaffold(
      appBar: AppBar(
        title: Text('Artwork Information'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                children: <Widget>[
                  Hero(
                    tag: picData.primaryImageUrl,
                    child: Image.network(picData.primaryImageUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          '${picData.title} (${picData.date})',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'Raleway'),
                        ),
                      ],
                    ),
                  ),
                  if (picData.people != null && artistData.role == 'Artist')
                    Wrap(
                      children: [
                        Text('${artistData.name} (${artistData.lifeSpan})',
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  if (picData.people != null) WrapInfo(artistData.culture, 12),
                  WrapInfo(picData.caption, 12),
                  WrapInfo(picData.description, 12),
                  Wrap(
                    children: [
                      ChipInfo(picData.technique),
                      ChipInfo(picData.medium),
                      ChipInfo(picData.classification),
                      if (imageData.width != null && imageData.height != null)
                        ChipInfo('${imageData.width} x ${imageData.height}'),
                    ],
                  ),
                  WrapInfo(picData.copyright, 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChipInfo extends StatelessWidget {
  final String text;

  ChipInfo(this.text);

  @override
  Widget build(BuildContext context) {
    if (text == null) return Padding(padding: EdgeInsets.all(0.0));
    return Padding(
      padding: const EdgeInsets.only(right: 2.0, left: 2.0),
      child: Chip(
        label: Text(
          text,
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

class WrapInfo extends StatelessWidget {
  final String text;
  final double size;

  WrapInfo(this.text, this.size);

  @override
  Widget build(BuildContext context) {
    if (text == null) return Padding(padding: EdgeInsets.all(0.0));
    return Padding(
      padding: const EdgeInsets.only(right: 2.0, left: 2.0),
      child: Wrap(
        children: [Text(text, style: TextStyle(fontSize: size))],
      ),
    );
  }
}
