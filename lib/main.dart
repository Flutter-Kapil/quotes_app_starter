import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuotesScreen(),
  ));
}

class QuotesScreen extends StatefulWidget {
  @override
  _QuotesScreenState createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen>
    with SingleTickerProviderStateMixin {
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

  bool usingDarkTheme = false;
  bool usingAnimation = true;
  List<bool> toggleButtons = [true, false, false];
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    _animation =
        Tween(begin: usingAnimation ? 0.2 : 1.0, end: 1.0).animate(_controller);
    CurvedAnimation _smoothAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    _controller.forward();
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
//    _controller.reverse();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: usingDarkTheme ? Brightness.dark : Brightness.light,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.black26)),
      home: Scaffold(
        drawer: Container(
          color: usingDarkTheme ? Colors.black : Colors.grey,
          height: double.infinity,
          width: MediaQuery.of(context).size.width * 0.45,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black26)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Dark Theme'),
                    Switch(
                      value: usingDarkTheme,
                      onChanged: (value) {
                        value = !usingDarkTheme;
                        usingDarkTheme = !usingDarkTheme;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black26)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Animation'),
                    Switch(
                      value: usingAnimation,
                      onChanged: (value2) {
//                      print(value);

                        usingAnimation = !usingAnimation;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
              ToggleButtons(
                highlightColor: Colors.orange,
                onPressed: (int x) {
                  for (int index = 0; index < toggleButtons.length; index++) {
                    if (index != x)
                      toggleButtons[index] = false;
                    else
                      toggleButtons[index] = true;
                  }
                  setState(() {});
                },
                isSelected: toggleButtons,
                children: <Widget>[
                  Text('1'),
                  Text('2'),
                  Text('3'),
                ],
              ),
            ],
          ),
        ),
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
                  child: FadeTransition(
                    opacity: _animation,
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
                ),
                Expanded(
                  flex: 1,
                  child: FadeTransition(
                    opacity: _animation,
                    child: Text(
                      defaultA,
                      style: TextStyle(
                          color: Colors.red,
                          fontStyle: FontStyle.italic,
                          fontSize: 16),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: FloatingActionButton(
                      backgroundColor:
                          usingDarkTheme ? Colors.black : Colors.white,
                      child: fetchingQuotes && usingAnimation
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
                        usingAnimation ? _controller.reverse() : null;
                        setState(() {});
                        Map qMap = await fetchQuotes();
                        defaultA = qMap['quote']['author'];
                        defaultQ = qMap['quote']['body'];
//                        _controller.forward();
                        usingAnimation ? _controller.forward() : null;
                        fetchingQuotes = false;
//                        _controller.forward();
                        setState(() {});
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
