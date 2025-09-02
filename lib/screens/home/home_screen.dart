import 'package:flutter/material.dart';
import 'package:flutter_treino/data/user_settings_repository.dart'; // Importe
import 'package:flutter_treino/model/team.dart'; // Importe
import 'package:flutter_treino/routes.dart'; //Importe das rotas

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Cria a instancia do repositorio
  final userSettingsRepository = UserSettingsRepository();

  // Variável para armazenar a operação de busca do time.
  // O `Future` representa um valor que estará disponível "no futuro".
  Future<Team?>? _future;

  @override
  void initState() {
    super.initState();
    _reload(); // Carrega o time assim que a tela é iniciada
  }

  void _reload() {
    setState(() {
      _future = userSettingsRepository
          .getTeam(); // Inicia a busca e atualiza o estado
    });
  }

  Future<void> _goSelect() async {
    // Navega para a tela de seleção e ESPERA ela ser fechada
    await Navigator.pushNamed(context, Routes.select);
    // Quando voltar da tela de seleção, recarrega os dados
    _reload();
  }

  Future<void> _removeFavorite() async {
    await userSettingsRepository.clearTeam(); // Limpa o time salvo
    _reload(); // Recarrega a tela para refletir a remoção
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Time Favorito'),
        actions: [
          IconButton(
            tooltip: 'Trocar time',
            icon: const Icon(Icons.swap_horiz),
            onPressed: _goSelect, // Chama nosso método de navegação
          ),
        ],
      ),
      body: FutureBuilder<Team?>(
        future: _future, // Monitora a nossa variável de estado
        builder: (context, snapshot) {
          // 1. Enquanto os dados não chegam, mostre um indicador de progresso
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Quando a operação terminar, pegue os dados
          final team = snapshot.data;

          // 3. Construa a interface principal
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // O Card com a imagem do time virá aqui (Próximo Passo)
                  // ... dentro do children do Column
                  Card(
                    elevation: 2,
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      // Para tornar o Card clicável
                      onTap: _goSelect,
                      child: Stack(
                        // Para sobrepor widgets
                        children: [
                          // A IMAGEM DO TIME
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              team == null
                                  ? 'assets/images/generico.png' // Imagem padrão
                                  : team.logo, // Imagem do time escolhido
                              width: 160,
                              height: 160,
                              fit: BoxFit.contain,
                            ),
                          ),

                          // O BOTÃO DE DELETAR (só aparece se houver um time)
                          if (team != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: _removeFavorite,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  // ... o resto do Column
                  const SizedBox(height: 16),

                  // O texto que muda dependendo se um time foi escolhido ou não
                  Text(
                    team == null
                        ? 'Você ainda não escolheu seu time favorito.\nClique na imagem acima.'
                        : team.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
