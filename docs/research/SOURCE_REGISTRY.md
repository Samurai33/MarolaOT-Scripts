# Registro de Fontes

Este registro separa **framework oficial**, **dados primários do servidor**, **documentação comunitária** e **conteúdo de hunt**. Uma fonte listada aqui não implica permissão automática para redistribuir seus arquivos.

## Política de uso

Antes de copiar ou adaptar conteúdo externo:

1. fixe o repositório e o commit;
2. registre os caminhos exatos dos arquivos;
3. identifique a licença;
4. preserve atribuição e avisos exigidos;
5. quando a licença não estiver clara, registre apenas links, metadados e análise — não redistribua o código original;
6. documente todas as alterações feitas para o MarolaOT;
7. diferencie uma referência encontrada de uma rota executável e testada.

## Fontes verificadas

| ID | Fonte | Papel | Versão/commit | Licença | Confiança | Uso no projeto |
|---|---|---|---|---|---|---|
| `src-otcv8` | [OTCv8/otclientv8](https://github.com/OTCv8/otclientv8) | Upstream técnico do cliente e vBot 4.8 | `aacfe3f1fe4bcadb5a34ff1f36263e1c96b3dd32` nos pacotes auditados | MIT | Alta | Estrutura, loaders e schemas funcionais do vBot 4.8 |
| `src-canary` | [OpenTibiaBR Canary](https://github.com/opentibiabr/canary) | Dados primários do servidor | `a879c9312e34381e8eedf397b8ed44510698b689` no P2 | GPL-2.0-only | Alta | Criaturas, elementos, ataques, storages e actions de acesso |
| `src-kolczan` | [Kolczan/Tibia-Scripts](https://github.com/Kolczan/Tibia-Scripts) | Scripts comunitários de hunts | `52e6baaa1a32448abe88476fca53dcd466d7678e` | Não declarada no commit auditado | Alta para existência; restrita para redistribuição | Referência da Cobra Tower e TargetBot isolado de Werehyaenas |
| `src-otland-bot` | [OTClientV8 BOT — OTLand](https://otland.net/threads/otclientv8-bot.266958/) | Documentação comunitária de waypoints, labels, attacking e looting | Conteúdo histórico | Não aplicável a código do projeto | Média/alta | Sintaxe e comportamento esperado do CaveBot |
| `src-otland-macros` | [Scripts/macros for Kondra's OTClientV8 bot — OTLand](https://otland.net/threads/scripts-macros-for-kondras-otclientv8-bot.267394/) | Exemplos de callbacks e macros auxiliares | Conteúdo histórico | Variável por postagem | Média | Pesquisa de integração; não tratado como pacote de hunt |
| `src-tibiawiki` | [Tibia Wiki Brasil](https://www.tibiawiki.com.br/) | Dados editoriais da comunidade | Página consultada por pacote | Conteúdo editorial externo | Média | Conferência cruzada; nunca substitui dados primários disponíveis |

## Evidência por pacote

### Cobra Tower

| Campo | Evidência |
|---|---|
| Estado | M6; release candidate `1.0.0-rc.1` no PR #3 |
| Fonte comunitária | `Kolczan/Tibia-Scripts` |
| Commit fixo | `52e6baaa1a32448abe88476fca53dcd466d7678e` |
| CaveBot | Referência completa localizada, importada por commit/hash e adaptada |
| TargetBot | Cobras configuradas e adaptadas |
| Refill | Mehkesh e Fenech identificados na rota de origem |
| Combate | Perfil MAX DPS v2 adaptado ao schema local |
| Redistribuição | Arquivos comunitários não são armazenados enquanto a licença não estiver declarada |
| Próxima ação | Instalação limpa, dry-run, rollback e release M7 |

### Werehyaenas

| Campo | Evidência |
|---|---|
| Estado | M2 — referência auditada e não instalável |
| Fonte comunitária | `Kolczan/Tibia-Scripts` |
| Commit fixo | `52e6baaa1a32448abe88476fca53dcd466d7678e` |
| TargetBot | `otclientv8/bot/EK tsunami/targetbot_configs/Werehyaenas.json` |
| Git blob SHA-1 | `edd0800b2d736adf69972f3d8033d7deaad2539a` |
| Licença comunitária | Não declarada: `LICENSE` ausente e README sem concessão |
| Redistribuição | `reference-only`; arquivo integral não é copiado |
| Monstros | `Werehyaena`, `Werehyaena Shaman` |
| Dados de combate | Canary fixado; gelo vulnerável, energia normal, fogo/terra resistentes |
| Dependência de acesso | `Storage.Quest.U10_80.GrimvaleQuest.AncientFeudShortcut` |
| CaveBot | Busca profunda concluída sem correspondência pública confirmada |
| Refill | Não confirmado |
| Resultado | TargetBot isolado não constitui hunt completa |
| Próxima ação | Encontrar rota licenciada/reproduzível ou produzir captura própria documentada |

Arquivos auditáveis do pacote:

- `hunts/ms/300-499/werehyaenas/source-lock.json`;
- `hunts/ms/300-499/werehyaenas/evidence/monster-data.json`;
- `hunts/ms/300-499/werehyaenas/evidence/access-data.json`;
- `hunts/ms/300-499/werehyaenas/docs/RESEARCH_REPORT.md`.

### Summer Court

| Campo | Evidência |
|---|---|
| Estado | Pesquisa — M0/M1 |
| Pacote comunitário completo | Não localizado |
| CaveBot | Não confirmado |
| TargetBot | Não confirmado |
| Refill | Não confirmado |
| Regra | Não criar coordenadas, NPCs ou lógica por suposição |

## Fontes mínimas por novo pacote

Um `source-manifest.json` deve registrar no mínimo:

- nome e slug do pacote;
- vocação e faixa de level;
- URL e commit de cada repositório usado;
- caminho de cada arquivo de origem;
- licença e restrições conhecidas;
- componentes disponíveis e ausentes;
- alterações realizadas;
- evidências de teste;
- versão do MarolaOT e do vBot alvo.

Quando uma referência for importante, um `source-lock.json` também deve fixar hashes dos arquivos auditados.

## Observação sobre licenças

O upstream `OTCv8/otclientv8` declara licença MIT. O Canary auditado declara GPL-2.0. A referência `Kolczan/Tibia-Scripts` não apresenta licença no commit verificado. Até surgir uma concessão válida, o MarolaOT-Scripts preserva apenas links, commits, hashes e análises, evitando republicar arquivos integrais dessa origem como conteúdo MIT do projeto.
