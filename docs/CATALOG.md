# Catálogo de Hunts e Quests

Este catálogo organiza o desenvolvimento de rotas, perfis de combate, supplies, acessos e validações do MarolaOT.

## Status

| Estado | Significado |
|---|---|
| ✅ Validado | Testado no MarolaOT com backup, refill e combate |
| 🧪 Em teste | Estrutura pronta, aguardando teste controlado |
| 🛠️ Em desenvolvimento | Rota ou configuração sendo construída |
| 📋 Planejado | Priorizado, ainda sem pacote executável |

## Hunts

| Status | Hunt | Vocação | Faixa inicial | Objetivo do pacote |
|---|---|---|---:|---|
| ✅ | Cobra Tower | MS | 550+ | MAX DPS v2, refill, lootbag e rotação completa |
| 🛠️ | Summer Court | MS | 500+ | rota solo agressiva, waves, GFB e controle de lure |
| 📋 | Winter Court | MS | 500+ | rota solo, proteção elemental e refill dedicado |
| 📋 | Asura Mirror | MS | 450+ | alto XP/h, posicionamento e área segura |
| 📋 | Falcon Bastion | MS | 500+ | rota por andares e controle de risco |
| 📋 | Issavi Sphinx/Lamassu | MS | 450+ | kiting, waves e retorno por supplies |
| 📋 | Werehyaenas | MS | 300+ | pacote intermediário e baixo custo operacional |

## Quests e acessos

| Status | Quest/acesso | Tipo | Objetivo do pacote |
|---|---|---|---|
| 🛠️ | Dream Courts | Acesso | checklist, waypoints e validações de estado |
| 📋 | Cobra Bastion | Acesso | documentação do acesso usado pela Cobra Tower |
| 📋 | Falcon Bastion | Acesso | sequência de missões e pontos de validação |
| 📋 | Kilmaresh | Acesso | liberar Issavi e conteúdos relacionados |
| 📋 | Secret Library | Acesso | checklist modular por missão |
| 📋 | Grave Danger | Quest | preparação, bosses e controle de progresso |

## Padrão obrigatório para hunts

Cada pacote de hunt deve conter:

```text
hunts/<vocacao>/<faixa>/<slug>/
├── README.md
├── cavebot/
├── targetbot/
├── configs/
├── install/
└── tests/
```

O pacote só recebe status **Validado** quando cumprir:

- backup automático antes de qualquer alteração;
- CaveBot, TargetBot, HealBot e AttackBot desligados ao final da instalação;
- teste local de combate quando possível;
- refill confirmado com IDs e NPCs corretos;
- lootbag/autoloot confirmado;
- rota completa testada sem loop, travamento ou waypoint impossível;
- instruções de rollback documentadas.

## Padrão obrigatório para quests

Cada pacote de quest deve conter:

```text
quests/<categoria>/<slug>/
├── README.md
├── checklist.md
├── route/
├── validation/
└── rollback/
```

Quests não devem automatizar decisões irreversíveis sem uma parada explícita. Entregas de itens, escolha de recompensa, consumo de recursos raros e entrada em boss devem ser documentados como checkpoints manuais.

## Próximo lote

1. Summer Court para MS 500+.
2. Dream Courts Access.
3. Asura Mirror para MS 450+.
4. Kilmaresh Access.
5. Winter Court para MS 500+.
