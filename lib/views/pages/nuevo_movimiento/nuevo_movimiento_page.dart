import 'package:finanzaspersonales/model/movimiento.dart';
import 'package:finanzaspersonales/views/pages/nuevo_movimiento/nuevo_movimiento_provider.dart';
import 'package:finanzaspersonales/repositories/movimiento_repository.dart';
import 'package:finanzaspersonales/util/constants.dart';
import 'package:finanzaspersonales/util/date_helper.dart';
import 'package:finanzaspersonales/views/widgets/custom_widget_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NuevoMovimientoPage extends StatefulWidget {
  final int? movimientoId;

  const NuevoMovimientoPage({super.key, this.movimientoId}); // Constructor que acepta un ID de movimiento opcional

  @override
  _NuevoMovimientoPageState createState() => _NuevoMovimientoPageState();
}

class _NuevoMovimientoPageState extends State<NuevoMovimientoPage> {
  final _formKey = GlobalKey<FormState>();
  //String _tipo = 'ingreso';
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  // Definimos un ValueNotifier para el campo _tipo
  ValueNotifier<String> _tipoNotifier = ValueNotifier<String>('ingreso'); // Valor por defecto

  @override
  void initState() {
    super.initState();
    if (widget.movimientoId != null) {
      _cargarMovimiento(widget.movimientoId!);
    } else {
      _limpiarMovimiento();
      // Si es un nuevo movimiento, colocar la fecha actual
      /*
      _fechaController.text = DateHelper.formatearDesdeDatabase(DateTime.now().toIso8601String());
      _descripcionController.clear();
      _montoController.clear();
      _tipo = 'ingreso';
      */
    }
  }

  void _limpiarMovimiento() async{
    final nuevoMovimientoProvider = Provider.of<NuevoMovimientoProvider>(context, listen: false);
    nuevoMovimientoProvider.limpiarMovimiento();
  }

  void _cargarMovimiento(int id) async {
    //final movimientoRepository = MovimientoRepository();
    final nuevoMovimientoProvider = Provider.of<NuevoMovimientoProvider>(context, listen: false);
    try {
      await nuevoMovimientoProvider.cargarMovimiento(id);
      //final movimiento = await nuevoMovimientoProvider.obtenerMovimientoPorId(id);
      /*
      if (movimiento != null) {
        setState(() {
          _descripcionController.text = movimiento.descripcion;
          _montoController.text = movimiento.cantidad.toString();
          _tipo = movimiento.tipo;
          _fechaController.text = DateHelper.formatearDesdeDatabase(movimiento.fecha); // Mostrar fecha formateada
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Movimiento no encontrado')),
        );
        Navigator.pop(context);
      }
      */
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el movimiento: $error')),
      );
    }
  }

  Widget _widgetTextFieldDescription(){
    return TextFormField(
      controller: _descripcionController,
      decoration: InputDecoration(
        labelText: 'Descripción',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese una descripción';
        }
        return null;
      },
    );
  }

  Widget _widgetTextFieldMonto(){
    return TextFormField(
      controller: _montoController,
      decoration: InputDecoration(
        labelText: 'Monto',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese un monto';
        }
        return null;
      },
    );
  }

  Widget _widgetTextFieldFecha(){
    return TextFormField(
      controller: _fechaController,
      decoration: InputDecoration(
        labelText: 'Fecha',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: _selectDate,
        ),
      ),
      readOnly: true, // Evita que el usuario edite el campo directamente
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, seleccione una fecha';
        }
        return null;
      },
    );
  }

  Widget _widgetDropdownTipoMovimiento(){
    return ValueListenableBuilder(
      valueListenable: _tipoNotifier,
      builder: (context, tipo, child){
        return DropdownButtonFormField<String>(
          value: _tipoNotifier.value,
          decoration: InputDecoration(
            labelText: 'Tipo',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: [
            DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
            DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
          ],
          onChanged: (value) {
            /*
            setState(() {
              _tipo = value!;
            });
            */
            _tipoNotifier.value = value!;
          },
        );
      }
    );
  }

  Widget _widgetButtonSave(){
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          _registrarOActualizarMovimiento(context);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(fontSize: 18),
      ),
      child: Text(
        widget.movimientoId == null ?
        'Registrar' : 'Actualizar',
        style: TextStyle(
            color: Colors.white
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgetAppBar(
          title: widget.movimientoId == null ?
          'Registrar Movimiento' : 'Editar Movimiento'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<NuevoMovimientoProvider>(
          builder: (context, provider, child){
            // Aquí se obtienen los valores del movimiento si ya se ha cargado
            final movimiento = provider.movimiento;

            if (movimiento != null) {
              _descripcionController.text = movimiento.descripcion;
              _montoController.text = movimiento.cantidad.toString();
              _tipoNotifier.value = movimiento.tipo;
              _fechaController.text = DateHelper.formatearDesdeDatabase(movimiento.fecha);
            }
            else{
              _descripcionController.clear();
              _montoController.clear();
              _tipoNotifier.value = "ingreso";
              _fechaController.text = DateHelper.formatearDesdeDatabase(DateTime.now().toIso8601String());
            }
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _widgetTextFieldDescription(),
                    SizedBox(height: defaultSpacing),
                    _widgetTextFieldMonto(),
                    SizedBox(height: defaultSpacing),
                    _widgetTextFieldFecha(),
                    SizedBox(height: defaultSpacing),
                    _widgetDropdownTipoMovimiento(),
                    SizedBox(height: defaultSpacing),
                    // Botón de Registro/Actualización
                    SizedBox(
                        width: double.infinity,
                        child: _widgetButtonSave()
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Método para seleccionar una fecha con el date picker
  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        _fechaController.text = DateHelper.formatearDesdeDatabase(selectedDate.toIso8601String());
      });
    }
  }

  void _registrarOActualizarMovimiento(BuildContext context) async {
    final nuevoMovimientoProvider = Provider.of<NuevoMovimientoProvider>(context, listen: false);

    final movimiento = Movimiento(
      id: widget.movimientoId,
      descripcion: _descripcionController.text,
      cantidad: double.tryParse(_montoController.text) ?? 0.0,
      fecha: DateHelper.convertirADatabase(_fechaController.text),
      tipo: _tipoNotifier.value,
    );

    try {
      if (widget.movimientoId == null) {
        await nuevoMovimientoProvider.registrarMovimiento(movimiento);
      } else {
        await nuevoMovimientoProvider.actualizarMovimiento(movimiento);
      }
      Navigator.pop(context, true);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar/actualizar el movimiento: $error')),
      );
    }
  }
}