import 'package:flutter/material.dart';
import 'package:mercado_cercano/functions/data_fetch.dart';
import 'package:mercado_cercano/pages/background_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getData(context, []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
          future: _data,
          builder: (context, snapshot) {
            List<Widget> children = [Container()];
            if (snapshot.hasError) {
              children = [
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
                    onPressed: handleRefresh,
                    child: const Text('Volver a cargar'))
              ];
            }
            if (!snapshot.hasData) {
              children = [
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
              ];
            }
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return BackgroundPage(
                      initialData: snapshot.data!,
                    );
                  })));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            );
          }),
    );
  }

  handleRefresh() {
    getData(context, []);
    setState(() {});
  }
}
