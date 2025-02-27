import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/pages/nuevo_movimiento/nuevo_movimiento_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_provider.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Finanzas Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NuevoMovimientoPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Consumer<DashboardProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Mostrar el saldo actual
                  _buildSaldoCard(provider.saldo),
                  SizedBox(height: 20),
                  // Título para las últimas operaciones
                  Text(
                    'Últimos movimientos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  // Lista de los últimos movimientos
                  Expanded(
                    child: provider.ultimosMovimientos.isNotEmpty
                        ? ListView.builder(
                      itemCount: provider.ultimosMovimientos.length,
                      itemBuilder: (context, index) {
                        final movimiento = provider.ultimosMovimientos[index];
                        return _buildMovimientoTile(movimiento);
                      },
                    )
                        : Center(child: Text('No hay movimientos recientes', style: TextStyle(color: Colors.white))),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget para mostrar el saldo
  Widget _buildSaldoCard(double saldo) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: saldo >= 0 ? Colors.greenAccent : Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Saldo Actual',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              '\$ ${saldo.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para cada movimiento
  Widget _buildMovimientoTile(Movimiento movimiento) {
    // Formatear la fecha
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(movimiento.fecha));

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          movimiento.tipo == 'ingreso' ? Icons.arrow_downward : Icons.arrow_upward,
          color: movimiento.tipo == 'ingreso' ? Colors.green : Colors.red,
        ),
        title: Text(movimiento.descripcion),
        subtitle: Text('Fecha: $formattedDate'), // Usar la fecha formateada
        trailing: Text(
          '\$ ${movimiento.cantidad.toStringAsFixed(2)}',
          style: TextStyle(
            color: movimiento.tipo == 'ingreso' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}