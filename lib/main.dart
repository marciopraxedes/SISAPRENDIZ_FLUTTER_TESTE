import 'package:appsignalr/listUsers.dart';
import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

// ignore: import_of_legacy_library_into_null_safe

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SisAprendiz Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SisAprendiz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// Properties
  String _serverUrl = "https://sisaprendiz.cvr.org.br/onlinecount";
  late String errorMessage;
  Object _counter = 0;
  List<String> _listUsers = <String>[];

  Future<void> getHubConnection() async {
    HubConnection _hubConnection = HubConnectionBuilder()
        .withUrl(_serverUrl)
        .withAutomaticReconnect()
        .build();

    if (_hubConnection.state != HubConnectionState.Connected) {
      var result = await _hubConnection.start();

      print("Connection state '${_hubConnection.state}'");

      _hubConnection.on("updateCountValue", updateCount);
      _hubConnection.on("updateListUsers", updateListaUsuarios);
    }
  }

  Future<void> updateCount(List<Object> value) async {
    setState(() {
      _counter = value[0];
    });
  }

  Future<void> updateListaUsuarios(List<dynamic> value) async {
    List<dynamic> lista = value[0];

    var listaUsuarios = <String>[];
    var usuarios = lista.toList();
    for (int i = 0; i < lista.length; i++) {
      var jsonDecode = Map<dynamic, dynamic>.from(usuarios[i]);
      listaUsuarios.add(jsonDecode['name']);
    }

    setState(() {
      _listUsers = listaUsuarios;
    });
  }

  Future<void> connect() async {
    try {} catch (e) {
      errorMessage = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('SisAprendiz no Flutter'),
    );

    final availableHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pessoas conectadas no SisAprendiz',
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        getHubConnection();
                      },
                      child: const Text('Ativar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: availableHeight * 0.75,
            child: ListViewBuilder(_listUsers),
          )
        ],
      ),
    );
  }
}
