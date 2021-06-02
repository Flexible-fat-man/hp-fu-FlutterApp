import 'package:flutter/material.dart';
import '../components/card/FmCard.dart';

void main() => App();

class App extends StatelessWidget {
  @override
  Widget build(Object context) {
    return Column(children: [
      FmCard(
        header: Text('header'),
        body: Text('body'),
        footer: Text('footer'),
      )
    ]);
  }
}
