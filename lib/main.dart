import 'package:finanzaspersonales/pages/home/dashboard/dashboard_provider.dart';
import 'package:finanzaspersonales/pages/home/movimientos/movimientos_provider.dart';
import 'package:finanzaspersonales/pages/nuevo_movimiento/nuevo_movimiento_provider.dart';
import 'package:finanzaspersonales/util/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NuevoMovimientoProvider()),
          ChangeNotifierProxyProvider<NuevoMovimientoProvider,MovimientosProvider>(
              create: (ctx) => MovimientosProvider(),
              update: (ctx, nuevoProvider, movimientosProvider) => movimientosProvider!..loadMovimientos()
          ),
          //ChangeNotifierProvider(create: (context) => MovimientosProvider())
          ChangeNotifierProxyProvider<MovimientosProvider, DashboardProvider>(
            create: (ctx) => DashboardProvider(),
            update: (ctx, movimientosProvider, dashboardProvider){
              dashboardProvider!.cargarDashboard(); // Actualiza los movimientos al cargar
              return dashboardProvider;
            },
          ),
        ],
      child: MaterialApp(
        title: 'Finanzas Personales',
        debugShowCheckedModeBanner: false,
        /*
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.greenAccent
        ),
        */
        initialRoute: AppRoutes.home,
        routes: AppRoutes.routes
      ),
    );
  }
}


/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        colorSchemeSeed: Colors.greenAccent
      ),
      home: const MyHomePage(title: 'Mi primera app con flutter'),
    );
  }
}
*/

/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/