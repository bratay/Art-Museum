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
                  onTap: () => null,
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
}
