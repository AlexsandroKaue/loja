class CepAbertoAddress {
  final double altitude;
  final String cep;
  final double latitude;
  final double longitude;
  final String logradouro;
  final String complemento;
  final String bairro;
  final Cidade cidade;
  final Estado estado;

  // Pesquisar sobre esta notação de construtor com :
  CepAbertoAddress.fromMap(Map<String, dynamic> map) :
    altitude = map['altitude'] as double,
    cep = map['cep'] as String,
    latitude = double.tryParse(map['latitude'] as String),
    longitude= double.tryParse(map['longitude'] as String),
    logradouro = map['logradouro'] as String,
    complemento = map['complemento'] as String,
    bairro = map['bairro'] as String,
    cidade = Cidade.fromMap(map['cidade'] as Map<String, dynamic>),
    estado = Estado.fromMap(map['estado'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'CepAbertoAddress{altitude: $altitude, cep: $cep, latitude: $latitude, longitude: $longitude, logradouro: $logradouro, complemento: $complemento, bairro: $bairro, cidade: $cidade, estado: $estado}';
  }


}

class Cidade {
  final int ddd;
  final String nome;
  final String ibge;

  Cidade.fromMap(Map<String, dynamic> map) :
    ddd = map['ddd'] as int,
    nome = map['nome'] as String,
    ibge = map['ibge'] as String;

  @override
  String toString() {
    return 'Cidade{ddd: $ddd, nome: $nome, ibge: $ibge}';
  }


}

class Estado {
  final String sigla;

  Estado.fromMap(Map<String, dynamic> map) :
    sigla = map['sigla'] as String;

  @override
  String toString() {
    return 'Estado{sigla: $sigla}';
  }


}