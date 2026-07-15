# Skills e subagentes do MarolaOT-Scripts

## Princípio de carregamento

O `CLAUDE.md` contém somente regras permanentes. Skills carregam procedimentos completos sob demanda; subagentes executam pesquisas e revisões volumosas em contexto separado.

Essa separação reduz contexto inicial, evita duplicação e facilita auditoria.

## Skills disponíveis

| Skill | Entrada | Finalidade | Saída obrigatória |
|---|---|---|---|
| `/issue-to-pr` | número da issue | conduzir uma issue até PR revisável | branch, commits, testes, PR e gates |
| `/research-reference` | hunt, quest ou tópico | auditar fontes oficiais/comunitárias | evidências, licença, revisão e lacunas |
| `/create-hunt-package` | slug do pacote | criar/avançar uma hunt | pacote separado, testes, rollback e maturidade |
| `/create-quest-package` | slug da quest | criar quest assistida por segmentos | evidência, checkpoints e plano de rota |
| `/validate-package` | caminho | executar validação aplicável | matriz passed/failed/not run |
| `/quality-loop` | check de aceite | corrigir até o check passar | histórico bounded de iterações |
| `/token-audit` | ID da tarefa | medir economia real | baseline, otimizado e decisão |
| `/review-pr` | número do PR | revisão independente | achados reproduzíveis e recomendação |

Todas as skills usam `disable-model-invocation: true`: a execução depende de invocação explícita, evitando ativação acidental e consumo desnecessário.

## Exemplos

```text
/issue-to-pr 13
/research-reference Werehyaenas
/create-hunt-package cobra-tower
/create-quest-package the-new-frontier
/validate-package quests/access/the-new-frontier
/quality-loop python .claude/validation/validate_claude_workspace.py
/token-audit quest-m2-baseline
/review-pr 12
```

## Subagentes disponíveis

| Agente | Modelo | Contexto | Ferramentas | Uso |
|---|---|---|---|---|
| `reference-researcher` | Haiku | isolado | leitura, busca e web | fontes, revisões, licenças e lacunas |
| `package-architect` | Sonnet | isolado | leitura local | plano de pacote e gates |
| `security-reviewer` | Sonnet | isolado | leitura e shell read-only | segurança, supply chain e rollback |
| `docs-reviewer` | Haiku | isolado | leitura e web | consistência factual e links |
| `token-auditor` | Haiku | isolado | leitura local | contexto permanente e benchmarks |

Os agentes estão em `permissionMode: plan` e não possuem `Write` ou `Edit`.

## Roteamento recomendado

### Pesquisa ampla

Use `reference-researcher` quando a tarefa exigir muitas páginas, repositórios, arquivos, nomes alternativos ou comparação de licenças.

O agente deve devolver somente:

- fontes prioritárias;
- revisão/commit;
- paths relevantes;
- licença;
- fatos confirmados;
- contradições;
- blocker do próximo nível.

### Planejamento de pacote

Use `package-architect` antes de alterar muitos arquivos ou promover maturidade. Ele define árvore, contratos, rollback e testes sem escrever código.

### Segurança

Use `security-reviewer` para alterações em:

```text
.claude/
.github/
scripts/
install/
rollback/
releases
permissões
hooks
MCP
```

### Documentação

Use `docs-reviewer` após sincronizar README, manifestos, catálogo e changelog. Ele não deve sugerir preferências estilísticas sem impacto factual.

### Tokens

Use `token-auditor` com métricas reais da sessão. Ele não pode estimar uma porcentagem sem baseline comparável.

## Quando não delegar

Não use subagente quando:

- a resposta cabe em uma leitura curta;
- o agente repetiria exatamente os mesmos arquivos do contexto principal;
- a tarefa exige mutação supervisionada;
- o custo de preparar o handoff supera a leitura;
- o resultado não possui um formato objetivo.

## Contrato de handoff

O prompt de delegação deve conter:

1. objetivo único;
2. paths ou fontes permitidos;
3. perguntas que precisam ser respondidas;
4. formato da saída;
5. proibições;
6. limite de turnos;
7. critério de conclusão.

Exemplo:

```text
Pesquise somente fontes oficiais e repositórios públicos para X.
Retorne uma tabela com URL, commit, path, licença, componentes e lacunas.
Não copie arquivos nem proponha coordenadas.
Pare após encontrar uma fonte completa ou provar o blocker.
```

## Skills versus subagentes

| Situação | Escolha |
|---|---|
| Procedimento conhecido e repetitivo | skill |
| Grande volume de leitura | subagente |
| Ação determinística após tool call | hook |
| Limite estático de segurança | permission deny/ask |
| Regra permanente | `CLAUDE.md` |
| Regra específica de path | `.claude/rules/` |

## Manutenção

- revise descrições para garantir que não se sobreponham;
- mantenha exemplos grandes fora do `SKILL.md`;
- não adicione modelo Opus como padrão de subagente;
- evite memória persistente sem política de limpeza;
- atualize o validador quando uma skill ou agente for adicionado;
- confirme a interface instalada pela documentação oficial após upgrades.

## Fontes oficiais

- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/sub-agents
- https://code.claude.com/docs/en/best-practices
- https://code.claude.com/docs/en/costs
