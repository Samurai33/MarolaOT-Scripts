# Changelog

Todas as mudanças relevantes serão documentadas neste arquivo.

## [Unreleased]

### Added

- Estrutura inicial do repositório.
- Instalador Cobra Tower MAX DPS v2.
- Diagnóstico matricial de inicialização do cliente.
- Restauração de configurações isoladas do vBot.
- Validação básica de JSON e schema do AttackBot.
- Workflows para PowerShell e JSON.
- Catálogo central de hunts e quests.
- Modelo de maturidade M0–M7.
- Blocos de prioridade P0–P5.
- Registro auditável de fontes oficiais e comunitárias.
- Schema JSON do manifesto de origem.
- Template de manifesto para novos pacotes.
- Manifesto M6 da Cobra Tower.
- Pacote documental inicial da Cobra Tower para consolidação M7.
- Padrão seguro de automação assistida para quests.
- `source-lock.json` auditável para Werehyaenas.
- Evidências estruturadas de criaturas e acesso Ancient Feud.
- Relatório aprofundado de pesquisa do pacote Werehyaenas.
- Validador M2 que impede CaveBot, instalador e código externo prematuros.
- Workflow dedicado `Werehyaenas Research`.

### Changed

- README reconstruído com badges reais de CI, navegação, matriz de maturidade, Mermaid, segurança, compatibilidade e roadmap por prioridades.
- Catálogo atualizado para distinguir ideia, referência, adaptação, teste e release.
- Summer Court reclassificada como pesquisa M0/M1, sem rota executável ou status inflado.
- Expansão de hunts passou a exigir evidência, commit, licença e componentes mínimos.
- Werehyaenas promovida de M1 para M2 após auditoria de fontes, hashes, licenças, monstros e acesso.
- Registro central de fontes passou a incluir o Canary fixado e a política `reference-only` do TargetBot comunitário.
- P2 agora registra explicitamente que a busca profunda não confirmou CaveBot ou refill público reproduzível.

### Security

- Redistribuição de conteúdo comunitário passou a depender de auditoria de licença.
- Novos pacotes exigem backup, rollback, módulos desligados e proibição de segredos no manifesto.
- TargetBot de Werehyaenas permanece apenas como referência porque a origem não declara licença.
- O pacote M2 de Werehyaenas recusa diretórios executáveis e arquivos `.cfg`/`.lua` até cumprir o gate M3.
