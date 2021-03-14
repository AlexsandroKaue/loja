import 'package:dio/dio.dart';
import 'package:lojavirtualv2/models/viacep_address.dart';

class ViaCepService {


  Future<ViaCepAddress> getAddressFromCep(String cep) async {
    final String cleanCep = cep.replaceAll(RegExp('[^0-9]'), '');

    final String endpoint = 'https://viacep.com.br/ws/$cleanCep/json/';

    final Dio dio = Dio();

    try{
      final response = await dio.get<Map<String, dynamic>>(endpoint);
      if(response.data.isEmpty) {
        return Future.error('Cep inválido!');
      }

      final address = ViaCepAddress.fromMap(response.data);
      return address;
    } on DioError catch(e) {
      return Future.error('Erro ao buscar CEP');
    }

  }
}