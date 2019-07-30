import 'package:flutter/material.dart';
import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.teal[50]),
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
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Text('The Art Museum'),
        backgroundColor: Colors.teal[50],
      ),
      body: Column(
        children: [
          Expanded(child: worksOfArt()),
          RaisedButton(
            child: Text('Load more Artwork'),
            onPressed: () async {
              final images = await requestImages();
              setState(() => picData.addAll(images));
            },
            color: Colors.white,
            splashColor: Colors.brown,
          )
        ],
      ),
    );
  }

  Widget worksOfArt() {
    final deviceSize = MediaQuery.of(context).size;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: (picData == null) ? 0 : picData.length,
      itemBuilder: (context, index) {
        var data = picData[index];
        var imageData = picData[index].images[0];
        var height, width;
        if (imageData.height / 3 > deviceSize.height - 245) {
          height = deviceSize.height / 1.5;
          var scaleRatio = (deviceSize.height / 1.5) / imageData.height;
          width = imageData.width * scaleRatio;
        } else {
          height = imageData.height / 3;
          width = imageData.width / 3;
        }
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: InkWell(
                  onTap: () => routeToInfo(data),
                  child: Hero(
                    tag: data.primaryImageUrl,
                    child: FadeInImage.assetNetwork(
                      height: height,
                      width: width,
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
                      spreadRadius: 3,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.brown,
                    width: 10.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void routeToInfo(ObjectInfo picData) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ObjectInfoScreen(picData)),
      );
    });
  }
}

class ObjectInfoScreen extends StatelessWidget {
  final ObjectInfo picData;

  ObjectInfoScreen(this.picData);

  @override
  Widget build(BuildContext context) {
    final imageData = picData.images[0];
    final artistData = picData.people[0];
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Text('Artwork Information'),
        backgroundColor: Colors.teal[50],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
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
                              picData.title + '( ${picData.date})',
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
                            Text(artistData.name + '( ${artistData.lifeSpan})',
                                style: TextStyle(fontSize: 17)),
                          ],
                        ),
                      if (picData.people != null)
                        WrapInfo(artistData.culture, 12),
                      WrapInfo(picData.caption, 12),
                      WrapInfo(picData.description, 12),
                      Wrap(
                        children: [
                          ChipInfo(picData.technique),
                          ChipInfo(picData.medium),
                          ChipInfo(picData.classification),
                          if (imageData.width != null &&
                              imageData.height != null)
                            ChipInfo(
                                '${imageData.width} x ${imageData.height}'),
                        ],
                      ),
                      WrapInfo(picData.copyright, 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
