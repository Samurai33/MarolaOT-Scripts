# Diferenças entre a referência e o pacote MarolaOT

## Fontes fixadas

| Fonte | Commit | Uso |
|---|---|---|
| `Kolczan/Tibia-Scripts` | `52e6baaa1a32448abe88476fca53dcd466d7678e` | referência da rota e TargetBot |
| `OTCv8/otclientv8` | `aacfe3f1fe4bcadb5a34ff1f36263e1c96b3dd32` | estrutura técnica do OTClient/vBot |

## Política de redistribuição

A referência comunitária não possui licença confirmada no levantamento. Os arquivos originais não são versionados no MarolaOT-Scripts. O instalador os importa diretamente do commit fixo e valida os Git blob SHA-1 registrados em `source-lock.json`.

## CaveBot

| Alteração | Motivo |
|---|---|
| `Menkesh` → `Mehkesh` | corrigir o nome do NPC de supplies usado no ambiente MarolaOT |
| validação de labels, NPCs e ações críticas | impedir instalação de uma origem diferente ou incompleta |
| geração de `[550+] Cobra Tower DRY RUN.cfg` | permitir verificar a rota sem iniciar combate ou entrar automaticamente na hunt |
| escrita UTF-8 sem BOM | manter compatibilidade com o loader local |

A rota continua referenciando funções do vBot, incluindo `reopenPurse`, `TargetBot.setOn`, `TargetBot.setOff`, `lure`, `supplycheck`, `bank`, `buysupplies`, `sellall` e `travel`.

## TargetBot

| Alteração | Valor |
|---|---|
| `lureCavebot` | `true` |
| `lureCount` | `6` |
| `keepDistance` | `false` |
| `maxDistance` | `10` |
| `dontLoot` | `true` |
| prioridade Vizier/entrada combinada | `4` |
| prioridade Assassin | `3` quando aplicável |
| prioridade Scout | `2` |
| looting interno | removido |

O loot é delegado ao sistema de lootbag do MarolaOT.

## AttackBot

O perfil legado foi substituído por um perfil vBot 4.8 separado, com cooldowns locais compatíveis com os tempos do servidor:

- Rage of the Skies: `40500 ms`;
- Energy Wave: `8250 ms`;
- Great Fire Wave: `4250 ms`;
- GFB: `2000 ms`;
- Ultimate Energy Strike: `30500 ms`;
- SD: `2000 ms`.

## HealBot e Supplies

O pacote instala perfis nomeados e desligados:

- `exura vita` abaixo de 75% de HP;
- `exura gran` abaixo de 92% de HP;
- Ultimate Mana Potion abaixo de 60% de mana;
- UMP `200–700`;
- GFB `700–2500`;
- SD `250–1000`;
- retorno por capacidade em `300`.

## Segurança operacional

- backup antes de qualquer escrita;
- importação validada por hash;
- todos os módulos desligados após instalação;
- rollback remove arquivos criados pelo pacote quando eles não existiam antes;
- restauração força os módulos para OFF;
- relatórios de instalação e restauração ficam junto ao backup.
