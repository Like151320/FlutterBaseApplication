import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/OriginalMyApp.dart';
import 'package:startup_namer/googleDemo.dart';

void main() => runApp(OriginalMyApp()); // =>: 单行函数的简写
//Flutter的依赖使用 pubspec.yaml 管理

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //PascalCase: 首字母大写 + 驼峰命名
    final randomText = new WordPair.random().asPascalCase;
  }
}

class RandomWordsState extends State<RandomWords> {
  //私有 = “_”做前缀
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  final BuildContext appContext;

  RandomWordsState(this.appContext);

  @override
  Widget build(BuildContext context) {
    //Scaffold: 脚手架，是 Material(材料设计)提供的部件，包含默认导航栏、标题栏、主屏幕widget树的body属性。
    //widget 的主要工作是提供 build() 来描述如何根据其它低级别的 widget 来显示自己，相当于手写布局
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Welcome to Flutter'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
//            new TestNext(),
        ],
      ),
      body: new Center(
        child: _buildSuggestions(),
      ),
    );
  }

  _pushSaved() {
    Navigator.of(this.context).push(
      new MaterialPageRoute(
        //构建视图
        builder: (context) {
          //将选中的文字转为 Iterable<ListTitle> 格式，惊了 页面之间没隔阂了。
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          //divide: 划分、分裂。 直接使用 Widget集合来构建，可以的
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          //返回构建的视图
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        //Insets: 嵌入物。 左右间距，都是16
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          // odd: 奇。 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd)
            return new Divider(
              height: 0.0, // 此高是上下间距，线粗不变
              color: Theme.of(context).primaryColor,
            );

          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final position = i ~/ 2;
          // 如果是建议列表中最后一个单词对
          if (position >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表  generate: 生成
            _suggestions.addAll(generateWordPairs().take(10));
          }
          //row: 行
          return _buildRow(_suggestions[position]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      //trailing: 尾随
      trailing: new Icon(
        //border: 边境/边界
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      //tap: 敲击。 PS:mdzz，怎么不统一press了
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
