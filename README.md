# Art-Museum
 An Android and IOS Flutter application to display artwork from the [Harvard Art Museums](https://www.harvardartmuseums.org) 
 
 ## Goals
 
 * Display artwork gathered from the Harvard Art Museums [API](https://github.com/harvardartmuseums/api-docs).
 * Show how to make a HTTP request and parse a JSON string from an API in dart. 
 * Demonstrate the uses for basic UI  widgets.
 * Showcase the ease of use and practicality of Flutter.
 
 ## The important bits
 
 ### `main.dart`
 
Shows an unlimited amount of artwork in brown frames with the title underneath.  The art is 
chosen at random and when pressed displays a second screen showing more information about the
art and the artist if avaiable from the API.  
 
 ### `data.dart`
 
The backend for getting data from the Harvard Art Museums [API](https://github.com/harvardartmuseums/api-docs).  Makes HTTP request then parses
the JSON string into usable objects to display in `main.dart`  
 
 ## Questions/issues
 
 If you have a general question about any of the techniques you see in
 the sample, the best places to go are:
 
 * [The FlutterDev Google Group](https://groups.google.com/forum/#!forum/flutter-dev)
 * [The Flutter Gitter channel](https://gitter.im/flutter/flutter)
 * [StackOverflow](https://stackoverflow.com/questions/tagged/flutter)
 * [Flutter Homepage](https://flutter.dev)
