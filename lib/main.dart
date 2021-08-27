import 'dart:async';
//import 'dart:convert';
import 'package:http/http.dart';
import 'package:practica/Item.dart';
import 'REST.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'dart:io';
import 'ws.dart';
import 'wsq.dart';
import 'globals.dart';
import 'package:darq/darq.dart';
import 'Item.dart';

void main() => runApp(MyApp());



class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);


  @override
  _MyAppState createState() => _MyAppState();


}

class _MyAppState extends State<MyApp> {
  TextEditingController controller  = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  List<TextEditingController> _controllers = [];

  late Future<List<Product>> futureProduct;
  String myState = ' ';

  @override
  void initState() {
    G.min=0;
    G.max=0;
    setState(() {});
    super.initState();
    if (myState == ' ') {
      futureProduct=auth();
      myState = '*';
    }

  }

  @override
  void dispose() {
   // controller.dispose();
   // controller1.dispose();
   // controller2.dispose();
    _controllers.forEach((TextEditingController){TextEditingController.dispose();});
    super.dispose();
  }

  Future<List<Product>> auth() async {

    bool result = await Wsq.autentificate();
    if (result = false)
    {
      print('>>>>>>>>>>>>>>>>>>>> ${Wsq.message}');
    }
    return getData();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    _searchResult.clear();
    if(G.retval.isNotEmpty){G.retval.clear();}
    setState(() {futureProduct=getData();});
   // return getData();
  }

  Future<List<Product>> getData() async {
    Ws ws = Ws();
    if (!await ws.putItem(
        G.srequest, {"min": G.min, "max": G.max} ,processResp: (json) {
      if (json.containsKey('rows') /*&& (json['rows'].runtimeType == List)*/) {
        json['rows'].forEach((jj) {

          G.retval.add(Product.fromJson(jj));
        });
      }
      else {
        throw('Lipseste elementul date sau nu are tip corespunzator!');
      }
    })) {
      print('>>>>>>>>>>>>>>>>>>>> ${ws.message}');
    }

    return G.retval;

  }


  Future<void> sendData() async {
    Ws ws = Ws();
    if (!await ws.putItem(
        G.backservice, {'out': {'filter2': {'data': G.itedoc.toMap()}}}, reqMode: 'service',
        processResp: (json) {
      if (!json["success"] ) {
         throw('Lipseste elementul date sau nu are tip corespunzator!');
      }
      else {
        return true;
      }
    })) {
      print('>>>>>>>>>>>>>>>>>>>> ${ws.message}');
    }


  }

