# Cobra Tower MAX DPS v2 — Master Sorcerer 550+

> **Maturidade:** M6 — validado no ambiente MarolaOT; consolidação para M7 em andamento.

Este diretório inicia o bloco **P1**: transformar a configuração funcional da Cobra Tower em um pacote autocontido, reproduzível e versionado.

## Estado atual

| Componente | Estado | Origem atual |
|---|---|---|
| Source manifest | Criado | [`source-manifest.json`](source-manifest.json) |
| Instalador | Funcional | [`Set-CobraTowerMaxDpsV2.ps1`](../../../scripts/windows/vbot/Set-CobraTowerMaxDpsV2.ps1) |
| Diagnóstico | Funcional | scripts globais em `scripts/windows/vbot` |
| CaveBot | Validado localmente | Ainda precisa ser empacotado neste diretório |
| TargetBot | Validado localmente | Ainda precisa ser empacotado neste diretório |
| AttackBot | Validado | Gerado pelo instalador |
| HealBot | Validado | Gerado pelo instalador |
| Supplies | Validado | Gerado pelo instalador |
| Refill | Validado | Mehkesh e Fenech |
| Rollback específico | Parcial | Restauração global disponível; pacote dedicado pendente |
| Release | Pendente | Alvo: `cobra-tower-v1.0.0` |

## Objetivo do P1

Criar um pacote que possa ser instalado e removido a partir de um clone limpo, sem depender de arquivos externos não documentados.

## Estrutura alvo

```text
cobra-tower/
├── README.md
├── source-manifest.json
├── cavebot/
│   └── cobra-tower.cfg
├── targetbot/
│   └── cobra.json
├── configs/
│   ├── AttackBot.profile.json
│   ├── HealBot.profile.json
│   └── Supplies.profile.json
├── install/
│   └── Install-CobraTower.ps1
├── rollback/
│   └── Restore-CobraTower.ps1
├── tests/
│   ├── Test-CobraTowerPackage.ps1
│   └── CHECKLIST.md
└── checksums.sha256
```

## Pendências para M7

- [ ] fixar commit do upstream OTCv8 usado como base estrutural;
- [ ] revisar a licença da referência comunitária;
- [ ] empacotar CaveBot adaptado sem redistribuir material não licenciado indevidamente;
- [ ] empacotar TargetBot adaptado;
- [ ] separar perfis gerados em arquivos de referência próprios;
- [ ] criar instalador específico do pacote;
- [ ] criar rollback específico do pacote;
- [ ] adicionar teste estático do inventário;
- [ ] gerar checksums;
- [ ] documentar evidência da volta completa;
- [ ] publicar release `cobra-tower-v1.0.0`.

## Segurança

- o instalador deve exigir cliente fechado;
- backup é obrigatório antes de gravar arquivos;
- todos os módulos devem terminar desligados;
- o primeiro teste de combate ocorre com CaveBot desligado;
- o rollback deve ser testado antes da release.
