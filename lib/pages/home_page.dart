import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mercado_cercano/functions/data_fetch.dart';
import 'package:mercado_cercano/pages/background_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<LocationPermission> _serviceEnabled;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _serviceEnabled = checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<LocationPermission>(
          future: _serviceEnabled,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png'),
                  const Text(
                    "La aplicación no pudo iniciarse correctamente",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                  ),
                  TextButton(
                      onPressed: () {
                        _serviceEnabled = checkLocationPermission();
                        setState(() {});
                      },
                      child: const Text('Volver a intentar'))
                ],
              );
            }
            if (!snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png'),
                  const Text(
                    "Cargando información",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const CircularProgressIndicator(),
                ],
              );
            }

            if (snapshot.data! != LocationPermission.denied &&
                snapshot.data! != LocationPermission.deniedForever) {
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const BackgroundPage();
                  })));

              return const Text('Servicios habilitados');
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png'),
                const Text(
                  "Servicios de ubicación no habilitados",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                  width: MediaQuery.of(context).size.width,
                ),
                TextButton(
                    onPressed: () {
                      _serviceEnabled = checkLocationPermission();
                      setState(() {});
                    },
                    child: const Text('Volver a cargar'))
              ],
            );
          }),
    );
  }
}
