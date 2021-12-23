// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

//o app se torna um widget extendendo StatelessWidget
class MyApp extends StatelessWidget { 
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return const MaterialApp(
        title: 'Startup Name Generator',
        home: RandomWords(),
      );
  }
}//ok

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
      if (i.isOdd) return const Divider(); /*2*/
        final index = i ~/ 2; /*3*/
      if (index >= _suggestions.length) {
        _suggestions.addAll(generateWordPairs().take(10)); /*4*/
        }
      return _buildRow(_suggestions[index]);
        });  
      } 

      Widget _buildRow(WordPair pair) {
      final alreadySaved = _saved.contains(pair);
      return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
          semanticLabel : alreadySaved ? 'Remove from saved' : 'Save',
        ),
        onTap: (){
          setState(() {
            if (alreadySaved){
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },  
      );
    }

  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(icon: const Icon(Icons.list),
          onPressed: _pushSaved,
          tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: _buildSuggestions(),
      );
    }

    void _pushSaved(){
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) {
            final tiles = _saved.map(
              (pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );
            final divided = tiles.isNotEmpty ? ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList() : <Widget>[];

            return Scaffold(
              appBar: AppBar(
                title: const Text('Saved Suggestions'),
              ),
              body: ListView(children: divided),
            );
          },
        ),
      );
    }
    
  }
  class RandomWords extends StatefulWidget {
    const RandomWords({Key? key}) : super(key: key);

    @override
    State<RandomWords> createState() => _RandomWordsState();
  }



