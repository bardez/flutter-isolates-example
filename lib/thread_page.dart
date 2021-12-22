import 'dart:isolate';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({Key? key}) : super(key: key);

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    if (widgets.isEmpty) {
      return true;
    }
    return false;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Thread App"),
        ),
        body: getBody());
  }

  ListView getListView() => ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    return Padding(
        padding: const EdgeInsets.all(10.0), child: Text(widgets[i]["title"]));
  }

  loadData() async {
    // Abre a porta para receber a porta de comunicação dentro do Isolate
    ReceivePort receiveIsolatePort = ReceivePort();
    // Cria o Isolate com o metodo e a porta criada anteriormente
    await Isolate.spawn(dataLoader, receiveIsolatePort.sendPort);

    // Guarda a porta enviada pelo Isolate
    SendPort sendToIsolatePort = await receiveIsolatePort.first;

    // Envia a requisição com o link para o Isolate baixar o json
    List msg = await sendReceive(
        sendToIsolatePort, "https://jsonplaceholder.typicode.com/posts");

    // Exibi os dados baixados
    setState(() {
      widgets = msg;
    });
  }

  // O metodo do Isolate
  static dataLoader(SendPort sendPort) async {
    // Abre a porta para receber as requisições
    ReceivePort port = ReceivePort();

    // Envia para a main thread a porta
    sendPort.send(port.sendPort);

    // Espera receber a requisição
    await for (var msg in port) {
      // Link do json
      final url = Uri.parse(msg[0]);
      // Porta para retornar
      SendPort replyTo = msg[1];

      http.Response response = await http.get(url);
      // Envia a resposta do http
      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort port, link) {
    // Abre uma porta para receber a resposta da requisição
    ReceivePort response = ReceivePort();
    // Envia para o Isolate o link e a porta de resposta
    port.send([link, response.sendPort]);
    return response.first;
  }
}
