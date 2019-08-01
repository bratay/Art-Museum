import 'dart:convert';
import 'dart:io';

Future<List<ObjectInfo>> requestImages() async {
  try {
    Uri apiUri = Uri.parse(
        'https://api.harvardartmuseums.org/object?sort=random&apikey=b1e1f600-aa67-11e9-adb9-2fdc07e84b9c');

    HttpClientRequest request = await HttpClient().getUrl(apiUri);
    HttpClientResponse response = await request.close();

    Stream resStream = response.transform(utf8.decoder);
    var result = '';
    await for (var data in resStream) {
      result += data as String;
    }

    List<ObjectInfo> output =
    MuseumResponse.fromJson(json.decode(result) as Map<String, dynamic>)
        .records
        .where((r) => r.primaryImageUrl != null)
        .toList();

    return output;
  } catch (e) {
    print(e.toString());
    return null;
  }
}

class MuseumResponse {
  List<ObjectInfo> records;

  MuseumResponse.fromJson(Map<String, dynamic> map) {
    this.records = (map['records'] as List).map((r) {
      return ObjectInfo.fromJson(r as Map<String, dynamic>);
    }).toList();
  }
}

class ObjectInfo {
  String primaryImageUrl, copyright, description, date, title;
  String style, century, classification, medium, technique, caption;
  List<ImageInfo> images;
  List<PersonInfo> people;

  ObjectInfo.fromJson(Map<String, dynamic> map) {
    this.primaryImageUrl = map['primaryimageurl'] as String;
    this.date = map['dated'] as String;
    this.title = map['title'] as String;
    this.description = map['description'] as String;
    this.style = map['style'] as String;
    this.century = map['century'] as String;
    this.classification = map['classification'] as String;
    this.medium = map['medium'] as String;
    this.technique = map['technique'] as String;
    this.copyright = (map['copyright'] ?? 'No Copyright') as String;
    this.caption = map['caption'] as String;
    this.images = (map['images'] as List<dynamic>)
        ?.map((h) => ImageInfo.fromJson(h as Map<String, dynamic>))
        ?.toList();
    this.people = (map['people'] as List<dynamic>)
        ?.map((h) => PersonInfo.fromJson(h as Map<String, dynamic>))
        ?.toList();
  }
}

class ImageInfo {
  String baseImageUrl;
  int width, height;

  ImageInfo.fromJson(Map<String, dynamic> map) {
    this.baseImageUrl = map['baseimageurl'] as String;
    this.width = map['width'] as int;
    this.height = map['height'] as int;
  }
}

class PersonInfo {
  String name, role, lifeSpan, gender, birthPlace, deathPlace, culture;

  PersonInfo.fromJson(Map<String, dynamic> map) {
    this.name = map['displayname'] as String;
    this.role = map['role'] as String;
    this.lifeSpan = map['displaydate'] as String;
    this.culture = map['culture'] as String;
  }
}

//API  key = b1e1f600-aa67-11e9-adb9-2fdc07e84b9c

//test request for a image from harvard = https://api.harvardartmuseums.org/image/465905?apikey=b1e1f600-aa67-11e9-adb9-2fdc07e84b9c
