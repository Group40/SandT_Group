import 'package:flutter/material.dart';
import 'package:sandtgroup/ArticleHandling/ArticleHandling.dart';
import 'package:http/http.dart' as http;
import 'package:sandtgroup/ArticleHandling/Singlearticle.dart';
import 'dart:async';
import 'dart:convert';
import 'package:sandtgroup/FirstScreen/Splash.dart';





class ArticleHome extends StatefulWidget {
  @override
  _ArticleHomeState createState() => _ArticleHomeState();
}

class _ArticleHomeState extends State<ArticleHome> {
  //  EventByDateState(String date);

  List data;

  Future<String> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(getUrl() + "/getAllarticle"),
        headers: {"Accept": "application/json"});
    this.setState(() {
      data = jsonDecode(response.body);
    });
    return "success!";
  }
   @override
  void initState() {
    this.getData();
  }
  @override
  Widget build(BuildContext context) {
    print(data);
   // print("Fucks");
    
    return Scaffold(
    appBar: AppBar(
        title: Text("Article"),
      ),
       floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
             Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ArticleHandling()),
                  );
         
        },
        label: Text('Add'),
        icon: Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
         body: (data == null)
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              )
            : Container(
                margin: const EdgeInsets.only(top: 20.0),
                child:
                    ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, int position) {
        int availableInt = 2;
        return Container(
          child: Card(
        
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35.0),
            ),
            color: Theme.of(context).accentColor,
            elevation: 1.0,
            child: ListTile(
              
              leading: CircleAvatar(
                backgroundColor: availableInt == 0
                    ? Colors.red
                    : Theme.of(context).primaryColor,
                child: availableInt == 0
                    ? Icon(
                        Icons.event_busy,
                        color: Colors.black,
                      )
                    : Icon(
                        Icons.event_available,
                        color: Colors.black,
                      ),
              ),
              title: Text(data[position]["articleTitle"],
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              subtitle: Text(data[position]["description"],
                  style: TextStyle(color: Colors.black54),maxLines: 1,),
              onTap: () {
             
                 Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Singlearticle(data: data[position],)));
              },
            ),
          ),
        );
      },
    )
                    //  Center(child: Text(data[0]['articleTitle']),)
                
              ));
    
      
  
  }
}