# Planejamento de captura — The New Frontier

Nenhum arquivo CaveBot é permitido neste diretório enquanto o pacote permanecer em M2.

## Referência provisória de coordenadas

As coordenadas editoriais publicadas no TibiaWiki foram organizadas em:

```text
../evidence/tibiawiki-coordinates.json
```

Essas coordenadas servem apenas para:

- localizar aproximadamente o objetivo no mapa;
- planejar a ordem dos segmentos;
- comparar o mapa do MarolaOT com a referência global;
- identificar rapidamente divergências de posição, andar ou acesso.

Uma coordenada do TibiaWiki **não é automaticamente um waypoint válido**. Cada ponto começa com:

```text
pending-marolaot-validation
```

Somente após confirmação presencial no cliente ele poderá receber:

```text
validated-in-marolaot
```

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

- iniciar em posição confirmada no MarolaOT;
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
| Navegação | Farmine até elevador | poderá usar coordenada provisória como destino de inspeção |
| Transporte comum | barco/steamship confirmado | checkpoint na primeira validação |
| Uso de objeto | árvore, vinha, porta secreta | manual |
| Diálogo | Ongulf, Melfar, missão 5 | manual |
| Combate comum | criaturas no trajeto | configuração futura separada |
| Boss | Shard of Corruption | manual |
| Arena | Mooh'Tah Master e Isle of Strife | manual |
| Estado forçado | prisão/captura | manual |

## Ordem recomendada de captura M3

1. validar os pontos gerais de transporte para Farmine;
2. missão 1 completa por segmentos;
3. missão 2 até cada árvore, sem usar o item;
4. missão 3 até Lazaran;
5. missão 4 até o checkpoint do Shard;
6. somente viagens da missão 5;
7. missão 6 até a entrada da arena;
8. missão 7 até o diálogo/trap;
9. missão 8 somente após validar a prisão no MarolaOT;
10. missão 9 até a posição dos dois jogadores;
11. missão 10 até Ongulf.

## Procedimento de validação de coordenada

Para cada ponto do dataset:

1. navegar manualmente até a região;
2. conferir `x`, `y` e `z` no cliente;
3. confirmar que o mapa, objeto ou NPC corresponde à descrição;
4. registrar qualquer deslocamento específico do MarolaOT;
5. atualizar `validationStatus`;
6. somente então usar o ponto como referência de um `.cfg`.

Quando houver divergência, preservar também a coordenada original:

```json
{
  "wikiPosition": { "x": 33062, "y": 31528, "z": 14 },
  "marolaPosition": { "x": 0, "y": 0, "z": 0 },
  "validationStatus": "adjusted-for-marolaot"
}
```

## Critério de aceitação de um segmento

- [ ] origem confirmada no MarolaOT;
- [ ] destino confirmado no MarolaOT;
- [ ] coordenadas usadas estão `validated-in-marolaot` ou `adjusted-for-marolaot`;
- [ ] divergências da TibiaWiki foram documentadas;
- [ ] dry-run concluído;
- [ ] parser CaveBot aprovado;
- [ ] parada manual visível;
- [ ] retorno documentado;
- [ ] nenhuma ação irreversível executada.
