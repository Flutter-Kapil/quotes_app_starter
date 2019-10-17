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

  bool fetchingQuotes = false;

  String defaultQ = "Fething Quotes";
  String defaultA = "You are awesome";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchQuotes();
    initialQuote();
  }

  void initialQuote() async {
    print('entered initialQuote function');
    fetchingQuotes = true;
    Map initialMap = await fetchQuotes();
    print('initialMap obtained');
    fetchingQuotes = false;
    defaultA = initialMap['quote']['author'];
    defaultQ = initialMap['quote']['body'];
    print(' initial auth $defaultA');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    defaultQ,
                    style: TextStyle(
                        fontSize: 21, fontFamily: 'HeptaSlab-Regular'),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  defaultA,
                  style: TextStyle(
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                      fontSize: 16),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: fetchingQuotes
                        ? CircularProgressIndicator(
                            strokeWidth: 3.0,
                            backgroundColor: Colors.red,
                          )
                        : Icon(
                            Icons.arrow_forward,
                            color: Colors.red,
                            size: 21,
                          ),
                    onPressed: () async {
                      fetchingQuotes = true;
                      setState(() {});
                      Map qMap = await fetchQuotes();

                      defaultA = qMap['quote']['author'];
                      defaultQ = qMap['quote']['body'];
                      fetchingQuotes = false;
                      setState(() {});
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
