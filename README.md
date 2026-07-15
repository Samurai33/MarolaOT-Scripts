<div align="center">
  <img src="https://i.ibb.co/60sNKnZ8/Chat-GPT-Image-14-de-jul-de-2026-22-56-59.jpg" alt="MarolaOT Scripts" width="760">

  # MarolaOT Scripts

  **Automação reproduzível, pesquisa auditável e manutenção segura para MarolaOT, OTClient e vBot 4.8.**

  [![PowerShell Analysis](https://github.com/Samurai33/MarolaOT-Scripts/actions/workflows/powershell-lint.yml/badge.svg?branch=main)](https://github.com/Samurai33/MarolaOT-Scripts/actions/workflows/powershell-lint.yml)
  [![Validate JSON](https://github.com/Samurai33/MarolaOT-Scripts/actions/workflows/validate-json.yml/badge.svg?branch=main)](https://github.com/Samurai33/MarolaOT-Scripts/actions/workflows/validate-json.yml)
  [![Source Manifests](https://github.com/Samurai33/MarolaOT-Scripts/actions/workflows/validate-source-manifests.yml/badge.svg?branch=main)](https://github.com/Samurai33/MarolaOT-Scripts/actions/workflows/validate-source-manifests.yml)
  [![Werehyaenas Research](https://github.com/Samurai33/MarolaOT-Scripts/actions/workflows/werehyaenas-research.yml/badge.svg?branch=main)](https://github.com/Samurai33/MarolaOT-Scripts/actions/workflows/werehyaenas-research.yml)
  [![License: MIT](https://img.shields.io/badge/license-MIT-2ea44f.svg)](LICENSE)
  [![vBot](https://img.shields.io/badge/vBot-4.8-5c2d91.svg?logo=lua&logoColor=white)](https://github.com/OTCv8/otclientv8)
  [![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE.svg?logo=powershell&logoColor=white)](scripts/windows/vbot)
  [![Platform](https://img.shields.io/badge/platform-Windows-0078D4.svg?logo=windows&logoColor=white)](#compatibilidade)
  [![Safety](https://img.shields.io/badge/safety-backup%20%7C%20rollback%20%7C%20bots%20off-0f766e.svg)](SECURITY.md)

  [Documentação](docs/) · [Catálogo](docs/CATALOG.md) · [Prioridades](docs/PRIORITY_BLOCKS.md) · [Fontes](docs/research/SOURCE_REGISTRY.md) · [Segurança](SECURITY.md) · [Contribuição](CONTRIBUTING.md)
</div>

---

## Sobre o projeto

O **MarolaOT-Scripts** centraliza scripts, pesquisas e pacotes para o ecossistema MarolaOT com cinco objetivos:

- instalar configurações de forma reproduzível;
- validar arquivos antes de abrir ou operar o cliente;
- criar backup antes de qualquer alteração;
- permitir rollback sem depender de memória ou intervenção improvisada;
- separar claramente pesquisa, adaptação, teste e release.

O projeto segue uma política de **evidência antes de implementação**. Uma hunt não se torna “em desenvolvimento” apenas por possuir um nome, uma pasta ou um TargetBot isolado. Para avançar, cada pacote registra fonte, commit, hash, licença, componentes disponíveis, lacunas e evidências.

> [!IMPORTANT]
> Scripts de configuração terminam com CaveBot, TargetBot, AttackBot e HealBot desligados. A ativação ocorre manualmente e por etapas.

> [!WARNING]
> A licença MIT deste repositório cobre somente o conteúdo original do MarolaOT-Scripts. Materiais externos mantêm as licenças e restrições de suas fontes.

## Estado atual

| Maturidade | Pacote | Estado | Próxima ação |
|---:|---|---|---|
| **M6** | Cobra Tower — MS 550+ | Release candidate autocontido e CI verde no PR #3 | Instalação limpa, dry-run, rollback e release M7 |
| **M2** | Werehyaenas — MS 300+ | Fontes, hashes, licença, criaturas e acesso auditados; sem CaveBot/refill | Encontrar rota reproduzível ou capturar uma rota própria documentada |
| **M0/M1** | Summer Court — MS 500+ | Nenhum pacote completo confirmado | Continuar pesquisa sem inventar rota |
| **M0** | Outras hunts e quests | Backlog orientado por evidência | Selecionar pela qualidade das fontes |

A matriz completa está em [`docs/CATALOG.md`](docs/CATALOG.md).

## Princípios

1. **Evidência antes da automação.**
2. **Commit e hash antes da adaptação.**
3. **Licença antes da redistribuição.**
4. **Backup antes da mudança.**
5. **Rollback antes da confiança.**
6. **Bots desligados por padrão.**
7. **Status honesto em cada estágio.**

## Modelo de maturidade

| Nível | Nome | Critério resumido |
|---:|---|---|
| M0 | Ideia | Sem fonte técnica suficiente |
| M1 | Referência encontrada | Fonte localizada, ainda não auditada |
| M2 | Referência auditada | Commit, arquivos, hashes, licença e dependências registrados |
| M3 | Adaptado | Conteúdo convertido para MarolaOT/vBot 4.8 |
| M4 | Teste local | JSONs e combate validados fora da rota |
| M5 | Rota controlada | Entrada, refill, loop e retorno testados |
| M6 | Validado | Volta completa, backup e rollback confirmados |
| M7 | Release | Pacote versionado, checksums e notas publicados |

Detalhes: [`docs/PRIORITY_BLOCKS.md`](docs/PRIORITY_BLOCKS.md).

## Pipeline de portabilidade

```mermaid
flowchart LR
    A[Referência pública ou captura própria] --> B[Manifesto e source lock]
    B --> C{Commit, hash e licença auditados?}
    C -- Não --> D[M1: referência apenas]
    C -- Sim --> E{CaveBot + TargetBot + refill?}
    E -- Não --> F[M2: pesquisa auditada]
    E -- Sim --> G[M3: adaptação vBot 4.8]
    G --> H[M4: teste local]
    H --> I[M5: rota controlada]
    I --> J[M6: validação completa]
    J --> K[M7: release versionada]
```

## Pacotes em destaque

### Cobra Tower MAX DPS v2

A Cobra Tower é o pacote operacional mais maduro do projeto. A configuração funcional inclui:

- Rage of the Skies com trava alinhada ao cooldown;
- Energy Wave e Great Fire Wave como preenchimento de rotação;
- GFB para grupos;
- Ultimate Energy Strike e SD para alvo isolado;
- supplies de UMP, GFB e SD;
- TargetBot dedicado às Cobras;
- looting interno desligado para uso do lootbag do servidor;
- refill integrado;
- backup e validação.

| Prioridade | Condição | Ação | Trava local |
|---:|---|---|---:|
| 1 | 6+ Cobras, HP ≥ 35% | Rage of the Skies | 40,5 s |
| 2 | 3+ alinhadas | Energy Wave | 8,25 s |
| 3 | 3+ alinhadas | Great Fire Wave | 4,25 s |
| 4 | 2+ no melhor tile | Great Fireball Rune | 2 s |
| 5 | Alvo isolado, HP ≥ 30% | Ultimate Energy Strike | 30,5 s |
| 6 | Alvo restante | Sudden Death Rune | 2 s |

O release candidate está no [PR #3](https://github.com/Samurai33/MarolaOT-Scripts/pull/3).

### Werehyaenas — pesquisa M2

O pacote [`hunts/ms/300-499/werehyaenas`](hunts/ms/300-499/werehyaenas) contém somente pesquisa auditável:

- TargetBot comunitário fixado por commit e Git blob SHA-1;
- licença comunitária classificada como não declarada;
- dados primários das duas criaturas;
- storage e posições do atalho Ancient Feud;
- relatório da busca de CaveBot/refill;
- CI que impede código executável prematuro.

A pesquisa concluiu que:

- gelo possui vantagem nos dados auditados;
- energia causa dano normal;
- death é viável como single-target;
- fogo e terra são resistidos;
- nenhum CaveBot/refill público e reproduzível foi confirmado.

> [!NOTE]
> M2 não é uma hunt pronta. O pacote não contém CaveBot, TargetBot copiado, AttackBot, instalador ou rollback.

## O que está incluído

### Automação do vBot 4.8

- criação e ajuste de AttackBot, HealBot e Supplies;
- seleção segura de CaveBot e TargetBot;
- backup versionado antes da gravação;
- normalização de JSON em UTF-8 sem BOM;
- validações pós-escrita;
- checksums SHA-256;
- restauração de arquivos isolados.

### Diagnóstico do cliente

- teste de inicialização com configurações isoladas;
- consulta a eventos do Windows;
- detecção de executável e processos presos;
- quarentena reversível de configurações;
- validação de schema e sintaxe JSON.

### Governança de pacotes

- manifesto obrigatório de origem;
- source lock com commits e hashes;
- níveis de maturidade M0–M7;
- critérios de entrada e saída por prioridade;
- CI específico por pacote;
- separação entre referência, adaptação, teste e release.

## O que o projeto não faz

- não inventa waypoints ou diálogos de NPC;
- não transforma TargetBot isolado em “hunt completa”;
- não republica código de terceiros sem avaliar licença;
- não armazena credenciais, tokens, IPs privados ou dumps reais;
- não automatiza escolhas irreversíveis de quests sem checkpoint manual;
- não ativa bots automaticamente após instalação;
- não promove um pacote para M3 sem rota e refill verificáveis.

## Scripts disponíveis

| Script | Finalidade |
|---|---|
| [`Set-CobraTowerMaxDpsV2.ps1`](scripts/windows/vbot/Set-CobraTowerMaxDpsV2.ps1) | Instala e normaliza o perfil Cobra Tower MAX DPS v2 |
| [`Test-MarolaOTClientMatrix.ps1`](scripts/windows/vbot/Test-MarolaOTClientMatrix.ps1) | Testa inicialização do cliente com configurações isoladas |
| [`Restore-VBotCoreConfigs.ps1`](scripts/windows/vbot/Restore-VBotCoreConfigs.ps1) | Restaura AttackBot, HealBot e Supplies da quarentena |
| [`Test-VBotJson.ps1`](scripts/windows/vbot/Test-VBotJson.ps1) | Valida JSON, schema básico e estado dos módulos |

## Uso rápido

### Requisitos

- Windows;
- PowerShell 5.1 ou superior;
- MarolaOT Client com vBot 4.8;
- cliente completamente fechado durante alterações;
- cópia local deste repositório.

### Clonar

```powershell
git clone https://github.com/Samurai33/MarolaOT-Scripts.git
cd MarolaOT-Scripts
```

### Validar antes de alterar

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\scripts\windows\vbot\Test-VBotJson.ps1
```

### Instalar a configuração atual da Cobra Tower

```powershell
.\scripts\windows\vbot\Set-CobraTowerMaxDpsV2.ps1
```

O caminho padrão é:

```text
C:\Users\Samurai\AppData\Roaming\marolaot\marolaot\marolaot\bot\vBot_4.8
```

Outro perfil pode ser informado explicitamente:

```powershell
.\scripts\windows\vbot\Set-CobraTowerMaxDpsV2.ps1 `
  -ProfilePath "C:\caminho\para\vBot_4.8"
```

## Estrutura do repositório

```text
MarolaOT-Scripts/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── workflows/
├── assets/
├── configs/vbot-4.8/examples/
├── docs/
│   ├── research/
│   ├── CATALOG.md
│   └── PRIORITY_BLOCKS.md
├── hunts/
├── quests/
├── schemas/
├── scripts/
│   ├── server/
│   └── windows/vbot/
├── templates/
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── SECURITY.md
└── README.md
```

## Manifesto e source lock

Todo novo pacote deve possuir um `source-manifest.json` compatível com:

- [`schemas/source-manifest.schema.json`](schemas/source-manifest.schema.json)
- [`templates/source-manifest.example.json`](templates/source-manifest.example.json)

O manifesto registra estado e componentes. O `source-lock.json` fixa:

- repositório e commit;
- caminhos de origem;
- hashes dos arquivos auditados;
- licença e política de redistribuição;
- resultado das buscas;
- dependências e bloqueadores.

## Blocos de prioridade

- **P0 — concluído:** governança, manifestos, registro de fontes e CI.
- **P1 — release candidate:** Cobra Tower em consolidação M7.
- **P2 — M2 concluído:** Werehyaenas auditada, bloqueada por ausência de rota/refill.
- **P3:** schemas e validação estrutural avançada.
- **P4:** framework seguro de quests e acessos.
- **P5:** expansão do catálogo pela qualidade das fontes.

A execução detalhada está em [`docs/PRIORITY_BLOCKS.md`](docs/PRIORITY_BLOCKS.md).

## Fontes e proveniência

O projeto utiliza classes distintas de referência:

1. **Upstream técnico:** [`OTCv8/otclientv8`](https://github.com/OTCv8/otclientv8).
2. **Dados primários do servidor:** [`opentibiabr/canary`](https://github.com/opentibiabr/canary).
3. **Conteúdo comunitário:** [`Kolczan/Tibia-Scripts`](https://github.com/Kolczan/Tibia-Scripts), tratado como `reference-only` enquanto não houver licença declarada.
4. **Documentação comunitária:** fóruns e wikis usados para conferência, sem substituir fontes primárias disponíveis.

O inventário auditável está em [`docs/research/SOURCE_REGISTRY.md`](docs/research/SOURCE_REGISTRY.md).

## Segurança operacional

- feche o cliente antes de executar scripts de alteração;
- revise a saída antes de abrir o MarolaOT;
- não pule o backup automático;
- mantenha os módulos desligados após instalação;
- não publique credenciais ou dados internos;
- valide localmente antes de executar uma rota;
- pare quests antes de bosses, escolhas ou consumo de itens raros;
- preserve os diretórios de backup até concluir o rollback testado.

Consulte [`SECURITY.md`](SECURITY.md).

## Contribuição

Antes de abrir um pull request:

- adicione ou atualize o manifesto e source lock;
- indique fonte, commit, hash e licença;
- descreva alterações, lacunas e riscos;
- inclua procedimento de rollback para pacotes executáveis;
- remova dados sensíveis;
- execute os validadores disponíveis;
- não marque como validado algo que ainda não completou uma volta real.

Leia [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Compatibilidade

| Componente | Alvo atual |
|---|---|
| Sistema operacional | Windows |
| Shell | Windows PowerShell 5.1+ / PowerShell 7+ |
| Cliente | MarolaOT Client |
| Bot | vBot 4.8 |
| Vocação de referência | Master Sorcerer |
| Servidor de referência | MarolaOT |

Compatibilidade com outros clientes ou servidores não é presumida. IDs, spells, NPCs, storages, coordenadas e cooldowns podem variar.

## Aviso legal

Este é um projeto independente para administração e automação do ambiente MarolaOT. Não possui afiliação oficial com CipSoft, Tibia, OTCv8 ou autores de repositórios comunitários citados. Marcas e conteúdos de terceiros pertencem aos respectivos proprietários.

O uso de automações deve respeitar as regras do servidor em que forem executadas.

## Licença

O conteúdo original deste repositório é distribuído sob a licença [MIT](LICENSE).

Materiais externos mantêm suas próprias licenças e devem ser tratados conforme o [Registro de Fontes](docs/research/SOURCE_REGISTRY.md).

---

<div align="center">
  <strong>MarolaOT Scripts</strong><br>
  Evidência antes da automação. Backup antes da mudança. Rollback antes da confiança.
</div>
