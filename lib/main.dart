import 'package:flutter/material.dart';
import 'package:flutter_treino/routes.dart'; // Importa arquivo de rotas

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
 Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Favorito',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,

      // Configurações de Rota:
      initialRoute: Routes.home, // Diz que a primeira rota a ser aberta é a 'home'
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

