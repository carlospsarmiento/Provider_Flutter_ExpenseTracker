import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/pages/nuevo_movimiento/nuevo_movimiento_page.dart';
import 'package:finanzaspersonales/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'movimientos_provider.dart';
import 'package:intl/intl.dart';

class MovimientosPage extends StatelessWidget {

  const MovimientosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Todos los Movimientos',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(defaultSpacing),
        child: Consumer<MovimientosProvider>(
          builder: (context, provider, child) {
            return provider.todosMovimientos.isNotEmpty
                ? ListView.builder(
              itemCount: provider.todosMovimientos.length,
              itemBuilder: (context, index) {
                final movimiento = provider.todosMovimientos[index];
                return _buildMovimientoTile(movimiento, context, provider);
              },
            )
                : Center(child: Text('No hay movimientos registrados.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NuevoMovimientoPage()),
            );
          },
          backgroundColor: primaryDark,
          child: Icon(
              Icons.add,
              color: Colors.white,
          ),
      ),
    );
  }

  Widget _buildMovimientoTile(Movimiento movimiento, BuildContext context, MovimientosProvider provider) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(movimiento.fecha));
    return Dismissible(
      key: Key(movimiento.id.toString()), // Asegúrate de que el ID sea único
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        provider.eliminarMovimiento(movimiento.id); // Llama al método de eliminación en el provider
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Movimiento eliminado')),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevoMovimientoPage(movimientoId: movimiento.id)),
          );
        },
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 5),
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              movimiento.tipo == 'ingreso' ? Icons.arrow_downward : Icons.arrow_upward,
              color: movimiento.tipo == 'ingreso' ? Colors.green : Colors.red,
            ),
            title: Text(movimiento.descripcion),
            subtitle: Text('Fecha: $formattedDate'), // Mostrar la fecha formateada
            trailing: Text(
              '\$ ${movimiento.cantidad.toStringAsFixed(2)}',
              style: TextStyle(
                color: movimiento.tipo == 'ingreso' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: fontSizeBody
              ),
            ),
          ),
        ),
      ),
    );
  }
}