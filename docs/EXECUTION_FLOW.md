# Fluxo de Execução

O desenvolvimento dos blocos de prioridade segue este fluxo:

```text
Issue → Branch → Commit → Pull Request → CI/Testes → Review → Merge → Release
```

## Convenções

### Issues

```text
[P0][Area] objetivo
[P1][Area] objetivo
[P2][Area] objetivo
```

### Branches

```text
feature/p1-cobra-tower-package
research/p2-werehyaenas-sources
fix/<descricao>
docs/<descricao>
```

### Commits

Use Conventional Commits:

```text
feat: adicionar instalador do pacote
fix: corrigir schema do TargetBot
docs: registrar fonte e licença
ci: validar manifestos
refactor: separar rollback do instalador
```

## Gates obrigatórios

Antes do merge:

- manifesto de origem válido;
- CI verde;
- nenhum segredo versionado;
- backup e rollback documentados;
- módulos desligados após instalação;
- maturidade atualizada honestamente;
- changelog atualizado;
- evidências de teste anexadas à issue ou PR.

## Releases

Uma release de hunt deve incluir:

- versão semântica;
- inventário dos arquivos;
- checksums SHA-256;
- fontes e commits utilizados;
- requisitos e incompatibilidades;
- procedimento de instalação;
- procedimento de rollback;
- evidências da validação.
