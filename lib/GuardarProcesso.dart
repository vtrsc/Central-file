import 'package:arquivo_central/helpers/cameraController.dart';
import 'package:flutter/material.dart';
import 'package:arquivo_central/helpers/ProcessoApi.dart';
import 'package:arquivo_central/globals/styles.dart';
import 'package:arquivo_central/FuncoesGenericas.dart';

class GuardarProcesso extends StatefulWidget {
  const GuardarProcesso({Key? key}) : super(key: key);

  @override
  _GuardarProcessoState createState() => _GuardarProcessoState();
}

class _GuardarProcessoState extends State<GuardarProcesso> {
  final G_crtNumero_processo = TextEditingController();
  final G_ctrlNumero_ano = TextEditingController();
  final G_ctrlNumero_prateleira = TextEditingController();
  final G_formkey = GlobalKey<FormState>();
  final G_ctrlEstante = TextEditingController();
  bool _isLoading = false;

  late FocusNode FocusNodeProcesso;
  late FocusNode FocusNodeEstantePrateleira;
  late FocusNode focusNodeAno;

  var rest;
  var cameraControlador3 = CameraController();
  var cameraControladorEstante = CameraController();

  void initState() {
    super.initState();
    FocusNodeProcesso = FocusNode();
    FocusNodeEstantePrateleira = FocusNode();
  }

  String? _valida_NumeroProcesso(String? texto) {
    if (texto!.isEmpty) {
      return "Digite o número do Processo";
    }

    return null;
  }

  String? _valida_AnoProcesso(String? texto) {
    if (texto!.isEmpty) {
      return "Digite o ano do Processo";
    }

    return null;
  }

  String? _valida_estanteEprateleira(String? texto) {
    if (texto!.isEmpty) {
      return "Digite a Prateleira/Estante";
    }
    return null;
  }

  void _ScanearProcessoAno() async {
    await cameraControlador3.escanearCodigoBarras();
    String ProcessoAno = cameraControlador3.valorCodigoBarras;
    String NumProcesso =
        ProcessoAno.toString().substring(0, ProcessoAno.toString().length - 4);
    String AnoProcesso = ProcessoAno.toString().lastChars(4);

    setState(() {
      G_crtNumero_processo.text = NumProcesso;
      G_ctrlNumero_ano.text = AnoProcesso;
      FocusNodeEstantePrateleira.requestFocus();
    });
  }

  void _ScanearEstantePrateleira() async {
    await cameraControladorEstante.escanearCodigoBarras();
    G_ctrlEstante.text = cameraControladorEstante.valorCodigoBarras
        .replaceAll(' ', '')
        .toUpperCase();
    //_GuardarProcessoEstantePrateleira();
  }

