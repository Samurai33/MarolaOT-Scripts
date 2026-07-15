# Blocos de Prioridade

Este documento organiza a evolução do **MarolaOT-Scripts** em blocos sequenciais. Um bloco só avança quando seus critérios de saída são cumpridos.

## Princípios de execução

1. **Evidência antes de implementação** — nenhuma rota é criada sem fonte verificável ou captura própria documentada.
2. **Origem reproduzível** — repositório, caminho, commit e licença devem ser registrados.
3. **Seguro por padrão** — instaladores terminam com todos os módulos desligados.
4. **Mudança reversível** — backup e rollback são requisitos, não opcionais.
5. **Status honesto** — pesquisa, adaptação, teste local e validação de rota são estados diferentes.
6. **Sem credenciais** — contas, senhas, tokens, IPs privados e dumps reais não entram no Git.

## Modelo de maturidade

| Nível | Estado | Definição |
|---:|---|---|
| M0 | Ideia | Nome ou objetivo sem fonte técnica suficiente |
| M1 | Referência encontrada | Fonte pública identificada, ainda não auditada |
| M2 | Referência auditada | Commit, arquivos, dependências e licença registrados |
| M3 | Adaptado | Arquivos convertidos para o layout do MarolaOT/vBot 4.8 |
| M4 | Teste local | JSONs, combate e módulos validados fora da rota |
| M5 | Rota controlada | Refill, entrada, loop e retorno testados de forma controlada |
| M6 | Validado | Uma volta completa, rollback e documentação confirmados |
| M7 | Release | Pacote versionado, checksums e notas de versão publicados |

## P0 — Fundação e governança

**Objetivo:** tornar toda futura adaptação rastreável e verificável.

### Entregáveis

- [x] README orientado por evidência e segurança.
- [x] Registro central de fontes comunitárias e oficiais.
- [x] Blocos de prioridade e modelo de maturidade.
- [x] Schema do manifesto de origem.
- [x] Exemplo de manifesto válido.
- [ ] Validação automática do manifesto no CI.
- [ ] Template de issue para nova referência de hunt/quest.

### Critério de saída

Todo novo pacote deve possuir um `source-manifest.json` válido antes de receber arquivos de CaveBot, TargetBot ou configuração.

## P1 — Consolidar Cobra Tower como release de referência

**Objetivo:** transformar a automação já funcional em um pacote M7 que sirva de padrão para todas as próximas hunts.

### Entregáveis

- [ ] Reorganizar Cobra Tower em pacote autocontido.
- [ ] Incluir CaveBot, TargetBot, configs, instalador, testes e rollback.
- [ ] Registrar fonte comunitária e commit fixo.
- [ ] Documentar diferenças entre upstream e MarolaOT.
- [ ] Adicionar checksums e inventário dos arquivos instalados.
- [ ] Criar release `cobra-tower-v1.0.0`.

### Critério de saída

Instalação e restauração reproduzíveis a partir de um clone limpo, com todos os módulos desligados ao final.

## P2 — Werehyaenas: reconstrução orientada por referência

**Objetivo:** promover Werehyaenas de referência parcial para pacote adaptável, sem inventar rota.

### Evidência disponível

- TargetBot comunitário localizado no repositório `Kolczan/Tibia-Scripts`.
- Monstros identificados: `Werehyaena` e `Werehyaena Shaman`.
- Rota CaveBot e refill completos ainda não confirmados.

### Entregáveis

- [ ] Criar manifesto de origem com commit fixo.
- [ ] Auditar licença do material comunitário.
- [ ] Localizar CaveBot correspondente ou documentar captura própria.
- [ ] Mapear NPCs, supplies, acesso, entrada, loop e retorno.
- [ ] Portar TargetBot sem looting interno.
- [ ] Criar AttackBot, HealBot e Supplies com dados verificados.
- [ ] Produzir instalador e checklist de teste local.

### Critério de saída

Werehyaenas só entra em M3 quando CaveBot, refill e dependências estiverem documentados; possuir apenas TargetBot mantém o pacote em M2.

## P3 — Validação estrutural e CI

**Objetivo:** detectar regressões antes de qualquer teste no cliente.

### Entregáveis

- [ ] Schema para AttackBot, HealBot, Supplies e TargetBot.
- [ ] Parser estático de CaveBot para labels e ações conhecidas.
- [ ] Verificação de referências quebradas e arquivos ausentes.
- [ ] PSScriptAnalyzer sem warnings ou errors.
- [ ] Relatório de pacote gerado pelo CI.

### Critério de saída

Pull requests falham automaticamente quando um pacote estiver incompleto, com JSON inválido ou manifesto inconsistente.

## P4 — Framework seguro para quests e acessos

**Objetivo:** documentar e automatizar somente trechos reversíveis de quests.

### Entregáveis

- [ ] Manifesto de fonte e versão do servidor.
- [ ] Checklist por missão e storage.
- [ ] Waypoints com checkpoints manuais.
- [ ] Parada obrigatória antes de bosses, escolhas e consumo de itens raros.
- [ ] Validador de estado sem alterar o personagem.

### Critério de saída

Nenhum fluxo de quest executa decisão irreversível sem confirmação manual explícita.

## P5 — Expansão do catálogo

**Objetivo:** adicionar novas hunts apenas quando houver referência suficiente.

### Ordem de seleção

1. Pacote comunitário completo e compatível com vBot 4.8.
2. Pacote parcial forte com rota reconstruível por evidência.
3. Captura própria documentada, quando não houver referência pública licenciada.
4. Ideias sem rota permanecem em M0 e não recebem status “em desenvolvimento”.

### Candidatos atuais

- Werehyaenas — M2 parcial.
- Summer Court — M0/M1, sem pacote comunitário completo confirmado.
- Asura Mirror — M0/M1.
- Winter Court — M0/M1.
- Falcon Bastion — M0/M1.
- Issavi Sphinx/Lamassu — M0/M1.

## Definition of Done de uma hunt

- [ ] `source-manifest.json` válido.
- [ ] licença e atribuição documentadas.
- [ ] CaveBot e TargetBot completos.
- [ ] AttackBot, HealBot e Supplies separados.
- [ ] refill, entrada e retorno identificados.
- [ ] backup automático e rollback testado.
- [ ] módulos desligados após instalação.
- [ ] teste local documentado.
- [ ] uma volta completa sem loop ou waypoint impossível.
- [ ] changelog, checksums e release publicados.
