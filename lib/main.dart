import 'package:flutter/material.dart';

import 'package:trabalho_final/screens/listaPacotesViagens.dart';

// Importando o dbhelper:
import 'package:trabalho_final/util/dbhelper.dart';

// Importando a classe do modelo:
import 'package:trabalho_final/model/pacoteViagem.dart';

// Inserir a classe listaPacotesViagens:
import 'package:trabalho_final/screens/listaPacotesViagens.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MLM - Pacotes de Viagens',
      theme: new ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext formContext) {

    /* Insere massa de dados */
    /*
    DbHelper helper = DbHelper();
    DateTime today = DateTime.now();

    PacoteViagem pacoteViagem = PacoteViagem("Salvador - BA", "699,00", today.toString(), "5 noites em Salvador(Hotel + Voo)", "https://i0.wp.com/www.linearquitetura.com.br/blog/wp-content/uploads/2015/12/5-2.jpg");

    Future id = helper.insertPacote(pacoteViagem);

    id.then( (value) => debugPrint(value.toString()) );

    pacoteViagem = PacoteViagem("Porto de Galinhas - PE", "1200,00", today.toString(), "7 noites em Porto de Galinhas(Hotel + Voo)", "https://go.hurb.com/wp-content/uploads/2020/01/porto-de-galinhas.jpg");

    Future id2 = helper.insertPacote(pacoteViagem);
    id2.then( (value) => debugPrint(value.toString()) );

    pacoteViagem = PacoteViagem("Maragogi - AL", "1599,00", today.toString(), "6 noites em Maragogi(Hotel + Voo)", "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSaSG1CABwdjDwy-YhJjxIwry0YwFmU345LWJmBtUTjheuJBo2_KwFfV7GOt41x1AwtrHha6nL5aK-a5z9b-EjiBHWnnFKVXGBlCw&usqp=CAU&ec=45690273");

    Future id3 = helper.insertPacote(pacoteViagem);
    id3.then( (value) => debugPrint(value.toString()) );
    */

    return Scaffold(

        appBar: AppBar(
          title: Text("MLM - Pacotes de Viagens"),
        ),

        body: ListaPacotesViagens()
    );
  }
}