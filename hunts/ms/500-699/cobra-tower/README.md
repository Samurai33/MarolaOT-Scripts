# Cobra Tower MAX DPS v2 — Master Sorcerer 550+

> **Maturidade:** M6 — validado no ambiente MarolaOT. Este pacote é o release candidate para M7.

Pacote reproduzível para instalar a hunt **Cobra Tower MAX DPS v2** no MarolaOT/vBot 4.8 com backup automático, importação de referências fixadas por commit, validação de integridade e rollback específico.

## Estado do pacote

| Componente | Estado | Implementação |
|---|---|---|
| Source lock | Pronto | [`source-lock.json`](source-lock.json) |
| CaveBot | Importado e adaptado | commit e Git blob fixados |
| CaveBot dry-run | Gerado pelo instalador | TargetBot e CaveBot desligados antes da entrada |
| TargetBot | Importado e adaptado | lure 6, prioridades e looting interno OFF |
| AttackBot | Pronto | [`configs/attack-profile.json`](configs/attack-profile.json) |
| HealBot | Pronto | [`configs/heal-profile.json`](configs/heal-profile.json) |
| Supplies | Pronto | [`configs/supplies-profile.json`](configs/supplies-profile.json) |
| Instalador | Pronto | [`install/Install-CobraTower.ps1`](install/Install-CobraTower.ps1) |
| Rollback | Pronto | [`rollback/Restore-CobraTower.ps1`](rollback/Restore-CobraTower.ps1) |
| Teste estático | Pronto | [`tests/Test-CobraTowerPackage.ps1`](tests/Test-CobraTowerPackage.ps1) |
| Release M7 | Pendente | exige CI, teste do instalador e rollback em clone limpo |

## Política de origem

A rota e o TargetBot comunitários estão fixados no commit:

```text
52e6baaa1a32448abe88476fca53dcd466d7678e
```

A licença do repositório comunitário não foi confirmada. Por isso:

- os arquivos originais **não são armazenados neste repositório**;
- o instalador baixa diretamente do commit fixo ou usa um cache local;
- cada arquivo é validado pelo Git blob SHA-1 antes da adaptação;
- o MarolaOT-Scripts distribui apenas perfis, instalador, rollback, documentação e transformações próprias.

Consulte [`source-lock.json`](source-lock.json), [`source-manifest.json`](source-manifest.json) e [`docs/UPSTREAM_DIFF.md`](docs/UPSTREAM_DIFF.md).

## Conteúdo instalado

```text
vBot_4.8/
├── cavebot_configs/
│   ├── [550+] Cobra Tower.cfg
│   └── [550+] Cobra Tower DRY RUN.cfg
├── targetbot_configs/
│   └── cobra.json
├── vBot_configs/profile_1/
│   ├── AttackBot.json
│   ├── HealBot.json
│   └── Supplies.json
└── storage/
    └── profile_1.json
```

O inventário completo está em [`inventory.json`](inventory.json).

## Pré-requisitos

- Windows PowerShell 5.1 ou PowerShell 7;
- MarolaOT completamente fechado;
- perfil vBot 4.8 existente;
- acesso ao GitHub para o modo `Download`, ou cache local das duas referências;
- `AttackBot.json`, `HealBot.json`, `Supplies.json` e `storage/profile_1.json` já criados pelo vBot.

## Validar o pacote

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force

.\tests\Test-CobraTowerPackage.ps1
```

O teste verifica estrutura, JSON, perfis, source lock, integridade dos checksums e sintaxe PowerShell.

## Instalar pela referência fixada

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force

.\install\Install-CobraTower.ps1
```

Outro perfil:

```powershell
.\install\Install-CobraTower.ps1 `
  -ProfilePath "C:\caminho\para\vBot_4.8"
```

Visualizar a operação sem aplicar:

```powershell
.\install\Install-CobraTower.ps1 -WhatIf
```

## Instalação offline

Crie um diretório contendo os arquivos originais com os nomes:

```text
[550+] Cobra Tower.cfg
cobra.json
```

Execute:

```powershell
.\install\Install-CobraTower.ps1 `
  -SourceMode Local `
  -SourceCachePath "C:\MarolaOT\source-cache"
```

O hash Git blob continua sendo validado. Um arquivo local alterado ou de outro commit será recusado.

## Backup

O instalador cria backups em:

```text
<vBot_4.8>\marolaot-scripts-backups\cobra-tower\<timestamp>
```

Cada backup contém:

- arquivos anteriores;
- `backup-manifest.json`;
- `install-report.json`;
- hashes SHA-256 dos arquivos instalados.

## Rollback

Restaurar o backup mais recente:

```powershell
.\rollback\Restore-CobraTower.ps1
```

Restaurar um backup específico:

```powershell
.\rollback\Restore-CobraTower.ps1 `
  -BackupPath "C:\...\marolaot-scripts-backups\cobra-tower\20260714-220000"
```

Após a restauração, AttackBot, HealBot, CaveBot e TargetBot são forçados para **OFF**.

## Primeiro teste

1. Execute o teste estático.
2. Instale o pacote.
3. Abra o cliente e mantenha todos os módulos desligados.
4. Selecione `[550+] Cobra Tower DRY RUN`.
5. Verifique supplies, seleção de perfis e rota até o ponto seguro.
6. Valide combate local com CaveBot desligado.
7. Só então use a rota principal.

O checklist detalhado está em [`tests/CHECKLIST.md`](tests/CHECKLIST.md).

## Rotação ofensiva

| Prioridade | Condição | Ação | Trava local |
|---:|---|---|---:|
| 1 | 6+ Cobras com HP ≥ 35% | Rage of the Skies | 40,5 s |
| 2 | 3+ alinhadas | Energy Wave | 8,25 s |
| 3 | 3+ alinhadas | Great Fire Wave | 4,25 s |
| 4 | 2+ no melhor tile | Great Fireball Rune | 2 s |
| 5 | Alvo isolado com HP ≥ 30% | Ultimate Energy Strike | 30,5 s |
| 6 | Alvo restante | Sudden Death Rune | 2 s |

## Gate para M7

- [x] manifesto e source lock;
- [x] commit e blobs fixados;
- [x] perfis separados;
- [x] instalador específico;
- [x] rollback específico;
- [x] inventário;
- [x] teste estático;
- [x] checksums;
- [ ] CI verde no pull request;
- [ ] instalação a partir de clone limpo;
- [ ] dry-run controlado;
- [ ] rollback validado;
- [ ] release `cobra-tower-v1.0.0`.
