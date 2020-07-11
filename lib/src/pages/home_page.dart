//import 'dart:html';
import 'dart:io' show Platform;
import 'package:barcode_scan/barcode_scan.dart';

import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:qr_reader_app/src/pages/direcciones_page.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;


import 'mapas_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();

   int currentIndex = 0;  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('QR Scanner'),
        actions: <Widget>[
          IconButton (
            icon: Icon(Icons.delete_forever),
            //Sin () por que el 
            onPressed: scansBloc.borrarScanTodos,//(){},
            )
        ]
      ),
      body: _callPage(currentIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: ()=> _scanQR( context ),
        ),
      bottomNavigationBar: _crearBottomNavigationBar(),
    );
  }

  

   _scanQR(BuildContext context) async {
    
     //https://fernando-herrera.com
     //geo:40.67634085948375,-73.85487928828128


    
    dynamic futureString;

    try{

      futureString =  await BarcodeScanner.scan();



    }catch(e){
      futureString = e.toString();
    }

    
    print('Future String: ${futureString.rawContent}');

    if (futureString != null){
      
      final scan = ScanModel(valor : futureString.rawContent);
      scansBloc.agregarScan(scan);     

      //utils.abrirScan(scan,context);

      if(  Platform.isIOS ){
        
        Future.delayed(Duration(microseconds: 750),(){
            utils.abrirScan(scan,context);

        });
      }

    }
    else {
      print ('NULO');
    }
    


  }

 Widget _callPage(int paginaActual) {

    switch(paginaActual){
      case 0 : return MapasPage();
      case 1 : return DireccionesPage();

      default : return MapasPage();
    }

 }

 Widget _crearBottomNavigationBar() {
   return BottomNavigationBar(
     currentIndex: currentIndex,
     onTap: (index){
       setState(() {
         currentIndex = index;
       });

     },
     items: [
       BottomNavigationBarItem(
         icon: Icon(Icons.map),
         title: Text('Mapas')
         ),
         BottomNavigationBarItem(
         icon: Icon(Icons.brightness_5),
         title: Text('Direcciones')
         )
     ],
     );

 }
}