import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: QuotesScreen(),
  ));
}

class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  //fetch quotes function
  Future<Map> fetchQuotes() async {
    Response response = await get('https://favqs.com/api/qotd');
    if (response.statusCode == 200) {
      print("response 200");
    }
    Map<String, dynamic> aQuoteMap = jsonDecode(response.body);
    print(aQuoteMap['quote']['author']);
    return aQuoteMap;
  }

  String defaultQ = "Quote HERE";
  String defaultA = "Author HERE";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                defaultQ,
                style: TextStyle(fontSize: 21, fontFamily: 'HeptaSlab-Regular'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                defaultA,
                style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                    fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.red,
                ),
                onPressed: () async {
                  Map qMap = await fetchQuotes();
                  print(qMap['quote']['body']);
                  defaultA = qMap['quote']['author'];
                  defaultQ = qMap['quote']['body'];
                  setState(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
