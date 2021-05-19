import 'package:flutter/material.dart';
import 'package:slide_drawer/slide_drawer.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

enum SlideDrawerExampleType {
  BASIC,
  BACKGROUND,
  GRADIENT,
  HEAD_DRAWER,
  CONTENT_DRAWER,
  HEAD_CONTENT_DRAWER,
  FULL_DRAWER,
}

class _AppState extends State<App> {
  Key _appKey = UniqueKey();
  SlideDrawerExampleType type = SlideDrawerExampleType.BASIC;

  bool get _isBasic => type == SlideDrawerExampleType.BASIC;
  bool get _isBackground => type == SlideDrawerExampleType.BACKGROUND;
  bool get _isGradient => type == SlideDrawerExampleType.GRADIENT;
  bool get _isHead => type == SlideDrawerExampleType.HEAD_DRAWER;
  bool get _isContent => type == SlideDrawerExampleType.CONTENT_DRAWER;
  bool get _isHeadContent => type == SlideDrawerExampleType.HEAD_CONTENT_DRAWER;
  bool get _isFullDrawer => type == SlideDrawerExampleType.FULL_DRAWER;

  List<MenuItem> get _items => [
        MenuItem('Basic',
            onTap: () => _changeType(SlideDrawerExampleType.BASIC)),
        MenuItem('Custom Background',
            onTap: () => _changeType(SlideDrawerExampleType.BACKGROUND)),
        MenuItem('Custom Gradient',
            onTap: () => _changeType(SlideDrawerExampleType.GRADIENT)),
        MenuItem('Custom Header',
            onTap: () => _changeType(SlideDrawerExampleType.HEAD_DRAWER)),
        MenuItem('Custom Content',
            onTap: () => _changeType(SlideDrawerExampleType.CONTENT_DRAWER)),
        MenuItem('Header and Content',
            onTap: () =>
                _changeType(SlideDrawerExampleType.HEAD_CONTENT_DRAWER)),
        MenuItem('Full Drawer',
            onTap: () => _changeType(SlideDrawerExampleType.FULL_DRAWER)),
      ];

  List<MenuItem> get _itemsIcon => [
        MenuItem('Basic',
            icon: Icons.rss_feed,
            onTap: () => _changeType(SlideDrawerExampleType.BASIC)),
        MenuItem('Custom Background',
            icon: Icons.favorite_border,
            onTap: () => _changeType(SlideDrawerExampleType.BACKGROUND)),
        MenuItem('Custom Gradient',
            icon: Icons.mail_outline,
            onTap: () => _changeType(SlideDrawerExampleType.GRADIENT)),
        MenuItem('Custom Header',
            icon: Icons.map,
            onTap: () => _changeType(SlideDrawerExampleType.HEAD_DRAWER)),
        MenuItem('Custom Content',
            icon: Icons.person_outline,
            onTap: () => _changeType(SlideDrawerExampleType.CONTENT_DRAWER)),
        MenuItem('Header and Content',
            icon: Icons.alarm,
            onTap: () =>
                _changeType(SlideDrawerExampleType.HEAD_CONTENT_DRAWER)),
        MenuItem('Full Drawer',
            icon: Icons.settings,
            onTap: () => _changeType(SlideDrawerExampleType.FULL_DRAWER)),
      ];

  _changeType(type) {
    if (this.type != type)
      setState(() {
        this.type = type;
        _appKey = UniqueKey();
      });
  }

  Widget get _home {
    if (_isBasic) return _basic;
    if (_isBackground) return _background;
    if (_isGradient) return _gradient;
    if (_isHead) return _head;
    if (_isContent) return _content;
    if (_isHeadContent) return _headContent;
    if (_isFullDrawer) return _fullDrawer;
    return _basic;
  }

  Widget get _basic => SlideDrawer(
        child: HomePage(),
        items: _items,
      );

  Widget get _background => SlideDrawer(
        child: HomePage(),
        brightness: Brightness.dark,
        backgroundColor: Colors.blue[900],
        items: _items,
      );

  Widget get _gradient => SlideDrawer(
        child: HomePage(),
        brightness: Brightness.dark,
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          colors: [
            Color(0xFF000046),
            Color(0xFF1CB5E0),
          ],
        ),
        curve: Curves.easeInOut,
        items: _itemsIcon,
      );

  Widget get _head => SlideDrawer(
        child: HomePage(),
        brightness: Brightness.dark,
        backgroundColor: Colors.blue[800],
        headDrawer: Image.asset('boys.png'),
        alignment: SlideDrawerAlignment.start,
        items: _itemsIcon,
      );

  Widget get _content => SlideDrawer(
        child: HomePage(),
        brightness: Brightness.dark,
        contentDrawer: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              for (var item in _itemsIcon)
                ListTile(
                  title: Text(item.title),
                  leading: Icon(item.icon),
                  onTap: item.onTap,
                ),
            ],
          ),
        ),
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          colors: [
            Colors.blue[800]!,
            Color(0xFF1CB5E0),
          ],
        ),
      );

  Widget get _headContent => SlideDrawer(
        child: HomePage(),
        brightness: Brightness.light,
        backgroundColor: Color(0xffededed),
        alignment: SlideDrawerAlignment.start,
        headDrawer: Image.asset('boys.png'),
        contentDrawer: Container(
          padding: EdgeInsets.only(left: 10, top: 18),
          child: Column(
            children: [
              for (var item in _itemsIcon)
                ListTile(
                  title: Text(item.title),
                  leading: Icon(item.icon),
                  onTap: item.onTap,
                ),
            ],
          ),
        ),
      );

  Widget get _fullDrawer => SlideDrawer(
        child: HomePage(),
        isRotate: false,
        offsetFromRight: 100,
        drawer: Container(
          color: Colors.teal,
          padding: EdgeInsets.symmetric(vertical: 36, horizontal: 15),
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var item in _items)
                  ListTile(
                    title: Text(item.title),
                    onTap: item.onTap,
                  ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: _appKey,
      title: 'Slide Drawer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _home,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Slide Drawer Demo'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          // call toggle from SlideDrawer to alternate between open and close
          // when pressed menu button
          onPressed: () => SlideDrawer.of(context)?.toggle(),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
