# Hunts

Esta área contém pacotes versionados de hunts para o MarolaOT.

## Organização

```text
hunts/<vocacao>/<faixa-de-level>/<hunt>/
```

Exemplo:

```text
hunts/ms/500-699/summer-court/
```

## Conteúdo esperado

- `README.md`: requisitos, estratégia, riscos e instruções de uso;
- `cavebot/`: rota principal e variantes de teste;
- `targetbot/`: monstros, prioridades, lure e regras de loot;
- `configs/`: AttackBot, HealBot e Supplies;
- `install/`: instalador com backup e validações;
- `tests/`: testes locais e checklist da rota.

## Regras de qualidade

1. Nunca importar `storage/profile_1.json` de terceiros.
2. Não presumir IDs customizados sem validar no MarolaOT.
3. Alinhar cooldowns locais com o servidor.
4. Manter módulos desligados ao final da instalação.
5. Criar primeiro uma rota de teste que não entre na hunt automaticamente.
6. Documentar NPCs, supplies, capacidade mínima e condições de retorno.
7. Confirmar se o loot será feito pelo vBot ou pelo lootbag do servidor.

## Faixas sugeridas

- `200-349`
- `350-449`
- `450-599`
- `500-699`
- `700-plus`

Consulte o [catálogo geral](../docs/CATALOG.md) para acompanhar o status de cada pacote.
