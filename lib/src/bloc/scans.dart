import 'dart:async';

import 'package:qr_reader_app/src/bloc/validator.dart';
import 'package:qr_reader_app/src/models/scan_model.dart';
import 'package:qr_reader_app/src/providers/db_provider.dart';

//Se utiliza Mixins para poder hacer las validaciones del archivo validator.dart en este bloc
class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc._internal();

//Factory puede retornar un ScansBloc o otra cualquier otro objeto
  factory ScansBloc(){

    return _singleton;

  }

  ScansBloc._internal(){
    //Obtener todos los scans de la base de datos
    obtenerScans();

  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  dispose(){
    _scansController?.close();
  }

  

  obtenerScans() async{

    _scansController.sink.add( await DBProvider.db.getTodosScans());
    

  }

  agregarScan(ScanModel scan) async{
    
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
    print('sss');

  }

  borrarScan (int id)async{

   await  DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTodos()async {
    await DBProvider.db.deleteAll();
    obtenerScans();
    /*seria lo mismo de la siguiente manera : 
    _scansController.sink.add( await DBProvider.db.getTodosScans());
    */
  }
  
    
    




}

