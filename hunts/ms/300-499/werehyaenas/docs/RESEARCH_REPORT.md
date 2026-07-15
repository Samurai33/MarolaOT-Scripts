# Relatório de Pesquisa — Werehyaenas MS 300+

## Resumo executivo

A pesquisa promove o pacote de **M1 — referência encontrada** para **M2 — referência auditada**.

Foi confirmado um TargetBot comunitário para `Werehyaena` e `Werehyaena Shaman`, mas **nenhum CaveBot completo, refill ou conjunto reproduzível de dependências foi localizado**. O pacote permanece deliberadamente não instalável.

## Resultado por componente

| Componente | Resultado | Evidência |
|---|---|---|
| TargetBot | Encontrado e fixado por commit/hash | `source-lock.json` |
| CaveBot | Não encontrado | Busca por nomes, regex, região e coordenadas |
| Refill | Não encontrado | Nenhum par rota + NPCs confirmado |
| Licença comunitária | Não declarada | `LICENSE` ausente e README sem concessão |
| Upstream vBot 4.8 | Fixado | OTCv8 commit `aacfe3f...` |
| Criaturas | Auditadas | Canary commit `a879c931...` |
| Atalho Ancient Feud | Auditado | storage e quatro pares de teleporte |
| AttackBot MS | Não criado | apenas direção elemental documentada |
| Cliente/personagem | Não alterados | pesquisa somente documental |

## Referência comunitária

### Origem

```text
Repositório: Kolczan/Tibia-Scripts
Commit: 52e6baaa1a32448abe88476fca53dcd466d7678e
Arquivo: otclientv8/bot/EK tsunami/targetbot_configs/Werehyaenas.json
Git blob SHA-1: edd0800b2d736adf69972f3d8033d7deaad2539a
```

### Conteúdo confirmado

A configuração possui uma única entrada para:

- `Werehyaena`;
- `Werehyaena Shaman`;
- regex `^werehyaena$|^werehyaena shaman$`;
- `lureCavebot = true`;
- `lureCount = 3`;
- `maxDistance = 10`;
- prioridade `7`.

O arquivo também possui configuração de looting do autor. Essa lista **não será reutilizada automaticamente** porque:

1. pertence a uma referência sem licença declarada;
2. foi criada para outro perfil e vocação;
3. o MarolaOT utiliza uma estratégia própria de lootbag;
4. os IDs e valores precisam ser comparados com a revisão local do servidor.

## Auditoria de licença

No commit auditado:

- `LICENSE` não existe;
- o README contém apenas o nome do projeto e uma descrição curta;
- não há concessão explícita para copiar, modificar ou redistribuir os scripts.

Decisão do projeto:

```text
redistribution = reference-only
```

O MarolaOT-Scripts poderá registrar URL, commit, caminho, hash e análise. Não deverá republicar o TargetBot integral como conteúdo MIT do projeto.

## Busca de CaveBot

Foram pesquisados:

- `Werehyaenas`;
- `werehyaena`;
- `Werehyaena Shaman`;
- regex exata do TargetBot;
- `Grimvale`;
- `Darashia`;
- variações `hyena` e `hyaena`;
- coordenadas do atalho Ancient Feud;
- perfis próximos ao TargetBot original;
- repositórios públicos e catálogos comunitários.

### Resultado

Nenhum arquivo público foi confirmado como um conjunto completo contendo:

```text
CaveBot + TargetBot + refill + dependências + licença/uso reproduzível
```

O armazenamento do perfil `EK tsunami` estava salvo em uma rota de Issavi, portanto não identifica o CaveBot das Werehyaenas.

Uma página comercial de cavebots foi encontrada, mas não oferece o código-fonte da rota, commit fixo ou licença de redistribuição. Ela foi excluída como fonte técnica do pacote.

## Acesso Ancient Feud

O Canary implementa o atalho em:

```text
data-otservbr-global/scripts/quests/grimvale/actions_ancient_feud_entrances.lua
```

O uso depende de:

```text
Storage.Quest.U10_80.GrimvaleQuest.AncientFeudShortcut
```

Quando o storage é menor que zero, o acesso é negado. Os pares de posição estão registrados em [`../evidence/access-data.json`](../evidence/access-data.json).

Essa informação comprova uma dependência de acesso, mas não fornece:

- a rota normal desde o depot;
- a sequência de missões;
- o NPC que libera o storage;
- compatibilidade automática com a revisão atual do mapa MarolaOT.

Por isso, as coordenadas não serão transformadas em waypoints nesta etapa.

## Dados de combate

As definições do Canary mostram:

| Criatura | HP | Energia | Terra | Fogo | Gelo | Death |
|---|---:|---:|---:|---:|---:|---:|
| Werehyaena | 2700 | 0% | 40% resistência | 50% resistência | 20% vulnerabilidade | normal |
| Werehyaena Shaman | 2500 | 0% | 40% resistência | 25% resistência | 20% vulnerabilidade | 5% vulnerabilidade |

Direção para uma futura rotação MS:

1. gelo como elemento mais eficiente nos dados auditados;
2. energia como dano estável sem resistência;
3. death/SD como single-target viável;
4. fogo deve ser rebaixado em relação à Cobra Tower;
5. terra não deve ser priorizada.

Isso é uma **hipótese de configuração baseada em dados**, não um AttackBot pronto. Cooldowns, IDs de runa, spells e comportamento do MarolaOT ainda precisam ser auditados antes de M3.

## Bloqueadores para M3

- CaveBot completo ou captura própria documentada;
- rota de ida, entrada, loop e retorno;
- cidade inicial, banco e NPCs de refill;
- dependências Lua/actions da rota;
- confirmação do acesso na revisão do servidor, sem alterar personagem nesta fase;
- TargetBot próprio, sem copiar conteúdo não licenciado;
- AttackBot, HealBot e Supplies no schema MarolaOT;
- instalador e rollback específicos.

## Decisão de maturidade

```text
M2 — reference-audited
```

O pacote pode orientar a próxima pesquisa, mas não pode ser instalado ou apresentado como hunt funcional.
