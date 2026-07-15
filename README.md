<div align="center">
  <img src="assets/marolaot-scripts.svg" alt="MarolaOT Scripts" width="760">

  # MarolaOT Scripts

  **Automação, diagnóstico e manutenção segura para o ecossistema MarolaOT.**

  Scripts reproduzíveis para vBot 4.8, OTClient, Canary e rotinas administrativas do servidor.
</div>

## Visão geral

Este repositório centraliza scripts utilizados no MarolaOT com foco em segurança operacional, backup automático, validação antes e depois das alterações e possibilidade de rollback.

O primeiro pacote publicado prepara a hunt **MS Cobra Tower MAX DPS v2** para vBot 4.8, incluindo:

- rotação de ataque com cooldowns alinhados ao servidor;
- Rage of the Skies, Energy Wave, Great Fire Wave, GFB, Ultimate Energy Strike e SD;
- perfil de supplies para UMP, GFB e SD;
- HealBot e TargetBot preparados;
- looting interno desativado para uso do lootbag do servidor;
- backup completo e validações automáticas;
- módulos mantidos desligados após a instalação.

## Estrutura

```text
MarolaOT-Scripts/
├── .github/                    # CI, templates de issue e PR
├── assets/                     # Identidade visual
├── configs/vbot-4.8/examples/  # Exemplos de estrutura JSON
├── docs/                       # Documentação operacional
├── scripts/
│   ├── server/                 # Futuras rotinas Canary/Linux
│   └── windows/vbot/           # Automação do cliente/vBot
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
├── SECURITY.md
└── README.md
```

## Scripts disponíveis

### `Set-CobraTowerMaxDpsV2.ps1`

Configura a hunt Cobra Tower para Master Sorcerer com uma rotação agressiva e cooldowns compatíveis com o servidor.

### `Test-MarolaOTClientMatrix.ps1`

Testa a abertura do cliente com cada arquivo principal do vBot isoladamente e consulta eventos do Windows.

### `Restore-VBotCoreConfigs.ps1`

Restaura `AttackBot.json`, `HealBot.json` e `Supplies.json` a partir da quarentena mais recente.

### `Test-VBotJson.ps1`

Valida sintaxe, schema básico e estado dos módulos principais do vBot.

## Uso rápido

Abra o PowerShell como usuário `Samurai`, feche o MarolaOT e execute:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\scripts\windows\vbot\Set-CobraTowerMaxDpsV2.ps1
```

O caminho padrão utilizado é:

```text
C:\Users\Samurai\AppData\Roaming\marolaot\marolaot\marolaot\bot\vBot_4.8
```

Outro perfil pode ser informado explicitamente:

```powershell
.\scripts\windows\vbot\Set-CobraTowerMaxDpsV2.ps1 `
  -ProfilePath "C:\caminho\para\vBot_4.8"
```

## Rotação MAX DPS v2

| Prioridade | Condição | Ação | Trava local |
|---:|---|---|---:|
| 1 | 6+ Cobras, HP ≥ 35% | Rage of the Skies | 40,5 s |
| 2 | 3+ alinhadas | Energy Wave | 8,25 s |
| 3 | 3+ alinhadas | Great Fire Wave | 4,25 s |
| 4 | 2+ no melhor tile | Great Fireball Rune | 2 s |
| 5 | Alvo isolado, HP ≥ 30% | Ultimate Energy Strike | 30,5 s |
| 6 | Alvo restante | Sudden Death Rune | 2 s |

## Segurança operacional

- Nunca execute scripts de configuração com o cliente aberto.
- Todos os scripts de alteração criam backup antes de gravar arquivos.
- CaveBot, TargetBot, HealBot e AttackBot permanecem desligados ao final.
- Não versione senhas, tokens, dados de contas ou dumps do banco.
- Faça o primeiro teste fora de PZ com personagem GM e monstros criados localmente.

## Teste local recomendado

No jogo, com GM e fora de protection zone:

```text
/i 3191,300
/i 3155,300
/i 23373,200
/m Cobra Assassin,3,,2
```

Ative somente o AttackBot e o TargetBot durante o teste. O CaveBot deve permanecer desligado.

## Roadmap

- [ ] Publicar perfis adicionais por vocação e faixa de level.
- [ ] Adicionar sincronização segura entre servidor e cliente.
- [ ] Criar testes automáticos de schema para CaveBot e TargetBot.
- [ ] Adicionar scripts Canary para contas, personagens e manutenção.
- [ ] Criar sistema de releases versionadas para pacotes de hunt.

## Licença

Distribuído sob a licença MIT. Consulte [LICENSE](LICENSE).
