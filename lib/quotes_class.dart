import 'dart:convert';

import 'package:http/http.dart';

class Quote {
  String quoteBody;
  String quoteAuthor;

  Quote(Map quoteMap) {
    this.quoteAuthor = quoteMap['quote']['author'];
    this.quoteBody = quoteMap['quote']['body'];
  }
}

class QuotesList {
  List<Map> listOfQuotes = [];

  fetchQuotes() async {
    Response response = await get('https://favqs.com/api/qotd');
    if (response.statusCode == 200) {
      print("response 200");
    }
    Map<String, dynamic> aQuoteMap = jsonDecode(response.body);
    listOfQuotes.add(aQuoteMap);
  }
}
