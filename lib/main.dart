import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:async/async.dart';





const requestHgFinance = "https://api.hgbrasil.com/finance/quotations?key=7e6dbf9a";

String dropdownValueFrom = 'Real';
String dropdownValueTo = "Dolar";



void main() async{
  await getDataHgFinnance();


  runApp(MaterialApp(


    title: "Moeda Fácil",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  BannerAd myBanner;

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[],
  );

  void startBanner() {
    myBanner = BannerAd(
      adUnitId:BannerAd.testAdUnitId, //Verdadeiro "ca-app-pub-9758630671935566/3922981029", //BannerAd.testAdUnitId
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.opened) {
          // MobileAdEvent.opened
          // MobileAdEvent.clicked
          // MobileAdEvent.closed
          // MobileAdEvent.failedToLoad
          // MobileAdEvent.impression
          // MobileAdEvent.leftApplication
        }
        print("BannerAd event is $event");
      },
    );
  }

  void displayBanner() {
    myBanner
      ..load()
      ..show(
        anchorOffset: 350.0,
        anchorType: AnchorType.top,
      );
  }

  @override
  void dispose() {
    myBanner?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-3940256099942544~3347511713");//Verdadeiro"ca-app-pub-9758630671935566~7638864758");

   startBanner();
    displayBanner();
  }


  double dolar;
  double euro;
  double libra;

  TextEditingController TextDe =  TextEditingController();
  TextEditingController TextPara = TextEditingController();

 ///items: <String>['Real', 'Dolar', 'Euro', 'Libra']

  String _TextFrom = dropdownValueFrom;
  String _TextTo = dropdownValueTo;


  _MoedaDe(String string){
    double M_De = double.parse(TextDe.text);

    switch (_TextFrom){
      case 'Real':
        switch(_TextTo){
          case 'Dolar':
            TextPara.text = (M_De/dolar).toStringAsFixed(2);
            break;
          case 'Euro':
            TextPara.text = (M_De/euro).toStringAsFixed(2);
            break;
          case 'Libra':
            TextPara.text = (M_De/libra).toStringAsFixed(2);
            break;
        }
        break;
      case 'Dolar':
        switch(_TextTo){
          case 'Real':
            TextPara.text = (M_De*dolar).toStringAsFixed(2);
            break;
          case 'Euro':
            TextPara.text = ((M_De/euro)*dolar).toStringAsFixed(2);
            break;
          case 'Libra':
            TextPara.text = ((M_De/libra)*dolar).toStringAsFixed(2);
            break;
        }
        break;
      case 'Euro':
        switch(_TextTo){
          case 'Real':
            TextPara.text = (M_De*euro).toStringAsFixed(2);
            break;
          case 'Dolar':
            TextPara.text = ((M_De/dolar)*euro).toStringAsFixed(2);
            break;
          case 'Libra':
            TextPara.text = ((M_De/libra)*euro).toStringAsFixed(2);
            break;
        }
        break;
      case 'Libra':
        switch(_TextTo){
          case 'Real':
            TextPara.text = (M_De*libra).toStringAsFixed(2);
            break;
          case 'Dolar':
            TextPara.text = ((M_De/dolar)*libra).toStringAsFixed(2);
            break;
          case 'Euro':
            TextPara.text = ((M_De/euro)*libra).toStringAsFixed(2);
            break;
        }
        break;
    }
  }



  _MoedaPara(String string){
    double M_Para = double.parse(TextPara.text);
    ///TextDe.text = (dolar*M_Para).toStringAsFixed(2);

    switch (_TextTo){
      case 'Real':
        switch(_TextFrom){
          case 'Dolar':
            TextDe.text = (M_Para/dolar).toStringAsFixed(2);
            break;
          case 'Euro':
            TextDe.text = (M_Para/euro).toStringAsFixed(2);
            break;
          case 'Libra':
            TextDe.text = (M_Para/libra).toStringAsFixed(2);
            break;
        }
        break;
      case 'Dolar':
        switch(_TextFrom){
          case 'Real':
            TextDe.text = (M_Para*dolar).toStringAsFixed(2);
            break;
          case 'Euro':
            TextDe.text = ((M_Para/euro)*dolar).toStringAsFixed(2);
            break;
          case 'Libra':
            TextDe.text = ((M_Para/libra)*dolar).toStringAsFixed(2);
            break;
        }
        break;
      case 'Euro':
        switch(_TextFrom){
          case 'Real':
            TextDe.text = (M_Para*euro).toStringAsFixed(2);
            break;
          case 'Dolar':
            TextDe.text = ((M_Para/dolar)*euro).toStringAsFixed(2);
            break;
          case 'Libra':
            TextDe.text = ((M_Para/libra)*euro).toStringAsFixed(2);
            break;
        }
        break;
      case 'Libra':
        switch(_TextFrom){
          case 'Real':
            TextDe.text = (M_Para*libra).toStringAsFixed(2);
            break;
          case 'Dolar':
            TextDe.text = ((M_Para/dolar)*libra).toStringAsFixed(2);
            break;
          case 'Euro':
            TextDe.text = ((M_Para/euro)*libra).toStringAsFixed(2);
            break;
        }
        break;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Moeda Fácil - Conversor de Moeda",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Map>(
        future: getDataHgFinnance(),
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text("Carregando Dados...",style: TextStyle(color: Colors.blueAccent,fontSize: 20),),
              );
            default:
              if(snapshot.hasError){
                return Center(
                  child: Text("Erro ao carregar dados",style: TextStyle(color: Colors.blueAccent,fontSize: 20),),

                );
              }else{
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];
                return SingleChildScrollView(

                  padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("De:",style: TextStyle(fontSize: 16),),
                            DropdownButton<String>(
                          value: dropdownValueFrom,
                          icon: Icon(Icons.arrow_downward,color: Colors.blueAccent,),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              color: Colors.blueAccent
                          ),
                          underline: Container(
                            height: 2,
                            color: Colors.blueAccent,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueFrom = newValue;
                              String help = _TextFrom;
                              _TextFrom = newValue;
                              if(_TextTo == _TextFrom){
                                _TextTo = help;
                                dropdownValueFrom = dropdownValueTo;
                                dropdownValueTo = help;
                              }
                              TextDe.text = "";
                              TextPara.text = "";

                            });
                          },
                          items: <String>['Real', 'Dolar', 'Euro', 'Libra']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style: TextStyle(fontSize: 16),),

                            );

                          })
                              .toList(),
                        ),
                            Text("Para:",style: TextStyle(fontSize: 16),),
                            DropdownButton<String>(
                              value: dropdownValueTo,
                              icon: Icon(Icons.arrow_downward,color: Colors.blueAccent,),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.blueAccent
                              ),
                              underline: Container(
                                height: 2,
                                color: Colors.blueAccent,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValueTo = newValue;

                                  String help = _TextTo;
                                  _TextTo = newValue;
                                  if(_TextTo == _TextFrom){
                                    _TextFrom = help;
                                    dropdownValueTo = dropdownValueFrom;
                                    dropdownValueFrom = help;
                                  }
                                  TextDe.text = "";
                                  TextPara.text = "";
                                });
                              },
                              items: <String>['Real', 'Dolar', 'Euro', 'Libra']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(fontSize: 16),),
                                );
                              })
                                  .toList(),
                            ),
                          ],
                        ),
                        Divider(),
                        buildTextfild(_TextFrom,TextDe,_MoedaDe),
                        Divider(),
                        buildTextfild(_TextTo,TextPara,_MoedaPara),
                      ],
                    ),




                );
              }
          }
        },

      ),
    );
  }
}

Future<Map> getDataHgFinnance() async{
  http.Response response = await http.get(requestHgFinance);
  return json.decode(response.body);
}

Widget buildTextfild(String label,TextEditingController controller,Function function){
  return TextField(
      onChanged: function,
      keyboardType: TextInputType.number,
      controller: controller,
      style: TextStyle(color: Colors.blueAccent),
      decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.blueAccent,fontSize: 18),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
      ),
  ));

}




