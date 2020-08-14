import 'package:flutter/material.dart';
import 'package:trabalho_final/model/pacoteViagem.dart';
import 'package:trabalho_final/util/dbhelper.dart';
import 'package:trabalho_final/screens/detalhePacoteViagem.dart';

// Criando o StatefilWidget...
class ListaPacotesViagens extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListaPacotesViagensState();
}

class ListaPacotesViagensState extends State<ListaPacotesViagens> {

  // Atributos...
  DbHelper helper = DbHelper();
  List<PacoteViagem> pacotes;
  int count = 0; // número de registros na tabela

  // Método para recuperar os dados.
  // Retorna void, mas vai usar setState()
  // para atualizar os atributos.
  void getData() {

    // abre ou cria o banco de dados
    final dbFuture = helper.initializeDb();

    // quando o resultado chega... (banco de dados aberto)
    dbFuture.then( (result) {

      // cria a lista com todos os dados
      final pacotesFuture = helper.getPacotes();

      // quando o resultado chega...
      pacotesFuture.then( (result) {

        // cria uma lista temporaria de objetos:
        List<PacoteViagem> listaPacotesViagens = List<PacoteViagem>();

        // vê quantos registros retornaram, guarda em count:
        count = result.length;

        // varre a lista result...
        // para cada elemento na lista (um Map), cria o objeto,
        // e adiciona em todoList.
        for (int i=0; i<count; i++) {
          listaPacotesViagens.add(PacoteViagem.fromObject(result[i])); // result[i] é um Map
          // mostra o título do elemento lido, so pra conferir:
          debugPrint(listaPacotesViagens[i].title);
        }

        // Chamando setState, e dentro dela, atualizando os atributos:
        setState(() {
          pacotes = listaPacotesViagens;
        });

        // mostra a quantidade, só pra conferência:
        debugPrint("Itens " + count.toString());
      });
    });
  }

  // build...
  @override
  Widget build(BuildContext context) {

    // se o atributo todos está vazio, é pq
    // a tela carregou pela 1a vez
    if (pacotes == null) {

      // cria a lista:
      pacotes = List<PacoteViagem>();

      // popula a lista:
      getData();
    }

    return Scaffold(
      body: itensPacotes(),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Chama o método que vai pra outra tela,
            // passando um objeto:
            navigateToDetail(PacoteViagem("","",""));
          },
          tooltip: "Criar Pacote de Viagem",
          child: new Icon(Icons.add),
        ),

    );
  }

  // corpo do Scaffold, nosso listview
  ListView itensPacotes() {

    // criando e retornando nosso listview:
    return ListView.builder(

      itemCount: pacotes.length, // total de elementos na lista

      // no parâmetro itemBuilder vai uma função que será
      // executada para cada item da lista (de número position):
      itemBuilder: (BuildContext context, int position) {

        // cada item da lista sera um Card (CardView do android nativo):
        return Card(

          color: Colors.white,
          elevation: 2.0,

          // Widget que forma o item da lista:
          child:

          ListTile(
            // o que vai no início do item
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(this.pacotes[position].urlImage),
              backgroundColor: Colors.transparent
              //backgroundColor: getColor(this.pacotes[position].priority),
              //child:Text(this.pacotes[position].priority.toString()),
            ),

            title: Text(this.pacotes[position].title),

            subtitle: Text(this.pacotes[position].description + '\nR\$\ ' + this.pacotes[position].price),

            onTap: () {
              debugPrint("Tapped on " + this.pacotes[position].id.toString());

              navigateToDetail(this.pacotes[position]);
            },
          ),
        );
      },
    );
  }

  // Método para abrir a tela de detalhes da tarefa,
  // passada como parâmetro:
    void navigateToDetail(PacoteViagem pacoteViagem) async {
      bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetalhePacoteViagem(pacoteViagem)),
      );

      if (result == true) {
        getData();
      }
    }


}