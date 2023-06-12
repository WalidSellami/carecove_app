import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_final/modules/pharmacist/mapScreen/SelectPlaceScreen.dart';
import 'package:project_final/shared/cubit/appCubit/Cubit.dart';
import 'package:project_final/shared/cubit/appCubit/States.dart';
import 'package:project_final/shared/cubit/checkCubit/Cubit.dart';
import 'package:project_final/shared/cubit/checkCubit/States.dart';
import 'package:project_final/shared/cubit/themeCubit/Cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {


  var searchController = TextEditingController();


  @override
  void initState() {
    if(CheckCubit.get(context).hasInternet) {
      AppCubit.get(context).clearAll();
      AppCubit.get(context).searchPlace(AppCubit.get(context).pharmacyProfile?.pharmacy?.localAddress , context);
    }

    // try {
    //   AppCubit.get(context).searchPlace(AppCubit.get(context).pharmacyProfile?.pharmacy?.name , context);
    // } catch(error) {
    //   AppCubit.get(context).searchPlace(AppCubit.get(context).pharmacyProfile?.pharmacy?.localAddress , context);
    // }

    searchController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFab = MediaQuery.of(context).viewInsets.bottom == 0;
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var cubit = AppCubit.get(context);

            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: (checkCubit.hasInternet) ? Stack(
                children: [
                  FlutterMap(
                    mapController: AppCubit.get(context).mapController,
                    options: MapOptions(
                      onTap: (position , latLng) async {
                        cubit.changeTap(latLng);
                        cubit.getPlaceDetails(latitude: latLng.latitude, longitude: latLng.longitude);
                      },
                      center: cubit.point,
                      zoom: 10,
                      minZoom: 5,
                      maxZoom: 17,
                    ),
                    nonRotatedChildren: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 100.0,
                            height: 100.0,
                            point: cubit.point,
                            builder: (context) => const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                          if(cubit.point2 != LatLng(0 , 0))
                            Marker(
                              width: 100.0,
                              height: 100.0,
                              point: cubit.point2,
                              builder: (context) => Icon(
                                Icons.location_on,
                                color: Colors.blue.shade700,
                                size: 40.0,
                              ),
                            ),
                        ],
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: cubit.points,
                            color: Colors.deepPurpleAccent,
                            strokeWidth: 2.5,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search for location',
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                              ),
                              suffixIcon: (searchController.text.isNotEmpty) ?
                              IconButton(
                                onPressed: (){
                                  searchController.text = '';
                                  cubit.clearAll();
                                },
                                icon: const Icon(
                                  Icons.close,
                                ),
                              ) : null,
                              contentPadding: const EdgeInsets.all(16.0),
                            ),
                            onFieldSubmitted: (value){
                              cubit.searchPlace(value , context);
                            },
                          ),
                        ),
                        if(cubit.placeName != '')
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Informations:',
                                        style: TextStyle(
                                          fontSize: 16.5,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: (){
                                          AppCubit.get(context).clear();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: ThemeCubit.get(context).isDark ? Colors.grey.shade800 :  Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    cubit.placeName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16.5,
                                      height: 1.4,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        if((AppCubit.get(context).point2 != LatLng(0, 0)) && (AppCubit.get(context).directionData != null))
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'By Car:',
                                        style: TextStyle(
                                          fontSize: 16.5,
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: (){
                                          cubit.clearAll();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                            color: ThemeCubit.get(context).isDark ? Colors.grey.shade800 :  Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: const Icon(
                                            Icons.close,

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ((cubit.directionData?.features[0].properties?.segments[0].distance ?? 0) ~/ 1000 != 0) ?
                                      Text(
                                        '${((cubit.directionData?.features[0].properties?.segments[0].distance ?? 0) / 1000).round()} km',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16.5,
                                          height: 1.4,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ) : Text(
                                        '${(cubit.directionData?.features[0].properties?.segments[0].distance ?? 0).round()} m',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16.5,
                                          height: 1.4,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ((cubit.directionData?.features[0].properties?.segments[0].duration ?? 0) ~/ 3600 != 0) ?
                                      Text(
                                        '${((cubit.directionData?.features[0].properties?.segments[0].duration ?? 0) / 3600).round()} H',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16.5,
                                          height: 1.4,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ) : (((cubit.directionData?.features[0].properties?.segments[0].duration ?? 0) ~/ 60 != 0) ?
                                      Text(
                                        '${((cubit.directionData?.features[0].properties?.segments[0].duration ?? 0) / 60).round()} Min',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16.5,
                                          height: 1.4,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ) : Text(
                                        '${(cubit.directionData?.features[0].properties?.segments[0].duration ?? 0)} Sec',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16.5,
                                          height: 1.4,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ) : const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No Internet',
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Icon(EvaIcons.wifiOffOutline),
                  ],
                ),
              ),
              floatingActionButton:((cubit.placeName == '') && (cubit.point2 == LatLng(0, 0)) && checkCubit.hasInternet) ?
              Visibility(
                visible: isFab,
                child: SizedBox(
                  height: 55.0,
                  width: 60.0,
                  child: FloatingActionButton.extended(
                    backgroundColor: ThemeCubit.get(context).isDark ?  HexColor('158b96') : HexColor('b3d8ff'),
                    isExtended: false,
                    onPressed: () {
                      AppCubit.get(context).clear();
                      Navigator.of(context).push(_createSelectPlaceRoute());
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    icon:Icon(
                      Icons.directions,
                      color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                    ),
                    label: const Text('',),
                  ),
                ),
              ) : null,
            );
          },
        );
      },
    );
  }
}


Route _createSelectPlaceRoute() {

  return PageRouteBuilder(
      pageBuilder: (context , animation , secondaryAnimation) => const SelectPlaceScreen(),
      transitionsBuilder: (context , animation , secondaryAnimation , child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween = Tween(begin: begin , end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
  );

}

