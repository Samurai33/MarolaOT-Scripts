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
- Pacote Cobra Tower `1.0.0-rc.1` com source lock, inventário, perfis separados, instalador transacional, dry-run, rollback específico, testes e checksums.
- Workflow Windows dedicado à validação do pacote Cobra Tower.
- Manifesto M1 e documentação de pesquisa de Werehyaenas.
- Padrão seguro de automação assistida para quests.

### Changed

- README reconstruído com badges reais de CI, navegação, matriz de maturidade, Mermaid, segurança, compatibilidade e roadmap por prioridades.
- Catálogo atualizado para distinguir ideia, referência, adaptação, teste e release.
- Summer Court reclassificada como pesquisa M0/M1, sem rota executável ou status inflado.
- Expansão de hunts passou a exigir evidência, commit, licença e componentes mínimos.
- Cobra Tower passou a importar as referências comunitárias pelo commit e Git blob fixados, sem republicar os arquivos originais de licença não confirmada.

### Security

- Redistribuição de conteúdo comunitário passou a depender de auditoria de licença.
- Novos pacotes exigem backup, rollback, módulos desligados e proibição de segredos no manifesto.
- O instalador Cobra Tower tenta restaurar automaticamente o backup quando uma etapa falha após o início da gravação.
