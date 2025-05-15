import 'package:control_gastos_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'providers/gasto_provider.dart';
import 'screens/add_gasto_screen.dart';

void main() {
  initializeDateFormatting('es_ES', null).then((_) =>
    runApp(
      ChangeNotifierProvider(
        create: (_) => GastoProvider()..cargarGastos(),
        child: const MyApp(),
      )
  ));
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true
      ),
      home: const SplashScreen(),
      routes: {
        '/add': (context) => const AddGastoScreen()
      },
    );
  }
  
}
