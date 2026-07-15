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
- Manifesto M1 e documentação de pesquisa de Werehyaenas.
- Padrão seguro de automação assistida para quests.
- Primeiro pacote de quest assistida: The Order of the Falcon em M2.
- Checklist por etapas, source lock, evidências de storages e plano de captura da rota Falcon.
- Workflow de segurança que impede CaveBot, instalador e automação de boss enquanto a quest estiver em M2.

### Changed

- README reconstruído com badges reais de CI, navegação, matriz de maturidade, Mermaid, segurança, compatibilidade e roadmap por prioridades.
- Catálogo atualizado para distinguir ideia, referência, adaptação, teste e release.
- Summer Court reclassificada como pesquisa M0/M1, sem rota executável ou status inflado.
- Expansão de hunts passou a exigir evidência, commit, licença e componentes mínimos.
- Falcon Bastion Access foi substituída pela quest auditada The Order of the Falcon no catálogo de quests.

### Security

- Redistribuição de conteúdo comunitário passou a depender de auditoria de licença.
- Novos pacotes exigem backup, rollback, módulos desligados e proibição de segredos no manifesto.
- Ritual, minibosses, barcos não validados, portal, alavanca e Grand Master Oberon são checkpoints manuais obrigatórios.
