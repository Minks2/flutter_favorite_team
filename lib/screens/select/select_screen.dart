import 'package:flutter_treino/data/teams_repository.dart'; // Importe
import 'package:flutter_treino/data/user_settings_repository.dart'; // Importe
import 'package:flutter_treino/model/team.dart'; // Importe
import 'package:flutter/material.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  // Cria as instâncias dos repositórios
  final userSettingsRepository = UserSettingsRepository();
  final teamsRepository = TeamsRepository();

  late Future<List<Team>> _teamsFuture; // Para carregar a lista apenas uma vez
  List<Team> _allTeams = []; // Para guardar todos os times
  List<Team> _filteredTeams = [];

  @override
  void initState() {
    super.initState();
    _teamsFuture = teamsRepository.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha seu time')),
      body: FutureBuilder<List<Team>>(
        future:
            _teamsFuture, //teamsRepository.load(), // Inicia o carregamento da lista
        builder: (context, snapshot) {
          // Lógica de tratamento dos estados do Future
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar times: ${snapshot.error}'),
            );
          }
          final teams = snapshot.data ?? [];
          if (teams.isEmpty) {
            return const Center(child: Text('Nenhum time encontrado.'));
          }
          if (_allTeams.isEmpty) {
            _allTeams = snapshot.data ?? [];
            _filteredTeams = _allTeams;
          }
          // Mude o itemCount e o acesso ao item no ListView

          // Se tudo deu certo, constrói a lista (próximo passo)
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Buscar time",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      // Atualiza a UI a cada letra digitada
                      _filteredTeams = _allTeams
                          .where(
                            (team) => team.name.toLowerCase().contains(
                              value.toLowerCase(),
                            ),
                          )
                          .toList();
                    });
                  },
                ),
              ),
              Expanded(
                // Faz a lista ocupar o resto do espaço
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: _filteredTeams.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final t = _filteredTeams[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        // Para o item ser clicável
                        onTap: () async {
                          // 1. Salva o time escolhido
                          await userSettingsRepository.setTeam(t);
                          // 2. Volta para a tela anterior
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            // Alinha os itens horizontalmente
                            children: [
                              // ... dentro do children do Row
                              Image.asset(
                                t.logo,
                                width: 56,
                                height: 56,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                // Ocupa o espaço restante
                                child: Text(
                                  t.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