  void _GuardarProcessoEstantePrateleira() async {
    bool formOk = G_formkey.currentState!.validate();

    if (!formOk) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String NumeroProcesso = G_crtNumero_processo.text.trim();
    String AnoProcesso = G_ctrlNumero_ano.text.trim();
    String EstanteEPrateleira = G_ctrlEstante.text.trim();
    String EstanteEPrateleiraConsulta = "";
    //String NumeroEstante      = G_ctrlEstante.text.trim();
    //String Prateleira         = G_ctrlNumero_prateleira.text.trim();
    //String EstanteEPrateleira = NumeroEstante + Prateleira;

    dynamic _verificarLocalizacao =
        await ProcessoApi.LocalizarProcesso(NumeroProcesso, AnoProcesso);

    if (_verificarLocalizacao['tablename'][0]['cod_retorno'] != null &&
        _verificarLocalizacao['tablename'][0]['cod_retorno'] == 1) {
      //O PROCESSO JA FOI ARQUIVADO
      if (_verificarLocalizacao['tablename'][0]['num_prateleira'] != null) {
        EstanteEPrateleiraConsulta =
            _verificarLocalizacao['tablename'][0]['num_prateleira'];

        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('ATENÇAO'),
                  content: Text(
                      "O Processo: ${NumeroProcesso} / ${AnoProcesso} já esta Arquivado na Estante: ${EstanteEPrateleiraConsulta}, tem certeza que deseja alterar para ${EstanteEPrateleira}? "),
                  actions: [
                    TextButton(
                      child: const Text("Não"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                        child: const Text("Sim"),
                        onPressed: () async {
                          ConfirmGuardarProcesso(
                              NumeroProcesso, AnoProcesso, EstanteEPrateleira);
                          Navigator.of(context).pop();
                        }),
                  ],
                ));
      }
      //O PROCESSO NAO FOI ARQUIVADO AINDA
      else {
        ConfirmGuardarProcesso(NumeroProcesso, AnoProcesso, EstanteEPrateleira);
      }
    } else if (_verificarLocalizacao['tablename'][0]['cod_retorno'] != null &&
        _verificarLocalizacao['tablename'][0]['cod_retorno'] != 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('ATENÇAO'),
                content: Text(_verificarLocalizacao['tablename'][0]
                        ['dsc_mensagem_retorno']
                    .toString()),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));

      G_crtNumero_processo.text = "";
      focusNodeAno.requestFocus();
      G_ctrlEstante.text = "";
      //G_ctrlNumero_prateleira.text = "";
      FocusNodeProcesso.requestFocus();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void ConfirmGuardarProcesso(String NumeroProcesso, String AnoProcesso,
      String EstanteEPrateleira) async {
    dynamic _guardarAPI = await ProcessoApi.GuardarProcesso(
        NumeroProcesso, AnoProcesso, EstanteEPrateleira);
    //exibir alerta de sucesso

    if (_guardarAPI['cod_retorno'] == 1) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('ATENÇAO'),
                content: Text(
                    "Processo: ${NumeroProcesso} / ${AnoProcesso} Estante: ${EstanteEPrateleira}  Arquivado com Sucesso "),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));

      G_crtNumero_processo.text = "";

      FocusNodeProcesso.requestFocus();
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('ATENÇAO'),
                content: Text(_guardarAPI['dsc_mensagem_retorno'].toString()),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbranco,
      appBar: AppBar(
        title: Text('Guardar Processos'),
        centerTitle: true,
        backgroundColor: kazulEscuro,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: G_formkey,
            child: Column(
              children: <Widget>[
                //NUMERO DO PROCESSO

                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    focusNode: FocusNodeProcesso,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: ' Numero do Processo',
                      suffixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: IconButton(
                            icon: const Icon(Icons.qr_code_2),
                            onPressed: _ScanearProcessoAno),
                      ),
                    ),
                    controller: G_crtNumero_processo,
                    validator: _valida_NumeroProcesso,
                  ),
                ),

                //NUMERO DA ESTANTE

                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    focusNode: FocusNodeEstantePrateleira,
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Estante/Prateleira',
                      suffixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: IconButton(
                          icon: const Icon(Icons.qr_code_2),
                          onPressed: _ScanearEstantePrateleira,
                        ),
                      ),
                    ),
                    controller: G_ctrlEstante,
                    validator: _valida_estanteEprateleira,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ano do Processo',
                    ),
                    controller: G_ctrlNumero_ano,
                    validator: _valida_AnoProcesso,
                  ),
                ),
                //NUMERO PRATELEIRA

                /*Padding
              (
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField
                (
                  obscureText: false,
                  decoration: InputDecoration
                  (
                    border: OutlineInputBorder(),
                    labelText: 'Prateleira',
                    suffixIcon: Align
                    (
                      widthFactor: 1.0,
                      heightFactor: 1.0,
                    ),
                  ),
                  controller: G_ctrlNumero_prateleira,
                ),
              ),*/

                Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    width: 250,
                    decoration: BoxDecoration(
                        color: kazulEscuro,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton.icon(
                      icon: _isLoading
                          ? CircularProgressIndicator()
                          : Icon(Icons.save),
                      label: Text(
                        _isLoading ? 'Guardando...' : 'Guardar',
                        style: TextStyle(color: kbranco, fontSize: 20),
                      ),
                      onPressed: _GuardarProcessoEstantePrateleira,
                      style: ElevatedButton.styleFrom(
                          primary: kverde, fixedSize: Size(250, 50)),
                    )),
              ],
            )),
      ),
    );
  }
}
