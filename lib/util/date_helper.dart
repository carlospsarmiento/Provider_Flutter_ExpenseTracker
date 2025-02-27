import 'package:intl/intl.dart';

class DateHelper {

  // Método para convertir una fecha de 'dd/MM/yyyy' a 'yyyy-MM-dd'
  static String convertirADatabase(String fecha) {
    final parsedDate = DateFormat('dd/MM/yyyy').parse(fecha);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  // Método para formatear una fecha de 'yyyy-MM-dd' a 'dd/MM/yyyy'
  static String formatearDesdeDatabase(String fecha) {
    final parsedDate = DateFormat('yyyy-MM-dd').parse(fecha);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }
}