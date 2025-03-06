import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/repositories/movimiento_api_repository.dart';
import 'package:finanzaspersonales/repositories/movimiento_repository.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier{

  //final MovimientoRepository _movimientoRepository = MovimientoRepository();
  final MovimientoApiRepository _movimientoRepository = MovimientoApiRepository();

  /// DASHBOARD
  double _saldo = 0;
  double _totalIngresos = 0;
  double _totalGastos = 0;
  List<Movimiento> _ultimosMovimientos = [];

  double get saldo => _saldo;
  double get totalIngresos => _totalIngresos;
  double get totalGastos => _totalGastos;
  List<Movimiento> get ultimosMovimientos => _ultimosMovimientos;

  /// MOVIMIENTOS
  List<Movimiento> _movimientos = [];

  List<Movimiento> get movimientos => _movimientos;

  Future<void> cargarDashboard() async {
    // Obtener ingresos y gastos
    final ingresos = await _movimientoRepository.obtenerIngresos();
    final gastos = await _movimientoRepository.obtenerGastos();

    // Calcular saldo
    _totalIngresos = ingresos.fold(0, (sum, item) => sum + item.cantidad);
    _totalGastos = gastos.fold(0, (sum, item) => sum + item.cantidad);
    _saldo = totalIngresos - totalGastos;

    // Obtener los últimos movimientos, ordenados por fecha (asumiendo que la fecha es un string que sigue un formato YYYY-MM-DD)
    final movimientos = [...ingresos, ...gastos];
    movimientos.sort((a, b) => b.fecha.compareTo(a.fecha));
    _ultimosMovimientos = movimientos.take(5).toList(); // Mostrar las últimas 5 operaciones

    notifyListeners();  // Notificar a los widgets que los datos han cambiado
  }

  Future<void> loadMovimientos() async {
    _movimientos = await _movimientoRepository.obtenerMovimientos();
    _movimientos.sort((a, b) => b.fecha.compareTo(a.fecha));
    notifyListeners();
  }

  Future<void> eliminarMovimiento(int? id) async {
    if (id != null) {
      await _movimientoRepository.eliminarMovimiento(id);
      //_movimientos.removeWhere((movimiento) => movimiento.id == id); // Actualiza la lista local
      //notifyListeners(); // Notifica a la UI que los movimientos han cambiado
      loadMovimientos();
    }
  }
}