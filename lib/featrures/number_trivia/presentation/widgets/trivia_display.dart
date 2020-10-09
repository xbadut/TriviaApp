import 'package:flutter/material.dart';
import 'package:trivia/featrures/number_trivia/domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({
    Key key,
    this.numberTrivia,
  })  : assert(numberTrivia != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(children: <Widget>[
        Text(
          numberTrivia.number.toString(),
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
            child: Center(
          child: SingleChildScrollView(
            child: Text(
              numberTrivia.text,
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ))
      ]),
    );
  }
}