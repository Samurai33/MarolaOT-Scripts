# MS Summer Court 500+

> **Maturidade:** M0/M1 — pesquisa, sem pacote comunitário completo confirmado.

Este diretório é um **placeholder de pesquisa**. Ele não contém rota executável, TargetBot validado, refill ou acesso automatizado.

## Regra principal

Nenhuma coordenada, ação de NPC, lógica de acesso ou configuração de combate será criada por suposição. O pacote só avança quando existir uma destas bases:

1. referência pública completa e auditável;
2. referência parcial forte combinada com captura própria documentada;
3. captura própria integral, registrada waypoint por waypoint.

## Evidência disponível

| Componente | Estado |
|---|---|
| CaveBot | Não localizado |
| TargetBot | Não localizado |
| AttackBot | Não auditado |
| HealBot | Não auditado |
| Supplies | Não auditado |
| Refill | Não localizado |
| Acesso | Não auditado |
| Licença de uma fonte de hunt | Não aplicável até localizar fonte |

## Objetivo futuro

Quando houver referência suficiente, o pacote deverá oferecer:

- rota completa entre ponto inicial, refill, entrada e loop;
- variante dry-run sem ativar TargetBot;
- TargetBot com monstros e prioridades verificadas;
- rotação de combate com cooldowns reais do servidor;
- loot pelo lootbag do MarolaOT;
- retorno por capacidade e supplies;
- instalador PowerShell com backup;
- rollback completo;
- manifesto de origem válido.

## Estrutura prevista

```text
summer-court/
├── README.md
├── source-manifest.json
├── cavebot/
├── targetbot/
├── configs/
├── install/
├── rollback/
└── tests/
```

## Critério para avançar a M2

- [ ] fonte pública ou captura própria identificada;
- [ ] repositório e commit fixados, quando aplicável;
- [ ] caminhos dos arquivos registrados;
- [ ] licença e redistribuição avaliadas;
- [ ] CaveBot ou sequência completa de waypoints disponível;
- [ ] TargetBot ou lista verificável de monstros disponível;
- [ ] refill e dependências identificados.

Até esses itens serem cumpridos, este diretório não representa uma hunt em desenvolvimento nem deve ser instalado no cliente.
