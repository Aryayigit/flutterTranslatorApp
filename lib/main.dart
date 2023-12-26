import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:http/http.dart' as http;

//git vers
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        home: const MainPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String translated = '';
  String hretranslated = '';
  String storageText = ""; //kaydedilenlerin gösterilmesi için üçüncü kutu

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: const Icon(Icons.translate),
          title: const Text('Translation'),
        ),
        body: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(12),
          color: Colors.white12,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('English (US)'),
              const SizedBox(height: 8),
              TextField(
                autofocus: true,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: 'Enter text',
                ),
                onChanged: (text) async {
                  const apiKey = 'AIzaSyAb3rd5b-l-oTlHoxtJ3vYAKKis2UqXl3c ';
                  const to = 'tr';
                  final url = Uri.parse(
                    'https://translation.googleapis.com/language/translate/v2'
                    '?q=$text&target=$to&key=$apiKey',
                  );
                  final response = await http.post(url);

                  if (response.statusCode == 200) {
                    final body = json.decode(response.body);
                    final translations = body['data']['translations'] as List;
                    final translation = HtmlUnescape().convert(
                      translations.first['translatedText'],
                    );

                    setState(() {
                      translated = translation;
                      hretranslated = text;
                    });
                  }
                },
              ),
              const Divider(height: 32),
              const Text(
                'Türkçe',
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
              const SizedBox(height: 8),
              Text(
                translated,
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                storageText,
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
/*                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
 */
                children: [
                  ElevatedButton(
                    onPressed: () {
                      saveToStorage(hretranslated);
                    },
                    child: Text(
                      "Save storageText",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      getFromStorage();
                    },
                    child: Text(
                      "Show StorageText",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  Future<void> saveToStorage(String storageText) async {
    //final prefs = await SharedPreferences.getInstance();
    print(storageText);
    // prefs.setString('storageText', storageText);
  }

  Future<void> getFromStorage() async {
    //final prefs = await SharedPreferences.getInstance();
/* 
    setState(() {
      //storageText = prefs.getString('storageText') ?? "storageText not found";
    }); */
  }
}
