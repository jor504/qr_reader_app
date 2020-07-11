import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/models/scan_model.dart'; 
import 'package:flutter_map/flutter_map.dart';

class MapaPage extends StatefulWidget {
  

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'mapbox/streets-v11';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title : Text('Coordenadas QR'),
        actions : <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              map.move(scan.getLatLng(), 15.0);

            },
            )
        ]
      ),
      body: _crearFullterMap(scan),
      floatingActionButton: _crearFloatingActionButton(context),
    );
  }

 Widget _crearFullterMap(ScanModel scan) {
   return FlutterMap(
     mapController: map,
     options : MapOptions(
      center: scan.getLatLng(),
      zoom: 16.5
     ),
     layers: [
       _crearMapa(),
       _crearMarcadores(scan)
     ],
   );

  }

   _crearMapa() {

     /*

Estilos de mapa
mapbox/streets-v11
mapbox/outdoors-v11
mapbox/light-v10
mapbox/dark-v10
mapbox/satellite-v9
mapbox/satellite-streets-v11*/

    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/styles/v1/'
                     '$tipoMapa'+'/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
        additionalOptions: {
        'accessToken':'pk.eyJ1Ijoiam9yNTA0IiwiYSI6ImNrY2k0cHAyODA2ZGoycW81ejM4MW1ubTkifQ.3k_bf0pUsb4TkziJ4u9F4g',
        'id': 'mapbox.outdoors' //streets,dark,ligth,outdoors,satellite
        }
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child : Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
              size: 60,
              ),
            )
          )
      ]
    );

  }

  Widget _crearFloatingActionButton(BuildContext context) {
   return FloatingActionButton(
        child: Icon(Icons.repeat),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          if (tipoMapa == 'mapbox/streets-v11'){
            tipoMapa = 'mapbox/dark-v10';
          }
          else if (tipoMapa == 'mapbox/dark-v10'){
            tipoMapa = 'mapbox/light-v10';
          }
          else{
            tipoMapa = 'mapbox/streets-v11';
          }

            setState(() {
              
            });

        }
        );

  }
}