 /* Widget FutureBuild(){

    return FutureBuilder<List<Product>>(
        future: futureProduct,
        builder: (context, snapshot){
          if (ConnectionState.active != null && !snapshot.hasData) {
            return Center(child: new CircularProgressIndicator());
          }
          if (ConnectionState.done != null && snapshot.hasError) {
            return Center(child: Text('error'));
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(margin: EdgeInsets.all(15),
                  color: Colors.green[50],
                  child: ExpansionTile(
                      leading: Text("ID: ${snapshot.data![index].MTRL}"),
                      trailing: Text("Company: ${snapshot.data![index].COMPANY}"),
                      title: Text("${snapshot.data![index].NAME}",textAlign: TextAlign.center,),
                      children:<Widget>[
                        ListTile(
                          title: Text("Price: ${snapshot.data![index].PRICEW} "),
                        ),
                        ListTile(
                          title: Text("Code: ${snapshot.data![index].CODE} "),
                        ),
                        ListTile(
                          title: Text("Barcodes: ${snapshot.data![index].CODE1} "),
                        ),
                        ListTile(
                            title: TextField(
                                controller: controller1,
                                onChanged: (_){
                                  setState(() {});},
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Quantity',
                                  hintText: '',
                                )
                            )
                        ),
                      ]
                  ),
                );
              }
          );
        }
    );
  }*/



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: Scaffold(
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body:
        /**************/
        new Column( 
            children: <Widget>[
              new Container(
                color: Colors.green[400],
                child: new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Card(
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: controller,
                        decoration: new InputDecoration(
                            hintText: 'Search', border: InputBorder.none),
                        onChanged:onSearchTextChanged
                      ),
                      trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                        controller.clear();
                        onSearchTextChanged('');
                      },),
                    ),
                  ),
                ),
              ),//SEARCH BAR
              Container(
                  alignment: Alignment.bottomCenter, // align the row
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                              controller: controller1,
                              onChanged: (_){
                                setState(() {G.min=double.parse(controller1.text);});},
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Minimum Price',
                                hintText: '',
                              )
                          )
                      ),
                      Flexible(
                          child: TextField(
                              controller: controller2,
                              onChanged: (_){
                                setState(() {G.max=double.parse(controller2.text);});},
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Maximum Price',
                                hintText: '',
                              )
                          )
                      ),
                      Flexible(
                          child: FlatButton(
                            child:Text("apply"),
                            color: Colors.green[400],
                            onPressed: () {
                               G.retval.clear();
                               G.groups.clear();
                               G.item.clear();
                               _controllers.clear();
                              futureProduct = getData();
                              setState(() {
                                 //FutureBuild();
                              });
                            },
                          )
                      )
                    ],
                  )
              ),//USER PARAMETERS



              new Expanded(
                child: RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: FutureBuilder<List<Product>>(
                        future: futureProduct,
                        builder: (context, snapshot){
                          if (ConnectionState.active != null && !snapshot.hasData) {
                            return Center(child: new CircularProgressIndicator());
                          }
                          if (ConnectionState.done != null && snapshot.hasError) {
                            return Center(child: Text('error'));
                          }
                         G.groups=G.retval.distinct((d)=> d.COUNTRY).toList();
                    return new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: G.groups.length,
                      itemBuilder: (context, grIndex)
                          {

                            return new Card(
                                color: Colors.green[200],
                                child: ExpansionTile(

                                  title: Text("${G.groups[grIndex].NAME}"),
                                       children:
                                          [ new ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            _controllers.add(new TextEditingController());
                                            if(G.groups[grIndex].COUNTRY==snapshot.data![index].COUNTRY){
                                                return new Card(margin: EdgeInsets.all(15),
                                                    color: Colors.green[50],
                                                    child: ExpansionTile(
                                                        leading: Text("ID: ${snapshot.data![index].MTRL}"),
                                                        trailing: Text("Company: ${snapshot.data![index].COMPANY}"),
                                                        title: Text("${snapshot.data![index].NAME_1}", textAlign: TextAlign.center,),
                                                        children: <Widget>
                                                        [
                                                          ListTile(title: Text("Price: ${snapshot.data![index].PRICEW} "),),
                                                          ListTile(title: Text("Code: ${snapshot.data![index].CODE} "),),
                                                          ListTile(title: Text("Barcodes: ${snapshot.data![index].CODE1} "),),
                                                          ListTile(title: TextField(
                                                              controller: _controllers[index],
                                                              onChanged: (_) {
                                                                setState(() {G.item.add(new Item(mtrl: snapshot.data![index].MTRL, QTY1: int.parse(_controllers[index].text)));});
                                                              },
                                                              decoration: InputDecoration(
                                                                border: OutlineInputBorder(),
                                                                labelText: 'Quantity',
                                                                hintText: '',
                                                              )
                                                          )),
                                                        ]
                                                    )
                                                );
                                            }else{return SizedBox.shrink();}
                                          }
                                      )]
                                )
                            );
                          }
                    );
                        }
                    )

                ),
              ),
          new Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                    onPressed: () {sendData();},
                child: const Text('Print', style: TextStyle(fontSize: 20)),
                color: Colors.green[600],
                textColor: Colors.black87,
              ),
              )
            ]
        ),
      ),
    );
  }



onSearchTextChanged(String text) async {
    _searchResult.clear();

    if (text.isEmpty) {

      setState(() {});
    }

    G.retval.forEach((userDetail) {
      if (userDetail.COMPANY.toLowerCase().contains(text.toLowerCase())
          || userDetail.CODE.toLowerCase().contains(text.toLowerCase())
          || userDetail.NAME_1.toLowerCase().contains(text.toLowerCase())
          || userDetail.PRICEW.toLowerCase().contains(text.toLowerCase())
          || userDetail.CODE1.toLowerCase().contains(text.toLowerCase())
          || userDetail.MTRL.toLowerCase().contains(text.toLowerCase())
          || userDetail.NAME.toLowerCase().contains(text.toLowerCase()))
          {
            _searchResult.add(userDetail);
          }

    });
    if(_searchResult.isNotEmpty)
      {
        futureProduct=getSearchRes();
      }


    setState(() {});
  }
  Future<List<Product>> getSearchRes() async {return _searchResult;}


}

List<Product> _searchResult=[];




