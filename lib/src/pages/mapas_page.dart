import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/bloc/scans.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;

class MapasPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    /*Para poder validar que el  metodo build que se dispara cada vez que es dibujado 
      Antes que todo se dipara este metodo para que el streamController escuche si tiene datos o no 
    */
    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(

      stream: scansBloc.scansStream,
     
      builder: (BuildContext context , AsyncSnapshot<List<ScanModel>> snapshot){
        if (!snapshot.hasData){
          return Center(child: CircularProgressIndicator());
        }
        
        final scans = snapshot.data;

        if(scans.length == 0 ){
          return Center (child: Text("No hay informacion para mostrar"),);
        }
        else{
          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context , i ) => Dismissible( //Swipe para borrar
              key: UniqueKey(), //Llave unica para un elemento,
              background: Container(color: Colors.red),
              onDismissed: (direction)=> scansBloc.borrarScan(scans[i].id),
                child: ListTile(
                leading: Icon(Icons.cloud_queue,color: Theme.of(context).primaryColor,), 
                title: Text(scans[i].valor),
                subtitle: Text('ID: ${scans[i].id}'),
                trailing: Icon(Icons.keyboard_arrow_right,color: Colors.grey,),
                //Una funcion anonima para hacer el metodo cuando sea tap , no de un solo llamar la funcion
                onTap: ()=> utils.abrirScan(scans[i],context),
              ),
            ),
            );
        }


      },
      );
  }
}