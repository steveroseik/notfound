

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