// Importe as telas que você acabou de criar
import 'package:flutter_treino/screens/home/home_screen.dart';
import 'package:flutter_treino/screens/select/select_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  // "Apelidos" para nossas rotas
  static const String home = '/';
  static const String select = '/select';

  static Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case home:
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case select:
      return MaterialPageRoute(builder: (_) => SelectScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('Rota não encontrada! ${settings.name}')),
        ),
      );
  }
}
}