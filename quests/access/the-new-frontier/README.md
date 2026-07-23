# The New Frontier — pacote assistido

> **Maturidade:** M2 — referência auditada, deliberadamente não executável.

The New Frontier é o pré-requisito direto da linha que leva à **The Order of the Falcon**. A quest possui dez missões, múltiplas cidades, itens de uso, diálogos sensíveis, arena de sobrevivência, prisão e um torneio para dois jogadores.

Este pacote não contém CaveBot, TargetBot, instalador ou automação de combate. Sua função atual é registrar as fontes, separar as etapas e definir os checkpoints que deverão permanecer manuais.

## Estado atual

| Componente | Estado | Evidência |
|---|---|---|
| Source manifest | M2 | [`source-manifest.json`](source-manifest.json) |
| Source lock | Auditado | [`source-lock.json`](source-lock.json) |
| Quest Log e mission IDs | Auditado | [`evidence/quest-data.json`](evidence/quest-data.json) |
| Checklist | Criado | [`checklist.md`](checklist.md) |
| Planejamento de rota | Criado | [`route/README.md`](route/README.md) |
| CaveBot | Ausente | captura própria futura |
| Diálogos automáticos | Proibidos | missão 5 e relatórios permanecem manuais |
| Bosses e arenas | Proibidos | todos manuais |
| Instalador/rollback | Proibidos em M2 | CI impede inclusão prematura |

## Fontes

### TibiaWiki Brasil

A página publicada em 23 de junho de 2026 é usada como referência editorial para:

- requisitos;
- ordem das dez missões;
- cidades e NPCs;
- itens e viagens;
- coordenadas editoriais;
- recompensas e acessos.

O texto do guia não é reproduzido integralmente.

### OpenTibiaBR Canary

Commit fixado:

```text
a879c9312e34381e8eedf397b8ed44510698b689
```

O Canary confirma:

- questline `Storage.Quest.U8_54.TheNewFrontier.Questline`;
- mission IDs `10409` a `10424`;
- três árvores do beaver bait;
- progresso do Shard of Corruption;
- saída secreta da prisão;
- arena para dois jogadores;
- sete ondas de bosses;
- timeout de 30 minutos e intervalo de 90 segundos por onda.

## Missões

| # | Missão | Principal risco | Política |
|---:|---|---|---|
| 1 | New Land | elevador e passagem da montanha | navegação futura; diálogos manuais |
| 2 | From Kazordoon With Love | uso do beaver bait e recuperação do item | item e combate manual |
| 3 | Strangers in the Night | vinha e negociação com Lazaran | ações e diálogo manuais |
| 4 | The Mine Is Mine | Shard of Corruption | boss manual |
| 5 | Getting Things Busy | seis diálogos e palavras específicas | integralmente manual |
| 6 | Days Of Doom | arena do Mooh'Tah Master | integralmente manual |
| 7 | Messengers Of Peace | negociação e captura | diálogo/transição manual |
| 8 | An Offer You Can't Refuse | prisão, nota e porta secreta | integralmente manual |
| 9 | Mortal Combat | dois jogadores e sete ondas | integralmente manual |
| 10 | New Horizons | relatório e desbloqueios | diálogo/verificação manual |

## Regra de automação

Uma futura rota poderá:

- navegar entre cidades e checkpoints já capturados;
- parar antes de NPCs, objetos e bosses;
- confirmar labels, posições e retorno;
- gerar dry-run sem executar actions.

Ela não poderá automaticamente:

- selecionar palavras de persuasão;
- usar itens de quest;
- entrar em arenas;
- acionar alavancas de boss;
- executar a prisão;
- lutar bosses;
- reportar missões;
- avançar para a próxima missão sem confirmação do Quest Log.

## Gate para M3

- [ ] confirmar a revisão da quest no MarolaOT;
- [ ] confirmar NPCs e item IDs;
- [ ] confirmar Quest Log e storages;
- [ ] capturar cada missão diretamente no cliente;
- [ ] criar rotas de ida, checkpoint e retorno;
- [ ] validar labels e actions com o parser CaveBot;
- [ ] documentar recuperação após falha;
- [ ] manter arenas, bosses, prisão e diálogos manuais;
- [ ] criar backup e rollback antes de qualquer instalador.

Acompanhamento: [issue #11](https://github.com/Samurai33/MarolaOT-Scripts/issues/11).
