import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyProvider extends ChangeNotifier {
  String _url = "";
  String _quoteText = "";
  String _quoteAuthor = "";

  int _lang = 1;

  MyProvider() {
    setUrl();
  }
  void setLang(int lang) {
    _lang = lang;
    setUrl();
  }

  void setUrl() {
    if (_lang == 0) {
      _url = 'https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en';
    } else {
    _url = 'https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=ru';
    }
  }

  String getUrl() {
    return _url;
  }

  int getLang() {
    return _lang;
  }

  String getQuoteText() {
    return _quoteText;
  }

  String getQuoteAuthor() {
    return _quoteAuthor;
  }

  void setQuoteText(String quoteText) {
    quoteText = _quoteText;
  }

  void setQuoteAuthor(String quoteAuthor) {
    quoteAuthor = _quoteAuthor;
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vegas Forismatic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHttpApp(),
    );
  }
}

class MyHttpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Forismatic'),
          actions: <Widget>[IconButton(icon: Icon(Icons.exit_to_app), tooltip: 'Exit', onPressed: (){
            exit(0);
          })],
        ),
        body: TestHttp()
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class TestHttp extends StatefulWidget {

  TestHttp();

  @override
  State<StatefulWidget> createState() => TestHttpState();
}

class TestHttpState extends State<TestHttp> {

  int _lang = 1;

  String _url = "";
  String _erorr = "";
  String _quoteText = "";
  String _quoteAuthor = "";

  int _status = 0;

  _sendRequestGet() {

    final uri = Uri.parse(_url);

    print("_url ${_url}");

    http.get(uri).then((response){
      _status = response.statusCode;

      print(utf8.decode(response.bodyBytes));

      var forismatic =  Forismatic.fromJson(json.decode(utf8.decode(response.bodyBytes)));

      setState(() {
        _quoteText = forismatic.quoteText;
        _quoteAuthor = forismatic.quoteAuthor;
      });

    }).catchError((error){

      setState(() {
        _status = -1;
        _erorr = error.toString();
      });//reBuildWidget
    });

  }//_sendRequestGet

  void setUrl() {
    if (_lang == 0) {
      _url = 'https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en';
    } else {
      _url = 'https://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=ru';
    }
  }

  @override
  void initState() {
    setUrl();
    super.initState();
  }//initState

  @override
  Widget build(BuildContext context) {

    if (_status == 0) {
      return Column(
        children: <Widget>[

          Container(
              child: Text('URL', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
              padding: EdgeInsets.all(10.0)
          ),
          Text(_url),

          Row(
            children: <Widget>[
              Expanded( child:
                RadioListTile(
                  title: const Text('Eng'),
                  value: 0,
                  groupValue: _lang,
                  onChanged: (int? value) {
                    setState(() {
                      _lang = value!;
                    });
                    setUrl();
                  },
                ),
              ),
              Expanded( child:
                RadioListTile(
                  title: const Text('Rus'),
                  value: 1,
                  groupValue: _lang,
                  onChanged: (int? value) {
                    setState(() {
                      _lang = value!;
                    });
                    setUrl();
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20.0),
          ElevatedButton(child: Text('Send request GET'), onPressed: () {
            _sendRequestGet();
          }//_sendRequestGet
          ),

        ],
      );
    } else  if (_status == -1) {
      return Column(
        children: <Widget>[

          Container(
              child: Text('URL', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
              padding: EdgeInsets.all(10.0)
          ),
          Text(_url),

          Row(
            children: <Widget>[
              Expanded(
                child: RadioListTile(
                  title: const Text('Eng'),
                  value: 0,
                  groupValue: _lang,
                  onChanged: (int? value) {
                    setState(() {
                      _lang = value!;
                    });
                    setUrl();
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: const Text('Rus'),
                  value: 1,
                  groupValue: _lang,
                  onChanged: (int? value) {
                    setState(() {
                      _lang = value!;
                    });
                    setUrl();
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20.0),
          ElevatedButton(child: Text('Send request GET'), onPressed: _sendRequestGet),

          SizedBox(height: 20.0),
          Text('Error', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
          Text(_erorr == null ? '' : _erorr),

        ],
      );
    } else {
      return Column(
        children: <Widget>[

          Container(
              child: Text('URL', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
              padding: EdgeInsets.all(10.0)
          ),
          Text(_url),

          Row(
            children: <Widget>[
              Expanded(
                child: RadioListTile(
                  title: const Text('Eng'),
                  value: 0,
                  groupValue: _lang,
                  onChanged: (int? value) {
                    setState(() {
                      _lang = value!;
                    });
                    setUrl();
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: const Text('Rus'),
                  value: 1,
                  groupValue: _lang,
                  onChanged: (int? value) {
                    setState(() {
                      _lang = value!;
                    });
                    setUrl();
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20.0),
          ElevatedButton(child: Text('Send request GET'), onPressed: _sendRequestGet),

          SizedBox(height: 20.0),
          Text('Forismatic', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
          Text(_quoteText == null ? '' : _quoteText),
          Text('Author', style: TextStyle(fontSize: 20.0,color: Colors.blue)),
          Text(_quoteAuthor == null ? '' : _quoteAuthor),

        ],
      );
      }

  }//build
}//TestHttpState


class Forismatic {

  String quoteText = "";
  String quoteAuthor = "";
  String senderLink = "";
  String quoteLink = "";

  Forismatic({required this.quoteText, required this.quoteAuthor, required this.senderLink, required this.quoteLink});

  factory Forismatic.fromJson(Map<String, dynamic> json) {
    return Forismatic(
      quoteText: json['quoteText'],
      quoteAuthor: json['quoteAuthor'],
      senderLink: json['senderLink'],
      quoteLink: json['quoteLink'],
    );
  }
}
