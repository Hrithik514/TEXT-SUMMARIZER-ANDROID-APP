import 'package:flutter/material.dart';

class nextpage extends StatelessWidget {
  String summ;

  // Constructor to get the data from the previous page.
  nextpage({required this.summ});

  /*@override
  Widget build(BuildContext context) {
    // To listen to the changes in the textfield.
    TextEditingController _name = TextEditingController(text: summ);

    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextField(
                // To set the appropriate controller
                // to the text field.
                controller: _name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YOUR SUMMARIZED TEXT")),
      body: Center(
        child: Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.greenAccent[100],
          child: SizedBox(
            width: 370,
            height: 500,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //CircleAvatar
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  SelectableText(
                    summ,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w500,
                    ), //Textstyle
                  ), //Text
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  //Text
                  const SizedBox(
                    height: 10,
                  ), //SizedBox
                  SizedBox(
                    width: 100,
                  ) //SizedBox
                ],
              ), //Column
            ), //Padding
          ), //SizedBox
        ), //Card
      ),
    );
  }
  /* @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Container(
            //color: Colors.green[200],
            child: const Text(' YOUR SUMMARIZED TEXT',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            //color: Colors.green[200],
            child: Center(child: Text(summ)),
          ),
        ],
      ),
    );
  }*/
}
