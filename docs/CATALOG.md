# Catálogo de Hunts e Quests

Este catálogo organiza o desenvolvimento por **evidência**, **maturidade** e **segurança operacional**. Uma ideia não recebe status de implementação enquanto não houver fonte técnica suficiente.

Consulte também:

- [Blocos de Prioridade](PRIORITY_BLOCKS.md)
- [Registro de Fontes](research/SOURCE_REGISTRY.md)
- [Schema do manifesto](../schemas/source-manifest.schema.json)

## Estados de maturidade

| Nível | Estado | Significado |
|---:|---|---|
| M0 | Ideia | Objetivo conhecido, sem referência técnica suficiente |
| M1 | Referência encontrada | Fonte localizada, ainda não auditada por completo |
| M2 | Referência auditada | Commit, arquivos, dependências e licença registrados |
| M3 | Adaptado | Conteúdo convertido para MarolaOT/vBot 4.8 |
| M4 | Teste local | JSONs, combate e módulos validados fora da rota |
| M5 | Rota controlada | Refill, entrada, loop e retorno testados |
| M6 | Validado | Volta completa, backup e rollback confirmados |
| M7 | Release | Pacote versionado, checksums e notas publicados |

## Hunts

| Maturidade | Hunt | Vocação | Faixa | Evidência atual | Próximo passo |
|---:|---|---|---:|---|---|
| M6 | Cobra Tower | MS | 550+ | Rota, refill, TargetBot e combate adaptados e funcionais | Consolidar pacote e publicar release M7 |
| M1/M2 parcial | Werehyaenas | MS | 300+ | TargetBot comunitário localizado; CaveBot e refill não confirmados | Auditar licença e localizar rota completa |
| M0/M1 | Summer Court | MS | 500+ | Nenhum pacote comunitário completo confirmado | Continuar pesquisa; não criar rota por suposição |
| M0 | Asura Mirror | MS | 450+ | Backlog sem fonte completa registrada | Buscar referência verificável |
| M0 | Winter Court | MS | 500+ | Backlog sem fonte completa registrada | Buscar referência verificável |
| M0 | Falcon Bastion | MS | 500+ | Backlog sem fonte completa registrada | Buscar referência verificável |
| M0 | Issavi Sphinx/Lamassu | MS | 450+ | Backlog sem fonte completa registrada | Buscar referência verificável |

## Quests e acessos

| Maturidade | Quest/acesso | Tipo | Evidência atual | Próximo passo |
|---:|---|---|---|---|
| M0 | Dream Courts | Acesso | Estrutura conceitual; nenhuma rota auditada | Buscar fontes de NPCs, storages, itens e checkpoints |
| M0 | Cobra Bastion | Acesso | Backlog | Registrar fontes e versão do servidor |
| M0 | Falcon Bastion | Acesso | Backlog | Registrar fontes e versão do servidor |
| M0 | Kilmaresh | Acesso | Backlog | Registrar fontes e versão do servidor |
| M0 | Secret Library | Acesso | Backlog | Registrar fontes e versão do servidor |
| M0 | Grave Danger | Quest | Backlog | Registrar fontes e checkpoints manuais |

## Estrutura obrigatória de uma hunt

```text
hunts/<vocacao>/<faixa>/<slug>/
├── README.md
├── source-manifest.json
├── cavebot/
├── targetbot/
├── configs/
├── install/
├── rollback/
└── tests/
```

Um pacote somente alcança M6 quando cumprir:

- manifesto de origem válido;
- licença e atribuição documentadas;
- backup automático antes de alterações;
- CaveBot, TargetBot, HealBot e AttackBot desligados ao final;
- teste local de combate;
- refill confirmado com IDs e NPCs corretos;
- lootbag/autoloot confirmado;
- rota completa sem loop, travamento ou waypoint impossível;
- rollback documentado e testado;
- uma volta completa registrada.

## Estrutura obrigatória de uma quest

```text
quests/<categoria>/<slug>/
├── README.md
├── source-manifest.json
├── checklist.md
├── route/
├── validation/
└── rollback/
```

Quests não automatizam decisões irreversíveis sem parada explícita. Entregas de itens, escolhas de recompensa, consumo de recursos raros, teleportes de risco e entrada em boss são checkpoints manuais.

## Ordem de execução

1. **P0:** fundação, manifestos, registro de fontes e CI.
2. **P1:** consolidar Cobra Tower como release de referência.
3. **P2:** reconstruir Werehyaenas a partir de evidência verificável.
4. **P3:** ampliar validação estrutural e testes automáticos.
5. **P4:** criar framework seguro para quests e acessos.
6. **P5:** selecionar novas hunts pela qualidade das fontes encontradas.
