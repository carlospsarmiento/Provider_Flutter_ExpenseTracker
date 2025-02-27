import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/repositories/movimiento_api_repository.dart';
import 'package:finanzaspersonales/repositories/movimiento_repository.dart';
import 'package:flutter/material.dart';

class MovimientosProvider extends ChangeNotifier {
  final MovimientoRepository _movimientoRepository = MovimientoRepository();
  //final MovimientoApiRepository _movimientoRepository = MovimientoApiRepository();

  List<Movimiento> _movimientos = [];

  MovimientosProvider() {
    loadMovimientos();
  }

  List<Movimiento> get todosMovimientos => _movimientos;

  Future<void> loadMovimientos() async {
    _movimientos = await _movimientoRepository.obtenerMovimientos();
    _movimientos.sort((a, b) => b.fecha.compareTo(a.fecha));
    notifyListeners();
  }

  // Método para eliminar un movimiento
  Future<void> eliminarMovimiento(int? id) async {
    if (id != null) {
      await _movimientoRepository.eliminarMovimiento(id);
      //_movimientos.removeWhere((movimiento) => movimiento.id == id); // Actualiza la lista local
      //notifyListeners(); // Notifica a la UI que los movimientos han cambiado
      loadMovimientos();
    }
  }
}