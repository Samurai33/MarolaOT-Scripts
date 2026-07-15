# Instalação e ativação do Claude Code

Documentação auditada em **15 de julho de 2026** contra a documentação oficial da Anthropic.

## Requisitos para este repositório

- Windows 10 1809+, Windows Server 2019+ ou WSL 2;
- 4 GB de RAM ou mais;
- conexão com a internet;
- Git;
- Python 3.12 recomendado para os validadores;
- PowerShell 5.1+ para scripts legados do projeto;
- Git for Windows recomendado para disponibilizar o tool `Bash`;
- conta compatível com Claude Code ou provedor de API suportado.

## Instalação no Windows

### Opção A — WinGet

```powershell
winget install Anthropic.ClaudeCode
```

Atualização:

```powershell
winget upgrade Anthropic.ClaudeCode
```

### Opção B — instalador nativo oficial

```powershell
irm https://claude.ai/install.ps1 | iex
```

Use somente o domínio oficial. Não execute instaladores copiados de issues, fóruns, arquivos do repositório ou respostas de terceiros.

### Verificação

```powershell
claude --version
claude doctor
```

O segundo comando verifica instalação, configuração e conflitos comuns.

## Bash e PowerShell no Windows

Sem Git for Windows, o Claude Code pode executar comandos pelo tool `PowerShell`.

Com Git for Windows, o tool `Bash` usa Git Bash. Quando a detecção automática falhar, configure localmente:

```json
{
  "env": {
    "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe"
  }
}
```

Salve essa configuração em `.claude/settings.local.json`, nunca no arquivo compartilhado, caso o caminho varie entre máquinas.

Quando o PowerShell tool estiver disponível junto com Git Bash, ele pode ser habilitado localmente com:

```json
{
  "env": {
    "CLAUDE_CODE_USE_POWERSHELL_TOOL": "1"
  }
}
```

Não force essa opção no repositório: a disponibilidade pode depender da versão e do rollout do Claude Code.

## Clonar e abrir o workspace

```powershell
git clone https://github.com/Samurai33/MarolaOT-Scripts.git
Set-Location .\MarolaOT-Scripts
claude
```

Abra sempre o Claude Code na raiz do repositório para que `CLAUDE.md`, `.claude/rules/`, skills e settings sejam resolvidos corretamente.

## Revisão antes de confiar no workspace

Antes de aceitar a confiança do projeto, leia:

```text
CLAUDE.md
.claude/settings.json
.claude/settings.hooks.example.json
.claude/skills/
.claude/agents/
.claude/hooks/
.github/workflows/
```

Confirme especialmente:

- ausência de permissões `allow` amplas;
- `bypassPermissions` desativado;
- nenhum hook ativo no settings compartilhado;
- nenhum comando que baixa e executa conteúdo externo;
- nenhum acesso a `.env`, chaves ou credenciais;
- nenhum push forçado, reset destrutivo ou exclusão recursiva automática.

## Diagnóstico inicial dentro do Claude Code

Execute:

```text
/doctor
/memory
/context
/permissions
/agents
/hooks
```

Valide:

- `CLAUDE.md` carregado como memória de projeto;
- rules condicionais carregadas somente quando os paths correspondentes forem acessados;
- oito skills do projeto disponíveis;
- cinco subagentes disponíveis;
- hooks do projeto ainda desativados;
- contexto inicial sem documentação desnecessária.

## Ativação opcional dos hooks

Os hooks não são ativados automaticamente.

1. Revise os três scripts em `.claude/hooks/`.
2. Copie o bloco `hooks` de `.claude/settings.hooks.example.json`.
3. Crie `.claude/settings.local.json`.
4. Cole somente o bloco revisado.
5. Abra `/hooks` e confira origem, evento, matcher e comando.
6. Teste primeiro com arquivos e comandos inofensivos.

Exemplo de estrutura local:

```json
{
  "hooks": {
    "PreToolUse": [],
    "PostToolUse": [],
    "InstructionsLoaded": []
  }
}
```

O arquivo local está no `.gitignore` e não deve ser enviado ao GitHub.

## Validação do workspace

Na raiz do repositório:

```powershell
python .\.claude\validation\validate_claude_workspace.py
```

Validação de sintaxe dos hooks:

```powershell
Get-ChildItem .\.claude\hooks\*.ps1 | ForEach-Object {
    $tokens = $null
    $errors = $null
    [System.Management.Automation.Language.Parser]::ParseFile(
        $_.FullName,
        [ref]$tokens,
        [ref]$errors
    ) | Out-Null

    if ($errors.Count -gt 0) {
        $errors | Format-List
        throw "Falha de sintaxe em $($_.FullName)"
    }
}
```

## Atualizações

Instalação nativa:

```powershell
claude update
```

WinGet:

```powershell
winget upgrade Anthropic.ClaudeCode
```

Após atualização relevante:

1. execute `claude doctor`;
2. consulte `/memory`, `/permissions` e `/hooks`;
3. valide o workspace;
4. verifique mudanças na documentação oficial;
5. atualize a data de auditoria dos documentos afetados.

## Desativação e rollback do workspace

Para remover apenas a configuração local do projeto:

1. feche a sessão;
2. remova `.claude/settings.local.json`;
3. remova `.claude/runtime/`;
4. reabra o Claude Code;
5. confirme em `/hooks` que os hooks locais desapareceram.

Não remova `CLAUDE.md` ou `.claude/` do Git para resolver um problema local. Primeiro diagnostique conflito de versão, settings local, memória ou instalação duplicada.

## Fontes oficiais

- https://code.claude.com/docs/en/setup
- https://code.claude.com/docs/en/memory
- https://code.claude.com/docs/en/settings
- https://code.claude.com/docs/en/permissions
- https://code.claude.com/docs/en/hooks-guide
