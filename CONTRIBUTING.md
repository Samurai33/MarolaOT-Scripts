# Contribuindo

## Padrões

1. Crie uma branch curta e descritiva.
2. Não inclua credenciais, dumps ou backups pessoais.
3. Scripts de alteração devem criar backup antes de gravar arquivos.
4. Scripts devem validar caminhos, formato JSON e estado final.
5. Módulos automáticos devem permanecer desligados após instalações ou migrações.
6. Use nomes de commits no padrão Conventional Commits.

## Commits

```text
feat(vbot): add new hunt profile
fix(cobra): align rage cooldown with server
chore(ci): validate json examples
```

## Pull requests

Descreva:

- problema resolvido;
- arquivos modificados;
- procedimento de teste;
- procedimento de rollback;
- riscos conhecidos.
