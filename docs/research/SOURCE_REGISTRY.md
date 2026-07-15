# Registro de Fontes

Este registro separa **framework oficial**, **documentação comunitária** e **conteúdo de hunt**. Uma fonte listada aqui não implica permissão automática para redistribuir seus arquivos.

## Política de uso

Antes de copiar ou adaptar conteúdo externo:

1. fixe o repositório e o commit;
2. registre os caminhos exatos dos arquivos;
3. identifique a licença;
4. preserve atribuição e avisos exigidos;
5. quando a licença não estiver clara, registre apenas links, metadados e análise — não redistribua o código original;
6. documente todas as alterações feitas para o MarolaOT.

## Fontes verificadas

| ID | Fonte | Papel | Versão/commit | Licença | Confiança | Uso no projeto |
|---|---|---|---|---|---|---|
| `src-otcv8` | [OTCv8/otclientv8](https://github.com/OTCv8/otclientv8) | Upstream técnico do cliente e vBot 4.8 | branch pública `master`; fixar commit por pacote | MIT | Alta | Estrutura, loaders, CaveBot, TargetBot, AttackBot, HealBot e Supplies |
| `src-kolczan` | [Kolczan/Tibia-Scripts](https://github.com/Kolczan/Tibia-Scripts) | Scripts comunitários de hunts | `52e6baaa1a32448abe88476fca53dcd466d7678e` | Não especificada no levantamento | Alta para existência; restrita para redistribuição | Referência da Cobra Tower e TargetBot parcial de Werehyaenas |
| `src-otland-bot` | [OTClientV8 BOT — OTLand](https://otland.net/threads/otclientv8-bot.266958/) | Documentação comunitária de waypoints, labels, attacking e looting | Conteúdo histórico | Não aplicável a código do projeto | Média/alta | Sintaxe e comportamento esperado do CaveBot |
| `src-otland-macros` | [Scripts/macros for Kondra's OTClientV8 bot — OTLand](https://otland.net/threads/scripts-macros-for-kondras-otclientv8-bot.267394/) | Exemplos de callbacks e macros auxiliares | Conteúdo histórico | Variável por postagem | Média | Pesquisa de integração; não tratado como pacote de hunt |
| `src-tibiawiki` | [Tibia Wiki Brasil](https://www.tibiawiki.com.br/) | Dados de NPCs, criaturas e itens | Página consultada por pacote | Conteúdo editorial externo | Média/alta | Conferência cruzada de NPCs, monstros e supplies |

## Evidência por pacote

### Cobra Tower

| Campo | Evidência |
|---|---|
| Estado | Validado no ambiente MarolaOT; candidato a release de referência |
| Fonte comunitária | `Kolczan/Tibia-Scripts` |
| Commit fixo | `52e6baaa1a32448abe88476fca53dcd466d7678e` |
| CaveBot | Referência completa localizada e adaptada |
| TargetBot | Cobras configuradas e adaptadas |
| Refill | Mehkesh e Fenech identificados na rota de origem |
| Combate | Perfil MAX DPS v2 adaptado ao schema local |
| Redistribuição | Revisar licença da origem antes de incluir arquivos originais sem transformação |

### Werehyaenas

| Campo | Evidência |
|---|---|
| Estado | Referência parcial forte — M2 incompleto |
| Fonte comunitária | `Kolczan/Tibia-Scripts` |
| Commit fixo | `52e6baaa1a32448abe88476fca53dcd466d7678e` |
| TargetBot | `otclientv8/bot/EK tsunami/targetbot_configs/Werehyaenas.json` |
| Monstros | `Werehyaena`, `Werehyaena Shaman` |
| CaveBot | Não confirmado no levantamento |
| Refill | Não confirmado no levantamento |
| Próxima ação | Localizar rota/licença ou produzir captura própria documentada |

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

## Observação sobre licenças

O upstream `OTCv8/otclientv8` declara licença MIT. A licença do repositório comunitário `Kolczan/Tibia-Scripts` não foi confirmada no levantamento. Até essa situação ser esclarecida, o MarolaOT-Scripts deve preservar referências e produzir adaptações próprias, evitando republicar arquivos integrais da origem como se fossem conteúdo licenciado pelo projeto.
