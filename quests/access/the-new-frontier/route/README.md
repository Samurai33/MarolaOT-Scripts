# Planejamento de captura — The New Frontier

Nenhum arquivo CaveBot é permitido neste diretório enquanto o pacote permanecer em M2.

## Estratégia

Cada missão será capturada em segmentos curtos e reversíveis:

```text
ponto seguro → navegação → checkpoint manual → retorno seguro
```

Nunca será criado um arquivo único para executar as dez missões de forma contínua.

## Estrutura futura

```text
route/
├── mission-01/
│   ├── 01-farmine-to-elevator.cfg
│   ├── 02-mountain-passage.cfg
│   └── 03-return-to-ongulf.cfg
├── mission-02/
│   ├── 01-farmine-to-melfar.cfg
│   ├── 02-tree-01-checkpoint.cfg
│   ├── 03-tree-02-checkpoint.cfg
│   ├── 04-tree-03-checkpoint.cfg
│   └── 05-return.cfg
├── mission-03/
├── mission-04/
├── mission-05-travel-only/
├── mission-06/
├── mission-07/
├── mission-08/
├── mission-09/
└── mission-10/
```

## Regras dos segmentos

Cada arquivo futuro deve:

- iniciar em posição documentada;
- possuir label de entrada e de saída;
- terminar antes da ação manual;
- ter rota de retorno ou recuperação;
- manter TargetBot e AttackBot desligados por padrão;
- não usar item de quest;
- não falar palavra de NPC;
- não puxar alavanca de arena;
- não entrar em boss;
- não atravessar prisão automaticamente;
- não iniciar a missão seguinte.

## Classificação das ações

| Tipo | Exemplo | Política |
|---|---|---|
| Navegação | Farmine até elevador | poderá ser capturada |
| Transporte comum | barco/steamship confirmado | checkpoint na primeira validação |
| Uso de objeto | árvore, vinha, porta secreta | manual |
| Diálogo | Ongulf, Melfar, missão 5 | manual |
| Combate comum | criaturas no trajeto | configuração futura separada |
| Boss | Shard of Corruption | manual |
| Arena | Mooh'Tah Master e Isle of Strife | manual |
| Estado forçado | prisão/captura | manual |

## Ordem recomendada de captura M3

1. missão 1 completa por segmentos;
2. missão 2 até cada árvore, sem usar o item;
3. missão 3 até Lazaran;
4. missão 4 até o checkpoint do Shard;
5. somente viagens da missão 5;
6. missão 6 até a entrada da arena;
7. missão 7 até o diálogo/trap;
8. missão 8 somente após validar a prisão no MarolaOT;
9. missão 9 até a posição dos dois jogadores;
10. missão 10 até Ongulf.

## Critério de aceitação de um segmento

- [ ] origem capturada no MarolaOT;
- [ ] destino capturado no MarolaOT;
- [ ] nenhuma coordenada inferida da wiki;
- [ ] dry-run concluído;
- [ ] parser CaveBot aprovado;
- [ ] parada manual visível;
- [ ] retorno documentado;
- [ ] nenhuma ação irreversível executada.
