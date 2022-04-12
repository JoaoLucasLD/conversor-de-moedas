import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=14df8e1d";

void main() async {
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(
        hintColor: Colors.green,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          hintStyle: TextStyle(color: Colors.green),
        )),
  ));
}

Future<Map?> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final ieneController = TextEditingController();

  double? dolar;
  double? euro;
  double? iene;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar!).toStringAsFixed(2);
    euroController.text = (real / euro!).toStringAsFixed(2);
    ieneController.text = (real / iene!).toStringAsFixed(2);

  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar!).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar! / euro!).toStringAsFixed(2);
    ieneController.text = (dolar * this.dolar! / iene!).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro!).toStringAsFixed(2);
    dolarController.text = (euro * this.euro! / dolar!).toStringAsFixed(2);
    ieneController.text = (euro * this.euro! / iene!).toStringAsFixed(2);

  }

  void _ieneChanged(String text) {
    double iene = double.parse(text);
    realController.text = (iene * this.iene!).toStringAsFixed(2);
    euroController.text = (iene * this.iene! / euro!).toStringAsFixed(2);
    dolarController.text = (iene * this.iene! / dolar!).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Conversor de Moedas"),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: FutureBuilder<Map?>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                  child: Text(
                "Carregando Dados...",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ));
            default:
              if (snapshot.hasError) {
                return const Center(
                    child: Text(
                  "Erro ao carregar dados :(",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ));
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                iene = snapshot.data!["results"]["currencies"]["JPY"]["buy"];
                

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.monetization_on,
                          size: 100,
                          color: Colors.green,
                        ),
                      ),
                      buildTextField(
                          "Reais", "R\$", realController, _realChanged),
                      const Divider(),
                      buildTextField(
                          "Dólares", "US\$", dolarController, _dolarChanged),
                      const Divider(),
                      buildTextField(
                          "Euros", "€", euroController, _euroChanged),
                      const Divider(),
                      buildTextField("Ienes", "¥", ieneController, _ieneChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function(String) f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.green),
      border: const OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: const TextStyle(
      color: Colors.green,
      fontSize: 25,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
