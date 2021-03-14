class ViaCepAddress {

  String cep;
  String logradouro;
  String complemento;
  String bairro;
  String localidade;
  String uf;
  String ibge;
  String gia;
  String ddd;
  String siafi;

  ViaCepAddress.fromMap(Map<String, dynamic> map){
    cep = map['cep'] as String;
    logradouro = map['logradouro'] as String;
    complemento = map['complemento'] as String;
    bairro = map['bairro'] as String;
    localidade = map['localidade'] as String;
    uf = map['uf'] as String;
    ibge = map['ibge'] as String;
    gia = map['gia'] as String;
    ddd = map['ddd'] as String;
    siafi = map['siafi'] as String;
  }

  @override
  String toString() {
    return 'ViaCepAddress{cep: $cep, logradouro: $logradouro, complemento: $complemento, bairro: $bairro, localidade: $localidade, uf: $uf, ibge: $ibge, gia: $gia, ddd: $ddd, siafi: $siafi}';
  }


}