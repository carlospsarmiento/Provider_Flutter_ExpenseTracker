import 'package:finanzaspersonales/pages/home/dashboard/dashboard_page.dart';
import 'package:finanzaspersonales/pages/home/movimientos/movimientos_page.dart';
import 'package:finanzaspersonales/util/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    MovimientosPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Mostrar la pantalla seleccionada
      bottomNavigationBar: _widgetBottomNavigationBar()
    );
  }

  Widget _widgetBottomNavigationBar(){
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          //icon: Icon(Icons.dashboard),
          icon: Image.asset("assets/icons/home.png"),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          //icon: Icon(Icons.attach_money),
          icon: Image.asset("assets/icons/wallet.png"),
          label: 'Movimientos',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      //selectedItemColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: secondaryDark,
      unselectedItemColor: Colors.grey,
      //unselectedItemColor: fontLight,
    );
  }
}