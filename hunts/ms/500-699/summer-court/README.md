# MS Summer Court 500+

> Status: 🛠️ Em desenvolvimento

Pacote planejado para Master Sorcerer solo, com foco em ritmo alto, ataques em área e retorno seguro para refill.

## Objetivos

- rota completa entre depot, NPCs e hunt;
- variante de dry-run sem ativar TargetBot;
- rotação com cooldowns reais do servidor;
- prioridade para waves e runas de área;
- loot pelo lootbag do MarolaOT;
- refill automático e retorno por capacidade/supplies;
- instalador PowerShell com backup e rollback.

## Estrutura prevista

```text
summer-court/
├── README.md
├── cavebot/
│   ├── summer-court.cfg
│   └── summer-court-dry-run.cfg
├── targetbot/
│   └── summer-court.json
├── configs/
│   ├── AttackBot.json
│   ├── HealBot.json
│   └── Supplies.json
├── install/
│   └── Set-SummerCourtMs.ps1
└── tests/
    └── CHECKLIST.md
```

## Pontos que precisam ser validados no MarolaOT

- nomes e resistências exatas dos monstros;
- melhor elemento para cada grupo;
- cooldowns das magias usadas;
- NPCs e IDs de supplies;
- proteção elemental recomendada;
- pontos de lure e locais seguros para parar;
- capacidade mínima de retorno;
- acesso necessário e estado da Dream Courts Quest;
- comportamento do lootbag dentro da área.

## Critérios de aceite

- [ ] cliente abre com todos os JSONs;
- [ ] dry-run completa refill e para antes da entrada;
- [ ] TargetBot identifica todos os monstros;
- [ ] AttackBot usa área sem spam de cooldown;
- [ ] lootbag recebe os itens;
- [ ] rota não entra em loop;
- [ ] retorno acontece por supplies e capacidade;
- [ ] backup e restauração foram testados;
- [ ] pacote validado por pelo menos uma volta completa.

## Segurança

O primeiro teste deve ser feito com CaveBot desligado. Combate, runas, waves e cura devem ser validados localmente ou na entrada antes da rota automática completa.
