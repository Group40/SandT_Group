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
      appBar: AppBar(
        title: Text("Single artcile"),
      ),
      body: Center(
        child: Column(
          children: [
             SizedBox(
              height: 10,
            ),
            Text(widget.data['articleTitle'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 10,
            ),
            Container(
                   margin: const EdgeInsets.all(30.0),
    padding: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent),borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  widget.data['description'],
                  style: TextStyle(color: Colors.grey, height: 1.5),
                )),
              
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                        Text("By : - ",style: TextStyle( fontWeight: FontWeight.bold),),
                         Text(widget.data['articleWriter_name'],style: TextStyle( fontWeight: FontWeight.bold))
                ],),
              )
          ],
        ),
      ),
    );
  }
}
