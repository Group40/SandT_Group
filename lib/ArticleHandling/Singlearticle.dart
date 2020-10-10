import 'package:flutter/material.dart';



class Singlearticle extends StatefulWidget {
  var data;

  Singlearticle({this.data});
  @override
  _SinglearticleState createState() => _SinglearticleState();
}

class _SinglearticleState extends State<Singlearticle> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      appBar: AppBar(title: Text(widget.data['articleTitle']),),
      body: 
       

        Center(
        child: Column(
          children: [
             Icon(
               
              Icons.dock,
              size: 25,
              color: Colors.black,
            ),
            Text(widget.data['description'],style: TextStyle(fontSize: 25),),
          ],
        ),
        )
      ,

      
    );
  }
}