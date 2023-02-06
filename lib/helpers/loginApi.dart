import 'dart:convert';
import 'package:http/http.dart' as http;

class loginApi 
{
  static Future<String> login(String user, String password) async 
  {
    Uri url = Uri.parse('http://www.santoandre.sp.gov.br/APIportalservico/AppPSA/login');

    Map<String, String> cabecalhoToken = 
    {
      "Content-Type": "application/json-patch+json",
      "accept": "/",
      "usuario": "",
      "senha": "",
    };

    Map dadosLoginBDM = {"usuarioBDM": user, "senhaBDM": password};
    var bodyLoginBDM  = json.encode(dadosLoginBDM);
    var response      = await http.post(url, headers: cabecalhoToken, body: bodyLoginBDM);
    var v_statusCode  = response.statusCode;

    if (v_statusCode == 200) 
    {
      var DadosRetornoAutenticacao = json.decode(response.body);

      return DadosRetornoAutenticacao["cod_retorno"] == 1 ? "OK" : "NOK";
    } 
    else 
    {
      return "SU";
    }
  }
}
