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
- Workspace moderno do Claude Code com `CLAUDE.md`, rules condicionais, skills sob demanda e subagentes read-only.
- Oito skills para pesquisa, pacotes, validação, Issue → PR, revisão, quality loop e auditoria de tokens.
- Cinco subagentes especializados para pesquisa, arquitetura, segurança, documentação e eficiência de contexto.
- Hooks PowerShell opt-in para segurança, validação pós-escrita e auditoria de instruções carregadas.
- Estratégia mensurável de economia de tokens com meta operacional de 40–70% em fluxos repetitivos.
- Documentação de loops, segurança, modelo operacional, métricas e prompt caching.
- Validador e GitHub Actions específicos para a configuração Claude Code.

### Changed

- README reconstruído com badges reais de CI, navegação, matriz de maturidade, Mermaid, segurança, compatibilidade e roadmap por prioridades.
- Catálogo atualizado para distinguir ideia, referência, adaptação, teste e release.
- Summer Court reclassificada como pesquisa M0/M1, sem rota executável ou status inflado.
- Expansão de hunts passou a exigir evidência, commit, licença e componentes mínimos.
- Estado local, memória, hooks e settings locais do Claude Code passaram a ser ignorados pelo Git.

### Security

- Redistribuição de conteúdo comunitário passou a depender de auditoria de licença.
- Novos pacotes exigem backup, rollback, módulos desligados e proibição de segredos no manifesto.
- `bypassPermissions` foi desabilitado na configuração do Claude Code.
- Arquivos de ambiente, credenciais, chaves privadas e operações Git destrutivas receberam regras de negação.
- Hooks permanecem desativados por padrão e exigem revisão e ativação local explícita.
