# Werehyaenas — Master Sorcerer 300+

> **Maturidade:** M2 — referência auditada, pacote deliberadamente não instalável.

Este diretório representa o bloco **P2** do MarolaOT-Scripts. A pesquisa fixou fontes, commits, hashes, licenças, dados de acesso e informações de combate, mas não encontrou um CaveBot/refill público completo.

## Estado atual

| Componente | Estado | Evidência |
|---|---|---|
| Source manifest | M2 | [`source-manifest.json`](source-manifest.json) |
| Source lock | Auditado | [`source-lock.json`](source-lock.json) |
| TargetBot | Referenciado | origem comunitária fixada por commit e Git blob SHA-1 |
| CaveBot | Ausente | nenhuma rota pública completa confirmada |
| Refill | Ausente | depot, banco, compras e retorno não confirmados |
| Acesso | Parcialmente documentado | [`evidence/access-data.json`](evidence/access-data.json) |
| Criaturas/elementos | Auditado | [`evidence/monster-data.json`](evidence/monster-data.json) |
| AttackBot MS | Ausente | apenas direção elemental de pesquisa |
| HealBot/Supplies | Ausentes | dependem da rota e de teste local futuro |
| Instalador/Rollback | Proibidos em M2 | CI impede inclusão prematura |

O relatório completo está em [`docs/RESEARCH_REPORT.md`](docs/RESEARCH_REPORT.md).

## Referência comunitária confirmada

```text
Repositório: Kolczan/Tibia-Scripts
Commit: 52e6baaa1a32448abe88476fca53dcd466d7678e
Arquivo: otclientv8/bot/EK tsunami/targetbot_configs/Werehyaenas.json
Git blob SHA-1: edd0800b2d736adf69972f3d8033d7deaad2539a
```

A entrada contempla:

- `Werehyaena`;
- `Werehyaena Shaman`;
- regex para as duas criaturas;
- integração de lure com CaveBot;
- `lureCount = 3`;
- `maxDistance = 10`;
- prioridade `7`.

### Licença

O commit auditado não possui arquivo `LICENSE`, e o README não concede permissão de cópia ou redistribuição. Portanto:

```text
redistribution = reference-only
```

O TargetBot original não é armazenado neste repositório e não será tratado como conteúdo MIT do MarolaOT-Scripts.

## Resultado da busca de rota

Foram pesquisados nomes, variações, regex, região, quest e coordenadas verificáveis. Nenhum conjunto público foi confirmado com:

```text
CaveBot + TargetBot + refill + dependências + origem reproduzível
```

O perfil comunitário que contém o TargetBot estava salvo em uma rota de Issavi, não em Werehyaenas. Uma oferta comercial também foi localizada, mas não disponibiliza código, commit ou licença e foi excluída como fonte técnica.

## Acesso Ancient Feud

O Canary confirma um atalho condicionado ao storage:

```text
Storage.Quest.U10_80.GrimvaleQuest.AncientFeudShortcut
```

O acesso é negado quando o valor é menor que zero. Quatro pares de teleporte foram registrados em [`evidence/access-data.json`](evidence/access-data.json).

Essas posições são evidência de dependência de acesso. Elas **não** constituem uma rota CaveBot e não serão transformadas em waypoints por suposição.

## Direção de combate para MS

Os dados auditados indicam:

| Elemento | Werehyaena | Shaman | Direção futura |
|---|---:|---:|---|
| Gelo | 20% vulnerabilidade | 20% vulnerabilidade | prioridade alta |
| Energia | dano normal | dano normal | opção estável |
| Death | dano normal | 5% vulnerabilidade | single-target viável |
| Fogo | 50% resistência | 25% resistência | rebaixar |
| Terra | 40% resistência | 40% resistência | evitar |

Isso ainda não é um AttackBot. Antes de M3, será necessário validar spells, runas, IDs, cooldowns e comportamento específico do MarolaOT.

## Validar a pesquisa

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force

.\tests\Test-WerehyaenasResearch.ps1
```

O teste confirma:

- maturidade M2 e status `reference-audited`;
- commits e hashes das fontes;
- política `reference-only`;
- dados de criaturas e acesso;
- ausência obrigatória de CaveBot, instalador, rollback e código externo copiado.

## Gate para M3

O pacote só poderá avançar quando houver:

- [ ] CaveBot completo ou captura própria documentada;
- [ ] rota depot → entrada → loop → saída → refill → retorno;
- [ ] NPCs, supplies e dependências identificados;
- [ ] acesso compatível com a revisão do MarolaOT;
- [ ] TargetBot próprio, sem copiar conteúdo não licenciado;
- [ ] AttackBot, HealBot e Supplies no schema local;
- [ ] instalador com backup e módulos desligados;
- [ ] rollback específico;
- [ ] testes locais futuros autorizados.

## Segurança

- nenhum teste no personagem foi realizado;
- nenhuma configuração local foi alterada;
- nenhuma coordenada aproximada foi inventada;
- nenhuma referência sem licença foi republicada;
- o pacote permanece não executável até cumprir M3.

Acompanhamento: [issue #4](https://github.com/Samurai33/MarolaOT-Scripts/issues/4).
