import 'package:flutter/material.dart';
import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
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
                    onTap: () => null,
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
}
