import 'dart:convert';
import 'package:flutter/services.dart'; // Necessário para acessar os assets
import '../model/team.dart';

class TeamsRepository {
  final String assetPath;

  TeamsRepository({this.assetPath = 'assets/data/teams.json'});

  Future<List<Team>> load() async {
    // 1. Carrega o conteúdo do arquivo JSON como uma String
    final jsonStr = await rootBundle.loadString(assetPath);

    // 2. Converte a String JSON em uma Lista dinâmica do Dart
    final list = jsonDecode(jsonStr) as List;

    // 3. Mapeia cada item da lista para um objeto Team
    return list
        .map((e) => Team.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}