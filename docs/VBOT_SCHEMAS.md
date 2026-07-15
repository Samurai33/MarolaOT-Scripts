# Schemas e validação do vBot 4.8

Este documento descreve a primeira entrega do bloco **P3 — validação estrutural e CI**.

## Objetivo

Detectar configurações incompatíveis antes de abrir o MarolaOT Client.

A validação combina:

1. JSON Schema Draft 2020-12;
2. regras semânticas em Python;
3. exemplos válidos versionados;
4. fixtures negativos que devem obrigatoriamente falhar;
5. execução automática no GitHub Actions.

## Fontes técnicas

Os schemas foram derivados do upstream `OTCv8/otclientv8`, fixado no commit:

```text
aacfe3f1fe4bcadb5a34ff1f36263e1c96b3dd32
```

Arquivos principais auditados:

```text
modules/game_bot/default_configs/vBot_4.8/vBot/configs.lua
modules/game_bot/default_configs/vBot_4.8/vBot/AttackBot.lua
modules/game_bot/default_configs/vBot_4.8/vBot/HealBot.lua
modules/game_bot/default_configs/vBot_4.8/vBot/supplies.lua
modules/game_bot/default_configs/vBot_4.8/targetbot/creature_editor.lua
```

Também foram considerados os exemplos já validados no MarolaOT e configurações comunitárias somente como referência estrutural.

## Schemas

| Schema | Arquivo | Escopo |
|---|---|---|
| AttackBot | [`attackbot.schema.json`](../schemas/vbot-4.8/attackbot.schema.json) | cinco perfis, rotação e categorias de ataque |
| HealBot | [`healbot.schema.json`](../schemas/vbot-4.8/healbot.schema.json) | cinco perfis, spells, itens e condições |
| Supplies | [`supplies.schema.json`](../schemas/vbot-4.8/supplies.schema.json) | perfis dinâmicos, itens, mínimos e máximos |
| TargetBot | [`targetbot.schema.json`](../schemas/vbot-4.8/targetbot.schema.json) | targeting, lure, posicionamento, ataques legados e looting |

## Regras importantes

### AttackBot

- exige exatamente cinco perfis;
- `currentBotProfile` deve estar entre 1 e 5;
- perfis versionados devem permanecer desligados;
- categorias válidas: 1 a 5;
- `patternCategory` deve corresponder à categoria;
- runas de área e targeted runes exigem `itemId >= 100`;
- spells exigem fórmula não vazia;
- `minHp` não pode ser maior que `maxHp`.

Categorias reconhecidas:

| Categoria | Tipo | Pattern category |
|---:|---|---:|
| 1 | Targeted Spell | 1 |
| 2 | Area Rune | 2 |
| 3 | Targeted Rune | 3 |
| 4 | Empowerment | 3 |
| 5 | Absolute Spell | 4 |

### HealBot

- exige exatamente cinco perfis;
- perfis versionados devem permanecer desligados;
- origens válidas: `MP`, `HP`, `MP%`, `HP%`, `burst`;
- sinais válidos: `>`, `<`, `=`;
- itens devem possuir ID maior ou igual a 100;
- índices não podem se repetir dentro de uma tabela.

### Supplies

- exige `currentProfile`;
- o perfil selecionado deve existir;
- IDs são chaves numéricas em formato de string;
- cada item exige `min`, `max` e `avg`;
- mínimo não pode ser maior que máximo;
- valores numéricos ou strings numéricas são aceitos para compatibilidade.

### TargetBot

- exige `looting` e ao menos uma entrada em `targeting`;
- prioridade e perigo ficam entre 0 e 10;
- distância máxima fica entre 1 e 10;
- nomes de entradas não podem se repetir;
- `lureMin` não pode superar `lureMax`;
- regex deve ser compilável pelo validador;
- propriedades desconhecidas são recusadas;
- campos legados de ataque e campos atuais do editor são reconhecidos.

## Validador

Arquivo:

```text
scripts/validation/validate_vbot_schemas.py
```

Executar localmente:

```powershell
python -m pip install "jsonschema>=4.22,<5"
python scripts/validation/validate_vbot_schemas.py
```

O script:

- verifica se os quatro schemas são válidos;
- descobre configurações versionadas pelos nomes e diretórios conhecidos;
- aplica JSON Schema;
- aplica regras semânticas adicionais;
- exige módulos desligados nos exemplos distribuídos;
- confirma que cada fixture negativo é rejeitado;
- emite anotações de erro compatíveis com GitHub Actions.

## Exemplos válidos

```text
configs/vbot-4.8/examples/AttackBot.example.json
configs/vbot-4.8/examples/HealBot.example.json
configs/vbot-4.8/examples/Supplies.example.json
configs/vbot-4.8/examples/TargetBot.example.json
```

## Fixtures negativos

```text
tests/fixtures/vbot-schemas/invalid/attackbot.invalid.json
tests/fixtures/vbot-schemas/invalid/healbot.invalid.json
tests/fixtures/vbot-schemas/invalid/supplies.invalid.json
tests/fixtures/vbot-schemas/invalid/targetbot.invalid.json
```

Esses arquivos são JSON sintaticamente válido, mas devem falhar por problemas estruturais ou semânticos.

## CI

Workflow:

```text
.github/workflows/validate-vbot-schemas.yml
```

O workflow executa em alterações nos schemas, exemplos, fixtures, validador e configurações vBot conhecidas.

## Limites desta entrega

Ainda não fazem parte desta etapa:

- parser de waypoints CaveBot;
- validação de labels e destinos de `gotolabel`;
- confirmação de IDs contra o servidor;
- validação de cooldowns contra scripts de spells;
- schemas dos fragmentos de pacote usados pelos instaladores;
- migração automática de formatos legados.

Esses itens permanecem no roadmap do P3.
