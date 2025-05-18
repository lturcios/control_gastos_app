import 'package:control_gastos_app/screens/add_gasto_screen.dart';
import 'package:control_gastos_app/screens/consulta_mensual_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gasto.dart';
import '../providers/gasto_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gastoProvider = Provider.of<GastoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis gastos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _ResumenItem(
                      titulo: 'Hoy',
                      monto: gastoProvider.totalDelDia,
                      color: Colors.orange
                    ),
                    _ResumenItem(
                      titulo: 'Mes',
                      monto: gastoProvider.totalMensual,
                      color: Colors.green
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          TextButton.icon(
            icon: const Icon(Icons.calendar_month),
            label: const Text('Consulta mensual'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              )
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConsultaMensualScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: gastoProvider.gastos.isEmpty
            ? const Center(
                child: Text('No hay gastos registrados.'),
              )
            : ListView.builder(
                itemCount: gastoProvider.gastos.length,
                itemBuilder: (context, index) {
                  Gasto gasto = gastoProvider.gastos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,
                        child: switch (gasto.categoria.trim()) {
                          'Alimentos' => Icon(Icons.food_bank),
                          'Transporte' => Icon(Icons.car_rental),
                          'General' => Icon(Icons.question_answer),
                          'Educación' => Icon(Icons.cast_for_education),
                          'Diversión' => Icon(Icons.party_mode),
                          'Salud' => Icon(Icons.health_and_safety),
                          'Otros' => Icon(Icons.question_answer) ,
                          String() => throw UnimplementedError(),
                        },
                      ),
                    title: Text(gasto.descripcion),
                    subtitle: Text(
                      '· ${_formatearFecha(gasto.fecha)}'
                    ),
                    trailing: Text(
                      '- \$${gasto.monto.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16.0
                      ),
                    ), onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddGastoScreen(gastoExistente: gasto,)
                        )
                      );
                    },
                    )
                  );
                }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }
}

class _ResumenItem extends StatelessWidget {
  final String titulo;
  final double monto;
  final Color color;

  const _ResumenItem({
    required this.titulo,
    required this.monto,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          titulo,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color)
        ),
        const SizedBox(height: 6,),
        Text(
          '\$${monto.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ]
    );
  }
}