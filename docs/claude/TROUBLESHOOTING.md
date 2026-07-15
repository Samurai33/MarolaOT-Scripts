# Troubleshooting do Claude Code

## Diagnóstico mínimo

Na raiz do repositório:

```powershell
claude --version
claude doctor
git status --short --branch
python .\.claude\validation\validate_claude_workspace.py
```

Dentro do Claude Code:

```text
/doctor
/memory
/context
/permissions
/agents
/hooks
```

Registre a versão, shell ativo, branch, erro completo e configuração de origem antes de alterar arquivos.

## `claude` não é reconhecido

1. feche e reabra o terminal;
2. execute `Get-Command claude -All`;
3. verifique instalação duplicada;
4. execute novamente o instalador oficial ou WinGet;
5. confirme com `claude --version`.

Não crie aliases improvisados antes de descobrir onde o binário foi instalado.

## Bash não funciona no Windows

Confirme o Git for Windows:

```powershell
Test-Path 'C:\Program Files\Git\bin\bash.exe'
& 'C:\Program Files\Git\bin\bash.exe' --version
```

Quando necessário, configure em `.claude/settings.local.json`:

```json
{
  "env": {
    "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe"
  }
}
```

Reabra o Claude Code e execute `/doctor`.

## PowerShell tool não aparece

O PowerShell tool possui disponibilidade/versionamento próprios no Windows. Confirme a documentação oficial e a versão instalada.

Configuração local de opt-in quando suportada:

```json
{
  "env": {
    "CLAUDE_CODE_USE_POWERSHELL_TOOL": "1"
  }
}
```

Não versione essa preferência no settings compartilhado.

## `CLAUDE.md` ou rules não carregam

1. confirme que o Claude foi aberto na raiz;
2. execute `/memory`;
3. confira nome e caixa de `CLAUDE.md`;
4. valide frontmatter das rules;
5. acesse um arquivo que corresponda ao `paths:` da rule;
6. use o hook `InstructionsLoaded` somente após revisão local;
7. execute o validador do workspace.

Rules condicionais não devem aparecer no início quando nenhum path correspondente foi acessado.

## Skill não aparece

Confirme:

```text
.claude/skills/<nome>/SKILL.md
```

O arquivo precisa conter frontmatter com `name` e `description`. Neste projeto também deve conter:

```yaml
disable-model-invocation: true
```

Execute o validador e reabra a sessão. Use `/help` para verificar comandos disponíveis na versão instalada.

## Subagente não aparece

Confirme:

- arquivo em `.claude/agents/<nome>.md`;
- frontmatter válido;
- `name` único;
- `tools` existentes;
- `permissionMode: plan`;
- modelo disponível para a conta/provedor.

Execute `/agents` e o validador.

## Hook não dispara

1. confirme que o hook foi ativado em `.claude/settings.local.json`;
2. abra `/hooks` e confira origem/evento/matcher;
3. confirme que o comando `powershell` resolve no terminal;
4. execute o script manualmente com JSON de teste;
5. confira `.claude/runtime/`;
6. lembre que `InstructionsLoaded` é assíncrono e não bloqueia.

Teste manual seguro:

```powershell
'{"tool_name":"Edit","tool_input":{"file_path":"README.md"}}' |
  powershell -NoProfile -ExecutionPolicy Bypass `
    -File .\.claude\hooks\pretool-security.ps1
```

Para rollback, remova o bloco local de hooks e reabra a sessão.

## Hook bloqueia um arquivo legítimo

Não desative toda a proteção.

1. capture somente o path e a regra correspondente;
2. determine se o nome realmente representa credencial/chave;
3. crie uma exceção estreita e testável;
4. adicione caso positivo e negativo ao validador/teste;
5. revise com `security-reviewer`.

O projeto evita padrões genéricos como `*secret*`, pois nomes legítimos de quests podem conter essa palavra.

## Contexto inicial alto

Execute `/context` e identifique a categoria dominante.

Correções por ordem:

1. remover duplicação do `CLAUDE.md`;
2. mover procedimentos para skills;
3. restringir rules com `paths:`;
4. remover imports amplos;
5. desativar MCP não utilizado;
6. iniciar sessão na raiz correta;
7. limpar memórias obsoletas em `/memory`;
8. comparar com o baseline em `METRICS.md`.

## Consumo cresce durante a tarefa

- use `/clear` ao mudar de issue;
- use `/compact <foco>` antes de uma nova fase longa;
- filtre logs com comandos locais;
- delegue pesquisas e reviews volumosos;
- evite trocar modelo/settings/tools sem necessidade;
- pare loops após a condição de sucesso;
- execute `/token-audit` para fluxos repetitivos.

## Cache parece não ser reutilizado

Possíveis causas:

- mudança de modelo;
- mudança de diretório;
- alteração em `CLAUDE.md` ou settings;
- tools/MCP diferentes;
- pausa superior à janela de cache do provedor;
- prefixo da conversa alterado por configuração.

Mantenha condições equivalentes antes de comparar custos.

## Validador falha

Execute diretamente:

```powershell
python .\.claude\validation\validate_claude_workspace.py
```

Corrija o primeiro erro acionável. Não remova checks ou reduza segurança para obter verde.

Falhas comuns:

- `CLAUDE.md` acima de 200 linhas;
- skill sem frontmatter;
- agente com `Write`/`Edit`;
- hooks ativados no settings compartilhado;
- regra sem `paths:`;
- JSON inválido;
- possível segredo;
- conjunto esperado de skills/agentes desatualizado.

## Permissão inesperada

Use `/permissions` para descobrir a origem da regra. A precedência é aplicada pelas camadas de configuração do Claude Code; uma regra local/usuário/gerenciada pode alterar o comportamento do projeto.

Não resolva com `bypassPermissions`. Ajuste a regra na origem correta e preserve confirmação para ações Git ou shell sensíveis.

## CI falha, mas local passa

Compare:

- sistema operacional do runner;
- PowerShell/pwsh;
- Python;
- finais de linha;
- encoding;
- arquivos ignorados localmente;
- merge commit do PR;
- versão de dependências.

Abra o log completo do job e corrija a causa reproduzível.

## Instalações duplicadas

Execute:

```powershell
Get-Command claude -All | Format-List Source,Version
where.exe claude
```

Use `claude doctor` para identificar o método ativo. Remova a instalação antiga pelo método correspondente, sem excluir configurações antes de fazer backup.

## Fontes oficiais

- https://code.claude.com/docs/en/setup
- https://code.claude.com/docs/en/troubleshooting
- https://code.claude.com/docs/en/memory
- https://code.claude.com/docs/en/hooks
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/costs
