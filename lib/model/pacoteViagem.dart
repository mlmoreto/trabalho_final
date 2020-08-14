class PacoteViagem {

  // Atributos:
  int _id;
  String _title;
  String _description;
  String _date;
  String _price;
  String _urlImage;

  // Construtor para quando o BD ainda não definiu o id.
  // O parâmetro _description é opcional.
  PacoteViagem(this._title, this._price, this._date, [this._description, this._urlImage] );

  // Construtor para quando já tivermos o id.
  // Lembre-se, em dart não existe sobrecarga de métodos,
  // então precisaremos criar um "named constructor".
  // O parâmetro _description é opcional.
  PacoteViagem.withId(this._id, this._title, this._price, this._date, [this._description, this._urlImage]);

  // Getters...
  String get price => _price;
  String get date => _date;
  String get description => _description;
  String get title => _title;
  String get urlImage => _urlImage;
  int get id => _id;

  // Setters...
  set title (String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description (String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set price (String newPrice) {
    //if (newPrice >0 && newPrice<=3) {
      _price = newPrice;
    //}
  }

  set date(String newDate) {
    _date = newDate;
  }

  set urlImage(String newUrlImage){
    _urlImage = newUrlImage;
  }

  // Método que vai retornar nosso objeto como um Map.
  // Vai ser útil para uso com SQLite.
  Map <String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["description"] = _description;
    map["price"] = _price;
    map["date"] = _date;
    map["urlImage"] = _urlImage;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  // Método que vai fazer o contrário do método acima.
  // Pegar um Map, e transformar em um objeto.
  // Na verdade, será um outro "named constructor".
  PacoteViagem.fromObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._description = o["description"];
    this._price = o["price"];
    this._date = o["date"];
    this.urlImage = o["urlImage"];
  }

}
