import 'package:flutter/material.dart';
import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        primaryColorDark: Colors.blueGrey,
        primaryColorLight: Colors.blueAccent,
        backgroundColor: Colors.grey[500],
        buttonColor: Colors.white,
        splashColor: Colors.orangeAccent,
        cardColor: Colors.grey[300],
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(
              fontSize: 36.0,
              fontStyle: FontStyle.italic,
              fontFamily: 'Raleway'),
          body1: TextStyle(fontSize: 15.0, fontFamily: 'Hind'),
        ),
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
      backgroundColor: Theme.of(context).backgroundColor, //Colors.grey[500],
      appBar: AppBar(
        title: Text('The Harvard Art Museums'),
        backgroundColor: Theme.of(context).primaryColorDark, //Colors.blueGrey,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: worksOfArt()),
            RaisedButton(
              child: Text('Load more images'),
              onPressed: () async {
                final images = await requestImages();
                setState(() => picData.addAll(images));
              },
              color: Theme.of(context).buttonColor, //Colors.white,
              splashColor: Theme.of(context).splashColor, //Colors.orangeAccent
            )
          ],
        ),
      ),
    );
  }

  Widget worksOfArt() {
    return ListView.builder(
      itemCount: (picData == null) ? 0 : picData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                child: InkWell(
                  onTap: () => routeToInfo(picData[index]),
                  child: Hero(
                    tag: picData[index].primaryImageUrl,
                    child: FadeInImage.assetNetwork(
                      height: 400,
                      width: 400,
                      fadeInDuration: const Duration(milliseconds: 500),
                      placeholder: 'assets/marble.jpg',
                      image: picData[index].primaryImageUrl,
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
                    color:
                        Theme.of(context).primaryColorDark, // Colors.blueGrey,
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor, //Colors.grey[500],
      appBar: AppBar(
        title: Text('Information'),
        backgroundColor: Theme.of(context).primaryColorDark, //Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Hero(
                    tag: picData.primaryImageUrl,
                    child: Image.network(picData.primaryImageUrl),
                  ),
                  InfoCard('Title:', picData.title),
                  InfoCard('Caption:', picData.caption),
                  InfoCard('Description:', picData.description),
                  InfoCard('Medium:', picData.medium),
                  InfoCard('Date:', picData.date),
                  InfoCard('Century:', picData.century),
                  InfoCard('Technique:', picData.technique),
                  InfoCard('Style:', picData.style),
                  InfoCard('Classification:', picData.classification),
                  if (picData.images[0].width != null &&
                      picData.images[0].height != null)
                    InfoCard('Dimensions:',
                        '${picData.images[0].width} x ${picData.images[0].height}'),
                  InfoCard('Copyright:', picData.copyright),
                  if (picData.people != null &&
                      picData.people[0].role == 'Artist')
                    ArtistInfo(picData.people[0]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArtistInfo extends StatelessWidget {
  final PersonInfo artist;

  ArtistInfo(this.artist);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('The Artist', style: Theme.of(context).textTheme.title),
          ),
          InfoCard('Name:', artist.name),
          if (artist.gender != 'unknown') InfoCard('Gender:', artist.gender),
          InfoCard('Culture:', artist.culture),
          if (artist.birthPlace != 'Unknown')
            InfoCard('Birthplace:', artist.birthPlace),
          if (artist.deathPlace != 'Unknown')
            InfoCard('Deathplace:', artist.deathPlace),
          InfoCard('Life Span:', artist.lifeSpan),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String leading;
  final String title;

  InfoCard(this.leading, this.title);

  @override
  Widget build(BuildContext context) {
    if (title == null) return Container();
    return Card(
      child: ListTile(
        leading: Text(leading),
        title: Text(
          title,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      color: Theme.of(context).cardColor, //Colors.grey[300]
    );
  }
}
