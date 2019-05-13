import 'package:flutter/material.dart';

// 相当于 Application。 Stateless: 无状态的
class OriginalMyApp extends StatelessWidget {
  //此 Widget 是应用程序的根
  @override
  Widget build(BuildContext context) {
    //创建对象同 kotlin 没有new字段(但也可以加上 new)，必须分号结尾。
    //Material: 材料，材料设计是一种标准的移动端、web端，提供了一套 Material widgets(材料设计部件) https://material.io/design/
    return MaterialApp(
      //Toolbar 标题文字
      title: 'Flutter Demo',
      //主题，这里配置了主色
      theme: ThemeData(
        //体验热重载，可尝试更改颜色，并点闪电运行，可看到计数器没有归零
        primarySwatch: Colors.green,
      ),
      // home 就是首页
      home: MyHomePage(myTitle: 'Flutter Demo Home Page'),
    );
  }
}

// 首页。 Stateful: 有状态的
class MyHomePage extends StatefulWidget {
  //构造，title是final类型，则最晚在构造时初始化(也可直接指定值)
  //父构造的调用类似 kotlin，也是不能手动在方法内调用的
  //不知道构造的写法是怎么回事，竟然在参数位置加了“{}”
  MyHomePage({Key key, this.myTitle}) : super(key: key);

  final String myTitle;

  //用接口添加自己的状态
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//自己的状态类
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    //通过调用 setState 来通知 Flutter框架“这个状态下有什么变了”，导致回调下面的 build()
    //可以把计算代码写在外面，只是若不调用 setState ，则不会发生任何事情
    setState(() {
      _counter++;
    });
  }

  //此方法会因 setState 而触发
  //Flutter框架已优化，可快速运行 build()，即热装载
  @override
  Widget build(BuildContext context) {
    //Scaffold: 脚手架
    return Scaffold(
      //万恶的官方标题栏
      appBar: AppBar(
        //标题文字使用 MyHomePage.title，这里的 widget 就是 MyHomePage
        title: Text(widget.myTitle),
      ),

      //页面内容
      body: Center(
        // Center 是个 layout，它会把唯一的 child 固定到中心，所以我们开始手写布局咯
        child: Column(
          //可以开启“debug painting”在调试模式下查看布局排版。
          // 1、app处于调试模式。2、打开紧贴右侧的 Flutter Inspector(检察员)。3、切到 RenderTree(渲染树) 栏。
          // 4、开启定位标志的按钮。5、在手机上点击控件A，代码就会跳转到目标处。
          // 6、重开定位按钮 或 点击手机上的搜索图标 来再次进入定位模式。

          // Column 相当于垂直排序的、(warp,match)的 LinearLayout，
          // 使用了 mainAxisAlignment = center 来让内容上下居中
          mainAxisAlignment: MainAxisAlignment.center,
          // layout的子View们
          children: <Widget>[
            //一个普通文本标题
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              //类似kotlin用“$”引用变量到字符串中
              '次数:$_counter',
              //默认样式
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),

      //浮动按钮
      floatingActionButton: FloatingActionButton(
        //指定点击事件是 _incrementCounter
        onPressed: _incrementCounter,
        //长按时弹出的提示文字。 tooltip: 工具提示
        tooltip: 'Increment',
        //显示的“+”图其实是个子View，名字叫 Icon
        child: Icon(Icons.add),
      ), // 这个尾随逗号使构建方法的自动格式更好。
    );
  }
}
