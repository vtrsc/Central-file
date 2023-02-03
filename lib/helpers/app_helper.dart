import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


//#region Test
Future<Map> postAtualizaEstantePrateleira(int intNumProcesso,int intNumAno,String strPrateleira) async{
Map data = {
  "classificaçao_processo" : {
    "Numero do processo" :intNumProcesso,
    "ano" : intNumAno,
    "Numero da prateleira": strPrateleira,
  },
};


Map<String , String> headers = {
  "Content-type" : "application/json-Path+json" ,
  "accept" : "*/*",
  "usuario": "apparqcentral",
  "senha" : "ce!LRarDETXkdDo!rKNm",
};

var url = Uri.parse('http://www.santoandre.sp.gov.br/apiPortalServico/');
http.Response response = await http.post(url, headers: headers , body: jsonEncode(data));

return json.decode(response.body);
}
//#endregion