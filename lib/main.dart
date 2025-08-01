import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final methodChannel = MethodChannel('flutter_tts_native');


  Future<void> execute(Future<void> Function() func) async {
    try {
      await func();
    } on PlatformException catch (e) {
      debugPrint('Erro: ${e.code} - ${e.message}');
    } on MissingPluginException catch (e) {
      debugPrint('Erro: ${e.message}');
    }
  }

  Future<void> channelSpeakCorrectly() async {
    await methodChannel.invokeMethod('speak', 'Olá mundo');
  }

  Future<void> channelEmptyTextError() async {
    await methodChannel.invokeMethod('speak', '');
  }

  Future<void> channelNotImplementedMethodError() async {
    await methodChannel.invokeMethod('sspeak', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(onPressed: () => execute(channelSpeakCorrectly), icon: Icon(Icons.check)),
            IconButton(onPressed: () => execute(channelEmptyTextError), icon: Icon(Icons.error)),
            IconButton(onPressed: () => execute(channelNotImplementedMethodError), icon: Icon(Icons.question_mark)),
          ],
        ),
      ),
    );
  }
}
