
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CharNode{
  bool isWord = false;
  Map<String, CharNode> children = {};

  feed(List<String> list) => list.forEach((e) => insert(e));

  insert(String word){
    CharNode node = this;
    for(int i = 0; i < word.length; i++){
      final char = word[i];
      if(!node.children.containsKey(char)){
        node.children[char] = CharNode();
      }
      node = node.children[char]!;
    }
    node.isWord = true;
  }

  bool find(word){
    CharNode node = this;
    for (int i = 0; i < word.length; i++){
      final char = word[i];
      if (node.children.containsKey(char)){
        node = node.children[char]!;
      }else{
        return false;
      }
    }
    return node.isWord;
  }

  List<String> autoComplete(word){
    List<String> words = <String>[];
    CharNode node = this;
    for (int i=0; i < word.length; i++){
      final char = word[i];
      if (node.children.containsKey(char)){
        node = node.children[char]!;
      }
    }

    recurse(CharNode node, String current){
      if (node.isWord){
        words.add(current);
      }else{
        node.children.forEach((char, node) {
          recurse(node, current + char);
        });
      }
    }
    recurse(node, word);

    return words;
  }

}


class MySearchDelegate extends SearchDelegate{

  CharNode searchNodes = CharNode();

  String? searchQ;

  MySearchDelegate(this.searchQ);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(
        onPressed: (){
          if (query.isEmpty) close(context, null);
          query = '';
    }, icon: Icon(CupertinoIcons.xmark))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: Icon(CupertinoIcons.back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('SUGG'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {



    return ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index){
          return Text('Suggestion n');
        });
  }

}