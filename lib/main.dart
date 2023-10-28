import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          
          title: const Text("App"),
          leading: const Icon(Icons.menu, color: Colors.black87),
          elevation: 0,
          

        ),
        body: MyHomePage(),
      ),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }
 
  
  @override
  Widget build(BuildContext context) {
    
   return Scaffold(
    body: Center(
      child: FutureBuilder<List<Album>>(
        future: futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final phooto = snapshot.data![index];
                return ListTile(
                  leading: Image.network(phooto.thumbnailUrl),
                  title: Text(phooto.title),
                  
                );
              },
            );
          } else if(snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return const CircularProgressIndicator();
        },
        
      ),
    ),
   );
  }
}


Future<List<Album>> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final jsonList = jsonDecode(response.body) as List;
    return jsonList.map((json) => Album.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final int albumId;
  final int id;
  final String title;
  final String thumbnailUrl;

  const Album({
    required this.albumId,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

























Widget buttonSection =  Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    _buildButtonColumn(Colors.blue, Icons.call, "CALL"),
    _buildButtonColumn(Colors.blue, Icons.message, "MESSAGE"),
    _buildButtonColumn(Colors.blue, Icons.share, "SHARE")

  ],
);

Widget textSection = Container(
  padding: const EdgeInsets.all(32),
  child: const Text(
    'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
    'Alps. Situated 1,578 meters above sea level, it is one of the '
    'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
    'half-hour walk through pastures and pine forest, leads you to the '
    'lake, which warms to 20 degrees Celsius in the summer. Activities '
    'enjoyed here include rowing, and riding the summer toboggan run.',
    softWrap: true,
  ),
);

Column _buildButtonColumn(Color color, IconData icon, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: color),
      Container(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: color)),
      )
    ],
  );
}