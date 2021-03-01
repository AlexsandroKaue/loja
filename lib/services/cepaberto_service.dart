import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lojavirtualv2/models/cepaberto_address.dart';

const token = '62241dc701e33215d21966b219f4ee35';

class CepAbertoService {



  Future<CepAbertoAddress> getAddressFromCep(String cep) async {
    final String cleanCep = cep.replaceAll(RegExp('[^0-9]'), '');

    final String endpoint = 'https://www.cepaberto.com/api/v3/cep?cep=$cleanCep';

    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try{
      final response = await dio.get<Map<String, dynamic>>(endpoint);
      if(response.data.isEmpty) {
        return Future.error('Cep inválido!');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);

      return address;
    } on DioError catch(e) {
      return Future.error('Erro ao buscar CEP');
    }

  }

}