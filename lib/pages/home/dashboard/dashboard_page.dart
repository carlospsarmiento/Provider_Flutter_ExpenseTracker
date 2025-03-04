import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/pages/nuevo_movimiento/nuevo_movimiento_page.dart';
import 'package:finanzaspersonales/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_provider.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {

  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _widgetAppBar(context),
      body: SafeArea(
        child: Container(
          child: Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.all(defaultSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: defaultSpacing),
                    _buildSaldoCard(context, provider.saldo),
                    SizedBox(height: defaultSpacing * 2),
                    Row(
                      spacing: defaultSpacing,
                      children: [
                        _widgetSubtotal(context,"ingreso", provider.totalIngresos),
                        _widgetSubtotal(context,"gasto", provider.totalGastos),
                      ],
                    ),
                    SizedBox(height: defaultSpacing * 2),
                    Text(
                      'Últimos movimientos',
                      style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: fontSizeHeading
                    )
                    ),
                    SizedBox(height: defaultSpacing),
                    _widgetListLatestMoves(provider)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _widgetListLatestMoves(DashboardProvider provider){
    return Expanded(
      child: provider.ultimosMovimientos.isNotEmpty
          ? ListView.builder(
        itemCount: provider.ultimosMovimientos.length,
        itemBuilder: (context, index) {
          final movimiento = provider.ultimosMovimientos[index];
          return _buildMovimientoTile(movimiento);
        },
      )
      : Center(child: Text('No hay movimientos recientes', style: TextStyle(color: Colors.white))),
    );
  }

  PreferredSizeWidget _widgetAppBar(BuildContext context){
    return AppBar(
      title: Text('Control de Gastos'),
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
    );
  }

  Widget _widgetSubtotal(BuildContext context, String tipo, double subtotal){
    return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: tipo == "ingreso"? primaryDark : accent,
                  borderRadius: BorderRadius.all(Radius.circular(defaultRadius))
                ),
                padding: const EdgeInsets.all(defaultSpacing),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              tipo == "ingreso"?"Ingresos":"Gastos",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                          Text(
                              "S/ $subtotal",
                              style: TextStyle(
                                fontSize: fontSizeHeading,
                                color: Colors.white
                              )
                          )
                        ],
                      ),
                    ),
                    Icon(
                        tipo == "ingreso"? Icons.arrow_downward:Icons.arrow_upward,
                        color: Colors.white,
                    )
                  ],
                ),
              )
      );
  }

  // Widget para mostrar el saldo
  Widget _buildSaldoCard(BuildContext context, double saldo) {
    return Center(
      child: Column(
        children: [
          Text(
              "S/ ${saldo.toStringAsFixed(2)}",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: fontSizeHeading
                  )
          ),
          Text(
              "Saldo actual",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
          )
        ],
      ),
    );
  }

  // Widget para cada movimiento
  Widget _buildMovimientoTile(Movimiento movimiento) {
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
            fontSize: fontSizeBody
          ),
        ),
      ),
    );
  }
}