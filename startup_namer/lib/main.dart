import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

// 该应用程序继承了 StatelessWidget，这将会使应用本身也成为一个widget。 在Flutter中，大多数东西都是widget，包括对齐(alignment)、填充(padding)和布局(layout)
class MyApp extends StatelessWidget {
  @override
  // widget的主要工作是提供一个build()方法来描述如何根据其他较低级别的widget来显示自己。
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    // return new MaterialApp(
    //   title: 'Welcome to Flutter',
    //   // Scaffold 是 Material library 中提供的一个widget, 它提供了默认的导航栏、标题和包含主屏幕widget树的body属性。
    //   home: new Scaffold(
    //     appBar: new AppBar(
    //       title: new Text('Welcome to Flutter'),
    //     ),
    //     body: new Center(
    //       // child: new Text(wordPair.asPascalCase),
    //       child: new RandomWords(),
    //     ),
    //   ),
    // );
    return new MaterialApp(
      title: 'Starup Name Generator',
      // 添加主题UI
      theme: new ThemeData(
        primaryColor: Colors.blue
      ),
      home: new RandomWords(),
    );
  }
}

// 随机字符类继承动态Widget类
class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

// 随机字符类继承State
class RandomWordsState extends State<RandomWords> {
  @override
  final _suggestions = <WordPair>[];  // 声明一个字符类数组
  final _saved = new Set<WordPair>(); // Set集合类，用来存储所选择的数据
  final _biggerFont = const TextStyle(fontSize: 18.0); // 样式

  Widget _buildRow(WordPair pair) {
    final alredySaved = _saved.contains(pair); // 检查确保单词对还没有添加到收藏夹中
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alredySaved ? Icons.favorite : Icons.favorite_border, // 三元判断有则添加一个红心icon
        color: alredySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if(alredySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
      // 在偶数行，该函数会为单词对添加一个ListTile row.
      // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
      // 注意，在小屏幕上，分割线看起来可能比较吃力。
      itemBuilder: (context, i) {
        // 在每一列之前，添加一个1像素高的分隔线widget
        if(i.isOdd) return new Divider();
        // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
        final index = i ~/2;
        if( index >= _suggestions.length) {
          // ...接着再生成10个单词对，然后添加到建议列表
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );

  }

  // 添加路由
  void _pushSaved() {
    // 添加Navigator.push调用，使路由入栈（
    Navigator.of(context).push(
      // 新建路由
      new MaterialPageRoute(builder: (context) {
        final tiles = _saved.map(
          (pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont
              ),
            );
          }
        );
        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();

        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Saved Suggestions'),
          ),
          body: new ListView(children: divided),
        );
      })
    );
  }

  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    // return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions()
    );
  }
  
}