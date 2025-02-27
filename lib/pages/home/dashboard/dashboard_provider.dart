import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/repositories/movimiento_api_repository.dart';
import 'package:finanzaspersonales/repositories/movimiento_repository.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  final MovimientoRepository _movimientoRepository = MovimientoRepository();
  //final MovimientoApiRepository _movimientoRepository = MovimientoApiRepository();

  double _saldo = 0.0;
  List<Movimiento> _ultimosMovimientos = [];

  double get saldo => _saldo;
  List<Movimiento> get ultimosMovimientos => _ultimosMovimientos;

  DashboardProvider() {
    cargarDashboard();
  }

  Future<void> cargarDashboard() async {
    // Obtener ingresos y gastos
    final ingresos = await _movimientoRepository.obtenerIngresos();
    final gastos = await _movimientoRepository.obtenerGastos();

    // Calcular saldo
    double totalIngresos = ingresos.fold(0, (sum, item) => sum + item.cantidad);
    double totalGastos = gastos.fold(0, (sum, item) => sum + item.cantidad);
    _saldo = totalIngresos - totalGastos;

    // Obtener los últimos movimientos, ordenados por fecha (asumiendo que la fecha es un string que sigue un formato YYYY-MM-DD)
    final movimientos = [...ingresos, ...gastos];
    movimientos.sort((a, b) => b.fecha.compareTo(a.fecha));

    _ultimosMovimientos = movimientos.take(5).toList(); // Mostrar las últimas 5 operaciones

    notifyListeners();  // Notificar a los widgets que los datos han cambiado
  }
}
