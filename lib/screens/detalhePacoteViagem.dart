import 'package:flutter/material.dart';
import 'package:trabalho_final/model/pacoteViagem.dart';
import 'package:trabalho_final/util/dbhelper.dart';
import 'package:intl/intl.dart';

// Preparação para o menu de opções:
final List<String> choices = const <String> [
  'Salvar e Voltar',
  'Excluir Pacote',
  'Voltar'
];

const mnuSave = 'Salvar e Voltar';
const mnuDelete = 'Excluir Pacote';
const mnuBack = 'Voltar';


// Classe do StatefulWidget
// Como toda esta tela está relacionada com uma tarefa,
// vamos receber um objeto no construtor, e guardar em
// um atributo.
class DetalhePacoteViagem extends StatefulWidget {

  // Atributo "tarefa":
  final PacoteViagem pacoteViagem;
  // Construtor que recebe e armazena a tarefa:
  DetalhePacoteViagem(this.pacoteViagem);

  @override
  State<StatefulWidget> createState() => DetalhePacoteViagemlState(pacoteViagem);
}

// Classe State do Statefulwidget...
class DetalhePacoteViagemlState extends State<DetalhePacoteViagem> {

  // Referencia para nosso dbhelper:
  DbHelper helper = DbHelper();

  // Atributo para armazenar a tarefa desta tela:
  PacoteViagem pacoteViagem;

  // Construtor que recebe a tarefa (objeto)
  // E guarda no atributo:
  DetalhePacoteViagemlState(this.pacoteViagem);

  // Como vamos ter 2 caixas de texto, vamos criar controllers para elas:
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController urlImageController = TextEditingController();

  // Método build...
  @override
  Widget build(BuildContext context) {

    // Pegar os dados da tarefa que recebemos
    // e colocar nas caixas de texto (isto é, nos controllers):
    titleController.text = pacoteViagem.title;
    descriptionController.text = pacoteViagem.description;
    priceController.text = pacoteViagem.price;
    urlImageController.text = pacoteViagem.urlImage;

    // Definindo um estilo de texto padrão:
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    // Retornando nosso Scaffold...
    return Scaffold(

      appBar: AppBar(
        // Não queremos o botão automático para retornar:
        automaticallyImplyLeading: false,

        // O texto que vai aparecer na barra é o título da tarefa:
        title: Text(pacoteViagem.title),

        // Vamos definir possíveis ações (botões) na appbar.
        // É uma lista de Wdgets. Neste caso, teremos apenas um,
        // um PopupMenuButton (menu popup).
        actions: <Widget>[

          PopupMenuButton<String>(
            // Ao ser escolhida uma opção, vamos chamar o método select:
            onSelected: select,

            // Vamos construir os itens desse menu.
            // Aqui ele usa o mesmo tipo de código reduzido que já vimos
            // no caso do dropdown. Ele usa map para varrer a lista de
            // itens de menu (choices, definida lá em cima),
            // e para cada iten na lista retorna um item de menu
            // (widget PopupMenuItem), que retorna a string definida
            // na lista, e também tem como texto a mesma string.
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: Column(
          children: <Widget>[
            // Caixa de texto para o título da tarefa:
            TextField(
              controller: titleController,
              style: textStyle,
              onChanged: (value) => updateTitle(),
              decoration: InputDecoration(
                labelText: "Título",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),

            // Caixa de texto para a descrição da tarefa:
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) => updateDescription(),
                decoration: InputDecoration(
                  labelText: "Descrição",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: priceController,
                style: textStyle,
                onChanged: (value) => updatePrice(),
                decoration: InputDecoration(
                  labelText: "Preço",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: urlImageController,
                style: textStyle,
                onChanged: (value) => updateUrlImage(),
                decoration: InputDecoration(
                  labelText: "Url Imagem",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  // Método que vai ser chamado pelos itens do menu de opções
  // na appbar. O parâmetro value é a string que o item lá
  // no menu retornou.
  // Como vamos usar o banco, vamos definir como async, e mandar
  // para outra thread de execução, não atrasando a main thread
  // (responsável pela interface gráfica):
  void select (String value) async {
    // Variável para os resultados das operações com o banco:
    int result;

    switch (value) {
    // Caso escolheu salvar...
      case mnuSave:

      // Vamos chamar o método save:
        save();
        break;

    // Caso escolheu apagar...
      case mnuDelete:

      // Ele não explicou porque ele "volta" para a página anterior
      // logo aqui no início, mas minha teoria é: como as operações
      // de banco são feitas em outra thread (async), ele já
      // atualiza a interface gráfica, enquanto a outra thread
      // trata do comando de deleção dado.
        Navigator.pop(context, true);

        // Se o id é nulo, não tem nada a apagar (o usuário
        // clicou no +:
        if (pacoteViagem.id == null) {
          return;
        }

        // Senão, manda o helper apagar o todo com id.
        // o await espera esta resposta...
        // Lembre-se que estamos em outra thread, a interface
        // gráfica não está parada, pois fica na main thread.
        result = await helper.deletePacote(pacoteViagem.id);

        // result tem o resultado de rawDelete.
        // Procurei mas não achei uma definição do que o método
        // rawDelete retorna. Imagino que é a quantidade de
        // registros apagados. Precisamos testar.
        // De qualquer modo, se apagou, result vai ser != 0.
        if (result != 0) {
          // Neste caso, exibe uma caixa de diálogo informando
          // sobre a deleção:
          AlertDialog alertDialog = AlertDialog(
            title: Text("Excluir Pacote"),
            content: Text("O Pacote foi excluído com sucesso!"),
          );
          showDialog(
              context: context,
              builder: (context) => alertDialog);
        }
        break;

    // Aqui escolheu simplesmente voltar para a lista...
      case mnuBack:
        Navigator.pop(context, true);
        break;

      default:
    }
  }


  // Método para salvar o todo:
  void save() {
    // Formatar a data e hora atual
    pacoteViagem.date = new DateFormat.yMd().format(DateTime.now());

    // Se o id não for nulo, é porque estamos editando um todo
    // que já existe:
    if (pacoteViagem.id != null) {
      helper.updatePacote(pacoteViagem);
    }
    // Caso contrário, estamos criando um todo novo:
    else {
      helper.insertPacote(pacoteViagem);
    }
    // De qualquer modo, ao final, retorna para a lista:
    Navigator.pop(context, true);
  }

  // Métodos para trabalhar com as caixas de texto:
  void updateTitle(){
    pacoteViagem.title = titleController.text;
  }

  void updateDescription() {
    pacoteViagem.description = descriptionController.text;
  }

  void updatePrice() {
    pacoteViagem.price = priceController.text;
  }

  void updateUrlImage() {
    pacoteViagem.urlImage = urlImageController.text;
  }
}